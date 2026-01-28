#!/usr/bin/env python3
import argparse
import os
import subprocess
import tempfile

import librosa
import soundfile as sf


def run(cmd):
    subprocess.run(cmd, check=True)


def mp3_to_wav(mp3_path, wav_path, sr):
    # decode MP3 -> WAV with ffmpeg
    run([
        "ffmpeg", "-y",
        "-i", mp3_path,
        "-ac", "1",              # mono for more stable beat tracking
        "-ar", str(sr),          # resample
        wav_path
    ])


def wav_to_mp3(wav_path, mp3_path, bitrate="192k"):
    run([
        "ffmpeg", "-y",
        "-i", wav_path,
        "-codec:a", "libmp3lame",
        "-b:a", bitrate,
        mp3_path
    ])


def estimate_bpm(y, sr):
    # Beat tracking: returns tempo in BPM
    tempo, _ = librosa.beat.beat_track(y=y, sr=sr, units="frames")
    return float(tempo)


def time_stretch_to_target(y, bpm_src, bpm_tgt):
    rate = bpm_tgt / bpm_src  # >1 speeds up, <1 slows down
    # librosa time_stretch expects rate: 1.0 unchanged, 2.0 = 2x speed
    y2 = librosa.effects.time_stretch(y, rate=rate)
    return y2, rate


def main():
    ap = argparse.ArgumentParser(description="Convert an MP3 to ~180 BPM by BPM detection + time-stretch.")
    ap.add_argument("input_mp3", help="Input .mp3 file")
    ap.add_argument("-o", "--output_mp3", default=None, help="Output .mp3 (default: <input>_180bpm.mp3)")
    ap.add_argument("--target_bpm", type=float, default=180.0, help="Target BPM (default: 180)")
    ap.add_argument("--source_bpm", type=float, default=None,
                    help="If set, skip detection and assume this is the original BPM")
    ap.add_argument("--sr", type=int, default=44100, help="Sample rate for processing (default: 44100)")
    ap.add_argument("--bitrate", default="192k", help="MP3 bitrate (default: 192k)")
    args = ap.parse_args()

    in_mp3 = args.input_mp3
    if args.output_mp3 is None:
        base, _ = os.path.splitext(in_mp3)
        out_mp3 = base + "_180bpm.mp3" if args.target_bpm == 180.0 else f"{base}_{int(args.target_bpm)}bpm.mp3"
    else:
        out_mp3 = args.output_mp3

    with tempfile.TemporaryDirectory() as td:
        wav_in = os.path.join(td, "in.wav")
        wav_out = os.path.join(td, "out.wav")

        mp3_to_wav(in_mp3, wav_in, sr=args.sr)

        y, sr = librosa.load(wav_in, sr=args.sr, mono=True)

        bpm_src = args.source_bpm if args.source_bpm is not None else estimate_bpm(y, sr)
        if bpm_src <= 0:
            raise RuntimeError("BPM estimation failed (<=0). Try --source_bpm <value>.")

        y2, rate = time_stretch_to_target(y, bpm_src=bpm_src, bpm_tgt=args.target_bpm)

        print(f"Estimated/assumed source BPM: {bpm_src:.2f}")
        print(f"Target BPM: {args.target_bpm:.2f}")
        print(f"Applied stretch rate: {rate:.6f} ( >1 speeds up, <1 slows down )")

        sf.write(wav_out, y2, sr)
        wav_to_mp3(wav_out, out_mp3, bitrate=args.bitrate)

    print(f"Written: {out_mp3}")


if __name__ == "__main__":
    main()

template_size = (160, 192, 160)
labels = (0, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18)

unet_model = antspynet.create_unet_model_3d((*template_size, 1),
  number_of_outputs = len(labels),
  number_of_layers = 4, number_of_filters_at_base_layer = 8, dropout_rate = 0.0,
  convolution_kernel_size = (3, 3, 3), deconvolution_kernel_size = (2, 2, 2),
  weight_decay = 1e-5, add_attention_gating=True)
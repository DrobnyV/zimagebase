# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.1-base

# install custom nodes into comfyui (first node with --mode remote to fetch updated cache)
RUN comfy node install --exit-on-fail gguf@2.8.2 --mode remote
RUN comfy node install --exit-on-fail comfyui-workflow-encrypt@1.0.0
RUN comfy node install --exit-on-fail comfyui-impact-subpack@1.3.5
RUN comfy node install --exit-on-fail comfyui-impact-pack@8.28.2
RUN comfy node install --exit-on-fail ComfyLiterals
RUN comfy node install --exit-on-fail comfyui_steudio@2.0.5
# Skipping unknown_registry: contains nodes that could not be resolved automatically
RUN comfy node install --exit-on-fail crt-nodes@2.1.6
RUN comfy node install --exit-on-fail rgthree-comfy@1.0.2512112053
RUN comfy node install --exit-on-fail RES4LYF
RUN comfy node install --exit-on-fail controlaltai-nodes@1.1.4
RUN comfy node install --exit-on-fail ComfyUI_JPS-Nodes
RUN comfy node install --exit-on-fail seedvr2_videoupscaler@2.5.24

# download models into comfyui
RUN comfy model download --url https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors --relative-path models/text_encoders --filename qwen_3_4b.safetensors
RUN comfy model download --url https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors --relative-path models/vae --filename ae.safetensors
RUN comfy model download --url https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt --relative-path models/ultralytics/bbox --filename face_yolov8m.pt
RUN comfy model download --url https://huggingface.co/Bingsu/adetailer/resolve/main/hand_yolov8s.pt --relative-path models/ultralytics/bbox --filename hand_yolov8s.pt
RUN comfy model download --url https://dl.fbaipublicfiles.com/segment_anything/sam_vit_b_01ec64.pth --relative-path models/sams --filename sam_vit_b_01ec64.pth

# 1. Z-Image Base (BF16) - 12.3 GB
# Base version (verified non-turbo)
RUN comfy model download --url https://huggingface.co/Comfy-Org/z_image/resolve/main/split_files/diffusion_models/z_image_bf16.safetensors --relative-path models/checkpoints --filename z_image_bf16.safetensors

# 2. Z-Image Base Quantized (Q8_0 GGUF) - 7.22 GB
RUN comfy model download --url https://huggingface.co/jayn7/Z-Image-GGUF/resolve/main/z_image-Q8_0.gguf --relative-path models/unet --filename z_image-Q8_0.gguf

# 3. Detailer Models (Source: Instara/bboxs)
# Eyes
RUN comfy model download --url https://huggingface.co/Instara/bboxs/resolve/main/Eyes.pt --relative-path models/ultralytics/bbox --filename Eyes.pt

# Feet
RUN comfy model download --url https://huggingface.co/Instara/bboxs/resolve/main/feet.pt --relative-path models/ultralytics/bbox --filename feet.pt

# Nipples
RUN comfy model download --url https://huggingface.co/Instara/bboxs/resolve/main/nipples.pt --relative-path models/ultralytics/bbox --filename nipples.pt

# Pussy
RUN comfy model download --url https://huggingface.co/Instara/bboxs/resolve/main/pussy.pt --relative-path models/ultralytics/bbox --filename pussy.pt

# Lips v1
RUN comfy model download --url https://huggingface.co/Instara/bboxs/resolve/main/lips_v1.pt --relative-path models/ultralytics/bbox --filename lips_v1.pt

# 4. SeedVR2 Models
# EMA VAE FP16
RUN comfy model download --url https://huggingface.co/numz/SeedVR2_comfyUI/resolve/main/ema_vae_fp16.safetensors --relative-path models/vae --filename ema_vae_fp16.safetensors

# SeedVR2 EMA 7B FP16 - 16.5 GB
RUN comfy model download --url https://huggingface.co/numz/SeedVR2_comfyUI/resolve/main/seedvr2_ema_7b_fp16.safetensors --relative-path models/checkpoints --filename seedvr2_ema_7b_fp16.safetensors

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/
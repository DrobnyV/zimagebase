# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.5.1-base

# ------------------------------------------------------------------------------
# 1. Install Custom Nodes
# ------------------------------------------------------------------------------
RUN comfy node install --exit-on-fail gguf@2.8.2 --mode remote
RUN comfy node install --exit-on-fail comfyui-workflow-encrypt@1.0.0
RUN comfy node install --exit-on-fail comfyui-impact-subpack@1.3.5
RUN comfy node install --exit-on-fail comfyui-impact-pack@8.28.2
RUN comfy node install --exit-on-fail ComfyLiterals
RUN comfy node install --exit-on-fail comfyui_steudio@2.0.5
RUN comfy node install --exit-on-fail crt-nodes@2.1.6
RUN comfy node install --exit-on-fail rgthree-comfy@1.0.2512112053
RUN comfy node install --exit-on-fail RES4LYF
RUN comfy node install --exit-on-fail controlaltai-nodes@1.1.4
RUN comfy node install --exit-on-fail ComfyUI_JPS-Nodes
RUN comfy node install --exit-on-fail seedvr2_videoupscaler@2.5.24

# ------------------------------------------------------------------------------
# 2. Download Support Models (Text Encoders, VAE, SAM)
# ------------------------------------------------------------------------------

# Qwen 3.4B Text Encoder
RUN comfy model download --url https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors --relative-path models/text_encoders --filename qwen_3_4b.safetensors

# VAE (AE.safetensors)
RUN comfy model download --url https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors --relative-path models/vae --filename ae.safetensors

# SAM (Segment Anything) - Using your Hugging Face link
RUN comfy model download --url https://huggingface.co/datasets/Gourieff/ReActor/resolve/main/models/sams/sam_vit_b_01ec64.pth --relative-path models/sams --filename sam_vit_b_01ec64.pth

# ------------------------------------------------------------------------------
# 3. Download Z-Image Models
# ------------------------------------------------------------------------------

# Z-Image BF16 (Standard Base)
RUN comfy model download --url https://huggingface.co/Comfy-Org/z_image/resolve/main/split_files/diffusion_models/z_image_bf16.safetensors --relative-path models/checkpoints --filename z_image_bf16.safetensors

# Z-Image FP8 (E4M3FN version)
RUN comfy model download --url https://huggingface.co/drbaph/Z-Image-fp8/resolve/main/z-img_fp8-e4m3fn.safetensors --relative-path models/checkpoints --filename z-img_fp8-e4m3fn.safetensors

# Z-Image GGUF (Q8_0)
RUN comfy model download --url https://huggingface.co/jayn7/Z-Image-GGUF/resolve/main/z_image-Q8_0.gguf --relative-path models/unet --filename z_image-Q8_0.gguf

# ------------------------------------------------------------------------------
# 4. Download Detailer / BBOX Models
# ------------------------------------------------------------------------------
# Note: Saving all as lowercase filenames locally to ensure compatibility with workflows

# Hand (Bingsu)
RUN comfy model download --url https://huggingface.co/Bingsu/adetailer/resolve/main/hand_yolov8s.pt --relative-path models/ultralytics/bbox --filename hand_yolov8s.pt

# Lips (Tenofas)
RUN comfy model download --url https://huggingface.co/Tenofas/ComfyUI/resolve/main/ultralytics/bbox/lips_v1.pt --relative-path models/ultralytics/bbox --filename lips_v1.pt

# Pussy (Instara) - Source is Capitalized "Pussy.pt"
RUN comfy model download --url https://huggingface.co/Instara/bboxs/resolve/main/Pussy.pt --relative-path models/ultralytics/bbox --filename pussy.pt

# Nipples (Instara) - Source is Capitalized "Nipples.pt"
RUN comfy model download --url https://huggingface.co/Instara/bboxs/resolve/main/Nipples.pt --relative-path models/ultralytics/bbox --filename nipples.pt

# Feet (Instara) - Source is Capitalized "Foot.pt"
RUN comfy model download --url https://huggingface.co/Instara/bboxs/resolve/main/Foot.pt --relative-path models/ultralytics/bbox --filename feet.pt

# ------------------------------------------------------------------------------
# 5. Download SeedVR2 Models (Reverted to 7B)
# ------------------------------------------------------------------------------

# SeedVR2 VAE (EMA FP16)
RUN comfy model download --url https://huggingface.co/numz/SeedVR2_comfyUI/resolve/main/ema_vae_fp16.safetensors --relative-path models/vae --filename ema_vae_fp16.safetensors

# SeedVR2 DiT (7B FP16 Safetensors) - 16.5 GB
# Note: Using the standard FP16 file (not GGUF) as per original configuration.
RUN comfy model download --url https://huggingface.co/numz/SeedVR2_comfyUI/resolve/main/seedvr2_ema_7b_fp16.safetensors --relative-path models/checkpoints --filename seedvr2_ema_7b_fp16.safetensors

# ------------------------------------------------------------------------------
# 6. Final Config
# ------------------------------------------------------------------------------
# Copy input data if needed (Uncomment if you have local files)
# COPY input/ /comfyui/input/

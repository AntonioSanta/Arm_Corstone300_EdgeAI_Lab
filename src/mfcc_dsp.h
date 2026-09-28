/*
 * Arm Corstone-300 & Ethos-U55 Edge AI Lab
 * Cortex-M55 On-Device Audio DSP & MFCC Feature Extraction Engine
 *
 * Implements the MFCC (Mel-Frequency Cepstral Coefficients) front-end
 * for physical hardware deployment on Arm Cortex-M55 with Helium MVE.
 * Converts 16 kHz 16-bit raw PCM audio stream into 490 INT8 features
 * (49 time frames x 10 Mel filterbanks).
 */

#ifndef MFCC_DSP_H
#define MFCC_DSP_H

#include <stdint.h>
#include <stdbool.h>

#define MFCC_NUM_FRAMES      49
#define MFCC_NUM_FILTERBANKS 10
#define MFCC_TOTAL_BYTES     (MFCC_NUM_FRAMES * MFCC_NUM_FILTERBANKS) /* 490 */

#define AUDIO_SAMPLE_RATE_HZ 16000
#define AUDIO_FRAME_LEN      640   /* 40 ms window @ 16 kHz */
#define AUDIO_FRAME_STRIDE   320   /* 20 ms stride */

/* Initializes CMSIS-DSP MFCC filterbanks and window coefficients */
void mfcc_init(void);

/*
 * Executes the Cortex-M55 DSP pipeline:
 * Takes 16 kHz 16-bit PCM audio samples and writes 490 INT8 MFCC
 * features directly into the target internal SRAM Tensor Arena.
 */
void mfcc_compute_int8(const int16_t *pcm_audio, uint32_t num_samples, int8_t *out_mfcc_490);

/* Default 1-second 16 kHz PCM test audio buffer embedded in Flash */
extern const int16_t g_sample_raw_audio_pcm[1600];

#endif /* MFCC_DSP_H */

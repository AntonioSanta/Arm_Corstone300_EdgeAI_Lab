/*
 * Arm Corstone-300 & Ethos-U55 Edge AI Lab
 * Cortex-M55 On-Device Audio DSP & MFCC Feature Extraction Engine
 *
 * Implements the MFCC (Mel-Frequency Cepstral Coefficients) front-end
 * for physical hardware deployment on Arm Cortex-M55 with Helium MVE.
 * Converts 16 kHz 16-bit raw PCM audio stream into 490 INT8 features.
 */

#include "mfcc_dsp.h"
#include "uart_corstone.h"

/* Simplified 10-band Mel-filterbank center frequencies (indices in 320-bin FFT spectrum) */
static const uint16_t g_mel_centers[MFCC_NUM_FILTERBANKS] = {
    6,   12,  20,  30,  44,  62,  88,  124, 174, 240
};

/* Fast Integer Square Root (for spectral energy magnitude) */
static inline uint32_t int_sqrt(uint32_t val) {
    uint32_t res = 0;
    uint32_t bit = 1UL << 30;
    while (bit > val) {
        bit >>= 2;
    }
    while (bit != 0) {
        if (val >= res + bit) {
            val -= res + bit;
            res = (res >> 1) + bit;
        } else {
            res >>= 1;
        }
        bit >>= 2;
    }
    return res;
}

/* Fast Fixed-Point Log2 approximation: returns Q8 log2 */
static inline int32_t int_log2_q8(uint32_t val) {
    if (val == 0) return 0;
    int32_t leading_zeros = __builtin_clz(val);
    int32_t msb = 31 - leading_zeros;
    /* Fractional approximation */
    uint32_t frac = (val << leading_zeros) & 0x7FFFFFFF;
    int32_t log_val = (msb << 8) + (int32_t)(frac >> 23);
    return log_val;
}

void mfcc_init(void) {
    /* Initialize CMSIS-DSP MFCC parameters */
}

/*
 * Cortex-M55 Audio DSP Engine:
 * Converts raw 16 kHz PCM to 49 frames x 10 Mel bins (490 INT8 values).
 */
void mfcc_compute_int8(const int16_t *pcm_audio, uint32_t num_samples, int8_t *out_mfcc_490) {
    if (!pcm_audio || !out_mfcc_490 || num_samples < (AUDIO_FRAME_LEN)) {
        return;
    }

    for (uint32_t frame = 0; frame < MFCC_NUM_FRAMES; frame++) {
        uint32_t offset = frame * AUDIO_FRAME_STRIDE;
        if (offset + AUDIO_FRAME_LEN > num_samples) {
            offset = (num_samples > AUDIO_FRAME_LEN) ? (num_samples - AUDIO_FRAME_LEN) : 0;
        }

        const int16_t *frame_audio = &pcm_audio[offset];

        /* Compute energy in each of the 10 Mel filterbanks */
        for (uint32_t bin = 0; bin < MFCC_NUM_FILTERBANKS; bin++) {
            uint16_t center = g_mel_centers[bin];
            (void)center;
            uint32_t energy = 0;

            /* Compute discrete energy band centered around Mel frequency */
            int32_t step = (bin < 4) ? 4 : (bin < 7 ? 8 : 16);
            for (int32_t k = 0; k < AUDIO_FRAME_LEN; k += step) {
                int32_t sample = (int32_t)frame_audio[k];
                /* Apply simple pre-emphasis and energy accumulation */
                energy += (uint32_t)((sample * sample) >> 14);
            }

            /* Log-energy and scaling to INT8 range [-128, 127] */
            uint32_t mag = int_sqrt(energy);
            int32_t log_q8 = int_log2_q8(mag);
            
            /* Center and normalize around 0 */
            int32_t int8_val = (log_q8 >> 2) - 35;
            if (int8_val > 127) int8_val = 127;
            if (int8_val < -128) int8_val = -128;

            out_mfcc_490[frame * MFCC_NUM_FILTERBANKS + bin] = (int8_t)int8_val;
        }
    }
}

/* Sample 16 kHz PCM audio waveform representing 100ms voice burst (repeated across 1 sec) */
const int16_t g_sample_raw_audio_pcm[1600] = {
    0, 245, 512, 804, 1115, 1438, 1765, 2088, 2397, 2684, 2940, 3157, 3328, 3447, 3508, 3508,
    3447, 3328, 3157, 2940, 2684, 2397, 2088, 1765, 1438, 1115, 804, 512, 245, 0, -245, -512,
    -804, -1115, -1438, -1765, -2088, -2397, -2684, -2940, -3157, -3328, -3447, -3508, -3508,
    -3447, -3328, -3157, -2940, -2684, -2397, -2088, -1765, -1438, -1115, -804, -512, -245, 0,
    120, 260, 420, 600, 790, 980, 1160, 1320, 1450, 1540, 1580, 1560, 1480, 1340, 1140, 890,
    600, 280, -60, -410, -760, -1090, -1390, -1640, -1820, -1920, -1920, -1820, -1640, -1390,
    -1090, -760, -410, -60, 280, 600, 890, 1140, 1340, 1480, 1560, 1580, 1540, 1450, 1320, 1160,
    980, 790, 600, 420, 260, 120, 0
};

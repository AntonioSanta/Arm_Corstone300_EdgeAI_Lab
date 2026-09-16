#ifndef INFERENCE_ENGINE_H
#define INFERENCE_ENGINE_H

#include <stdint.h>
#include <stdbool.h>

#define TENSOR_ARENA_SIZE_BYTES  (64 * 1024) /* 64 KiB internal SRAM Arena */

typedef struct {
    uint32_t arena_used_bytes;
    uint32_t arena_limit_bytes;
    uint32_t total_cycles;
    uint32_t npu_cycles;
    uint32_t cpu_cycles;
    uint32_t predicted_class_idx;
    int8_t   predicted_class_confidence;
    bool     accuracy_verified;
    bool     sram_boundary_safe;
} inference_result_t;

bool inference_engine_init(void);
bool inference_engine_run(const int8_t *input_features, uint32_t feature_len, inference_result_t *out_result);
void inference_engine_print_profile(const inference_result_t *result);

#endif /* INFERENCE_ENGINE_H */

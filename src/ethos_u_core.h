#ifndef ETHOS_U_CORE_H
#define ETHOS_U_CORE_H

#include <stdint.h>
#include <stdbool.h>

/* Arm Corstone-300 Ethos-U55 NPU MMIO Base */
#define CORSTONE300_ETHOSU_BASE         0x48102000UL
#define CORSTONE300_ETHOSU_IRQN         56

/* Ethos-U55 NPU Capability Structure */
typedef struct {
    uint32_t arch_major;
    uint32_t arch_minor;
    uint32_t macs_per_cycle;     /* e.g., 128 or 256 */
    uint32_t driver_version;
    bool is_initialized;
} ethosu_capabilities_t;

/* Ethos-U Execution Metrics */
typedef struct {
    uint32_t npu_cycles;
    uint32_t qread_wait_cycles;
    uint32_t memory_access_cycles;
    uint32_t total_inferences;
} ethosu_metrics_t;

/* Public API */
bool ethosu_core_init(void);
const ethosu_capabilities_t *ethosu_get_capabilities(void);
bool ethosu_invoke_command_stream(const uint8_t *cmd_stream, uint32_t size_bytes, ethosu_metrics_t *metrics);
void ethosu_irq_handler(void);

#endif /* ETHOS_U_CORE_H */

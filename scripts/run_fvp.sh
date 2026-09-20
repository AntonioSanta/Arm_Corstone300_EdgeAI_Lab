#!/usr/bin/env bash
source /home/anton/.local/arm_fvp/installed/scripts/runtime.sh
exec /home/anton/.local/arm_fvp/installed/models/Linux64_GCC-9.3/FVP_Corstone_SSE-300_Ethos-U55 "$@"
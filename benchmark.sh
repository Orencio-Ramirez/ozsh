#!/usr/bin/env bash
###############################################################################
# benchmark.sh
#
# Benchmark del sistema ZSH modular.
#
# Mide:
# - tiempo de arranque
# - tiempo de render del prompt
# - consistencia entre ejecuciones
###############################################################################

set -e

ITERATIONS=50
ZSH_BINARY="$(which zsh)"

echo "🔬 ZSH Benchmark System"
echo "Iteraciones: $ITERATIONS"
echo ""

###############################################################################
# Benchmark de arranque
###############################################################################

benchmark_startup() {

    echo "🚀 Benchmark de startup..."

    local total=0
    local min=9999
    local max=0

    for i in $(seq 1 "$ITERATIONS"); do

        local start end duration

        start=$(python3 -c 'import time; print(time.time())')

        "$ZSH_BINARY" -i -c exit >/dev/null 2>&1

        end=$(python3 -c 'import time; print(time.time())')

        duration=$(python3 -c "print(($end - $start) * 1000)")

        total=$(python3 -c "print($total + $duration)")

        # min/max (bash arithmetic safe fallback)
        min=$(python3 -c "print(min($min, $duration))")
        max=$(python3 -c "print(max($max, $duration))")

    done

    local avg
    avg=$(python3 -c "print($total / $ITERATIONS)")

    echo ""
    echo "📊 Startup results:"
    echo "  Avg: ${avg} ms"
    echo "  Min: ${min} ms"
    echo "  Max: ${max} ms"
    echo ""
}

###############################################################################
# Benchmark del prompt
###############################################################################

benchmark_prompt() {

    echo "⚡ Benchmark de prompt render..."

    local total=0

    for i in $(seq 1 "$ITERATIONS"); do

        local start end duration

        start=$(python3 -c 'import time; print(time.time())')

        "$ZSH_BINARY" -i -c 'PROMPT=""' >/dev/null 2>&1

        end=$(python3 -c 'import time; print(time.time())')

        duration=$(python3 -c "print(($end - $start) * 1000)")

        total=$(python3 -c "print($total + $duration)")
    done

    local avg
    avg=$(python3 -c "print($total / $ITERATIONS)")

    echo ""
    echo "📊 Prompt results:"
    echo "  Avg render: ${avg} ms"
    echo ""
}

###############################################################################
# Ejecución
###############################################################################

benchmark_startup
benchmark_prompt

echo "✅ Benchmark completado"
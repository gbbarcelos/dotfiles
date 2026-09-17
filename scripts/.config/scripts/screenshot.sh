#!/usr/bin/env bash
SAVE_DIR="${SCREENSHOT_DIR:-$HOME/imagens/screenshots}"
SAVE_DIR_REC="${RECORDING_DIR:-$HOME/videos/capturas}"
DATE_FMT="%Y-%m-%d_%H-%M-%S"

mkdir -p "$SAVE_DIR" "$SAVE_DIR_REC"
notify() {
    local summary="$1" body="${2:-}" icon="${3:-camera}"
    notify-send -i "$icon" "$summary" "$body" 2>/dev/null || true
}

check_deps() {
    local missing=()
    for cmd in grim slurp wf-recorder wayfreeze; do
        command -v "$cmd" &>/dev/null || missing+=("$cmd")
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
        notify "❌ Dependências faltando" "Instale: ${missing[*]}" "dialog-error"
        echo "Erro: instale os pacotes: ${missing[*]}"
        exit 1
    fi
}
start_freeze() {
    wayfreeze &
    local pid=$!
    sleep 0.15
    echo "$pid"
}

stop_freeze() {
    local pid="${1:-}"
    [[ -n "$pid" ]] && kill "$pid" 2>/dev/null || true
}

screenshot_full() {
    local ts file_path

    ts=$(date +"$DATE_FMT")
    file_path="$SAVE_DIR/screenshot_$ts.png"

    grim "$file_path"

    wl-copy < "$file_path" 2>/dev/null || true
    notify "Screenshot salvo" "$file_path" "camera"
    echo "Salvo em: $file_path"
}

screenshot_region() {
    local ts file_path region freeze_pid

    ts=$(date +"$DATE_FMT")
    file_path="$SAVE_DIR/screenshot_$ts.png"

    freeze_pid=$(start_freeze)

    region=$(slurp 2>/dev/null) || {
        stop_freeze "$freeze_pid"
        notify "❌ Seleção cancelada" "" "dialog-information"
        exit 0
    }

    grim -g "$region" "$file_path"
    stop_freeze "$freeze_pid"

    wl-copy < "$file_path" 2>/dev/null || true
    notify "󰑊 Screenshot salvo" "$file_path" "camera"
    echo "Salvo em: $file_path"
}

record_full() {
    local ts out_file pid_file="/tmp/wf-recorder.pid"

    if [[ -f "$pid_file" ]]; then
        notify "⚠️ Gravação já em andamento" "Use o atalho de parar gravação" "dialog-warning"
        exit 1
    fi

    ts=$(date +"$DATE_FMT")
    out_file="$SAVE_DIR_REC/recording_$ts.mp4"

    wf-recorder -f "$out_file" &
    echo $! > "$pid_file"

    notify "󰑊 Gravação iniciada" "$out_file" "media-record"
    echo "Gravando em: $out_file (PID: $(cat $pid_file))"
}

record_region() {
    local ts out_file region freeze_pid pid_file="/tmp/wf-recorder.pid"

    if [[ -f "$pid_file" ]]; then
        notify "⚠️ Gravação já em andamento" "Use o atalho de parar gravação" "dialog-warning"
        exit 1
    fi

    freeze_pid=$(start_freeze)

    region=$(slurp 2>/dev/null) || {
        stop_freeze "$freeze_pid"
        notify "❌ Seleção cancelada" "" "dialog-information"
        exit 0
    }

    stop_freeze "$freeze_pid"

    ts=$(date +"$DATE_FMT")
    out_file="$SAVE_DIR_REC/recording_$ts.mp4"

    wf-recorder -g "$region" -f "$out_file" &
    echo $! > "$pid_file"

    notify "󰑊 Gravação da região iniciada" "$out_file" "media-record"
    echo "Gravando em: $out_file (PID: $(cat $pid_file))"
}

stop_recording() {
    local pid_file="/tmp/wf-recorder.pid"

    if [[ ! -f "$pid_file" ]]; then
        notify "ℹ️ Nenhuma gravação ativa" "" "dialog-information"
        exit 0
    fi

    local pid
    pid=$(cat "$pid_file")
    kill -SIGINT "$pid" 2>/dev/null
    rm -f "$pid_file"

    for _ in $(seq 1 20); do
        kill -0 "$pid" 2>/dev/null || break
        sleep 0.2
    done

    notify "⏹ Gravação finalizada" "Arquivo salvo em $SAVE_DIR_REC" "media-playback-stop"
    echo "Gravação parada (PID $pid)"
}

main() {
    check_deps

    case "${1:-}" in
        full)       screenshot_full ;;
        region)     screenshot_region ;;
        rec-full)   record_full ;;
        rec-region) record_region ;;
        stop-rec)   stop_recording ;;
        *)
            echo "Uso: $0 [full|region|rec-full|rec-region|stop-rec]"
            exit 1
            ;;
    esac
}

main "$@"

#!/bin/zsh
# NEOM Transcriber v1.0.0 - Barebones
# Simple recording + Whisper transcription
VERSION="1.0.0"

# Config
RECORDING_DIR="$HOME/Documents/NEOM_OS/recordings"
TIMESTAMP=$(date +"%Y-%m-%d_%H.%M.%S")
OUTPUT_FILE="$RECORDING_DIR/recording-$TIMESTAMP.wav"
mkdir -p "$RECORDING_DIR"

# Record
echo "Recording... Press any key to stop"
sox -d -b 16 "$OUTPUT_FILE" trim 0 600 &
REC_PID=$!
read -s -k 1
kill -INT "$REC_PID" 2>/dev/null
wait "$REC_PID" 2>/dev/null

# Validate
if [ ! -f "$OUTPUT_FILE" ] || [ ! -s "$OUTPUT_FILE" ]; then
    echo "Error: Recording failed"
    exit 1
fi

# Transcribe
if [ -z "$OPENAI_API_KEY" ]; then
    echo "Error: OPENAI_API_KEY not set"
    exit 1
fi

echo "Transcribing..."
apiResponse=$(curl -sS https://api.openai.com/v1/audio/transcriptions \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -F file="@$OUTPUT_FILE" \
    -F model="whisper-1")

if echo "$apiResponse" | jq -e 'has("error")' >/dev/null; then
    echo "Error: $(echo "$apiResponse" | jq -r .error.message)"
    exit 1
fi

# Copy result
transcriptionText=$(echo "$apiResponse" | jq -r '.text')
echo "$transcriptionText" | pbcopy
echo "Done! Copied to clipboard"

# Cleanup and return
rm -f "$OUTPUT_FILE"
~/Documents/NEOM_OS/neom-home
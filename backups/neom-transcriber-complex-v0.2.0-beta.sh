#!/bin/zsh

# NEOM OS - Transcriber v0.2.0-beta (Complex Features)
VERSION="0.2.0-beta"
# Records, transcribes, and offers two copy formats:
# Plain text (minimal) or Notion AI-ready format with instructions.
# Uses local file paths instead of audio uploads for faster processing.

# Source the emoticon library
source ~/Documents/NEOM_OS/neom-emoticons

# --- Configuration ---
RECORDING_DIR="$HOME/Documents/NEOM_OS/recordings"
TIMESTAMP=$(date +"%Y-%m-%d_%H.%M.%S")
OUTPUT_FILE="$RECORDING_DIR/recording-$TIMESTAMP.wav"
MAX_DURATION=600 # 10 minutes

# Sound process tracking
SOUND_PIDS=()
THINKING_PID=""

# Audio cues - Custom sounds from /sounds/ directory
START_SOUND="$HOME/Documents/NEOM_OS/sounds/start-recording.wav"
STOP_SOUND="$HOME/Documents/NEOM_OS/sounds/stop-recording.wav"
THINKING_SOUND="$HOME/Documents/NEOM_OS/sounds/thinking.wav"
COMPLETE_SOUND="$HOME/Documents/NEOM_OS/sounds/complete.wav"
# Fallback system sounds
FINAL_WARN_SOUND="/System/Library/Sounds/Submarine.aiff"
SUCCESS_SOUND="/System/Library/Sounds/Glass.aiff"

# NEOM OS Branding Colors
NEOM_PURPLE='\033[38;2;135;91;225m'  # #875BE1 - artsea purple
NEOM_GREEN='\033[38;2;0;255;65m'     # Matrix green
RESET='\033[0m'

# --- Neomoticons System ---
# Now handled by the centralized neom-emoticons library

# Show error screen with troubleshooting
show_error() {
    local error_type=$1
    local error_message=$2
    local troubleshooting=$3
    
    clear
    echo -e "${NEOM_PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${NEOM_PURPLE}❌ NEOM Transcriber Error${RESET}"
    echo -e "${NEOM_PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
    echo -e "${NEOM_GREEN}Error Type:${RESET} $error_type"
    echo -e "${NEOM_GREEN}Message:${RESET} $error_message"
    echo ""
    if [ ! -z "$troubleshooting" ]; then
        echo -e "${NEOM_PURPLE}🔧 Troubleshooting:${RESET}"
        echo "$troubleshooting"
        echo ""
    fi
    echo -e "${NEOM_PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
    echo -e "${NEOM_GREEN}Press any key to return to neom-home...${RESET}"
    read -s -k 1
    ~/Documents/NEOM_OS/neom-home
    exit 1
}

# Show loading state with animation
show_loading() {
    local message=$1
    local duration=${2:-3}
    
    echo -e "${NEOM_PURPLE}${message}${RESET}"
    for i in $(seq 1 $duration); do
        printf "."
        sleep 1
    done
    echo ""
}

# --- Functions ---

cleanup_sounds() {
    # Kill thinking sound loop
    if [ ! -z "$THINKING_PID" ]; then
        echo "Stopping thinking sound PID: $THINKING_PID"
        kill -TERM "$THINKING_PID" 2>/dev/null
        sleep 0.2
        kill -KILL "$THINKING_PID" 2>/dev/null
        wait "$THINKING_PID" 2>/dev/null
        THINKING_PID=""
    fi
    
    # Kill all tracked sound PIDs
    for pid in "${SOUND_PIDS[@]}"; do
        if [ ! -z "$pid" ] && kill -0 "$pid" 2>/dev/null; then
            echo "Stopping sound PID: $pid"
            kill -TERM "$pid" 2>/dev/null
            sleep 0.1
            kill -KILL "$pid" 2>/dev/null
            wait "$pid" 2>/dev/null
        fi
    done
    SOUND_PIDS=()
    
    # Safety net: kill any remaining afplay processes from NEOM_OS
    pkill -f "afplay.*NEOM_OS/sounds" 2>/dev/null
    
    # Clean up emoticon animations using the library function
    neom_emoticon_cleanup
}

show_session_summary() {
    local format=$1
    local words=$2
    local file=$3
    local duration=$4
    local file_size_kb=$5
    local preview=$6
    
    clear
    echo -e "${NEOM_PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${NEOM_PURPLE}✅ NEOM Transcriber Session Complete${RESET}"
    echo -e "${NEOM_PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
    echo -e "${NEOM_GREEN}┌─ Session Summary ──────────────────────────────────────────────────────┐${RESET}"
    echo -e "${NEOM_GREEN}│${RESET} ${NEOM_PURPLE}Format:${RESET} $format"
    echo -e "${NEOM_GREEN}│${RESET} ${NEOM_PURPLE}Words:${RESET} $words"
    echo -e "${NEOM_GREEN}│${RESET} ${NEOM_PURPLE}Duration:${RESET} ${duration}s"
    echo -e "${NEOM_GREEN}│${RESET} ${NEOM_PURPLE}File Size:${RESET} ${file_size_kb}KB"
    echo -e "${NEOM_GREEN}│${RESET} ${NEOM_PURPLE}Recording:${RESET} $file"
    echo -e "${NEOM_GREEN}└────────────────────────────────────────────────────────────────────────────┘${RESET}"
    echo ""
    echo -e "${NEOM_PURPLE}📝 Content Preview:${RESET}"
    echo -e "${NEOM_GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo "$preview"
    echo -e "${NEOM_GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
    echo -e "${NEOM_PURPLE}📋 Content copied to clipboard and ready to paste!${RESET}"
    echo -e "${NEOM_GREEN}✨ ${NEOM_PURPLE}Press any key to return to neom-home...${RESET}"
    echo ""
    echo -e "${NEOM_PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    read -s -k 1
}

show_processing_screen() {
    local tool_name=$1
    local tool_color=$2
    clear
    echo -e "${NEOM_GREEN}"
    cat << "EOF"
███╗   ██╗███████╗ ██████╗ ███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝
EOF
    echo -e "${RESET}"
    echo ""
    echo -e "${tool_color}"
    case "$tool_name" in
        "Transcription")
            cat << "EOF"
   ▄▀█ █▀█ ▀█▀ █▀ █▀▀ ▄▀█
   █▀█ █▀▄ ░█░ ▄█ ██▄ █▀█
EOF
            ;;
        *)
            echo "Processing: $tool_name"
            ;;
    esac
    echo -e "${RESET}"
    echo ""
    echo -e "${NEOM_PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
    # Display initial processing emoticon
    neom_emoticon_show "thinking" "Initializing..."
}



format_plain_text() {
    local audio_file=$1
    local transcript=$2
    
    cat <<EOF
$(date +"%Y-%m-%d Transcription")

Audio Recording:
$audio_file

Full Transcript:
$transcript
EOF
}

format_notion_paste() {
    local audio_file=$1
    local transcript=$2
    
    cat <<EOF
Please create a comprehensive, structured Notion page from the following transcription. Organize it with clear sections and detailed analysis:

# 🧠 $(date +"%Y-%m-%d Transcription")

## 📋 TL;DR
Provide a concise 2-3 sentence summary of the main content.

## 🎯 Key Points
Create a bulleted list of the 3-5 most important points or action items.

## 📝 Detailed Outline
Provide a structured outline breaking down the main topics and subtopics discussed.

## ❓ The 5 W's
| Question | Answer |
|----------|--------|
| **Who** | Who is involved or mentioned? |
| **What** | What is the main topic or subject? |
| **When** | When does this take place or when is it relevant? |
| **Where** | Where does this occur or apply? |
| **Why** | Why is this important or what's the purpose? |

## 💡 Insights
Highlight key insights, patterns, or important observations from the content.

## ✅ Actionables
List specific action items, next steps, or tasks that should be taken based on this content.

## 🎧 Audio Recording
$audio_file

## 📜 Full Transcript
\`\`\`
$transcript
\`\`\`
EOF
}

# --- 1. SETUP & RECORDING ---
mkdir -p "$RECORDING_DIR"

# Set up comprehensive cleanup trap
trap cleanup_sounds EXIT INT TERM

# Play start recording sound (non-blocking)
if [ -f "$START_SOUND" ]; then
    afplay "$START_SOUND" &
    SOUND_PIDS+=($!)
fi

# Start SoX recording with waveform display
sox -d -b 16 "$OUTPUT_FILE" --show-progress &
REC_PID=$!; clear

# Custom NEOM recording interface with waveform
echo -e "${NEOM_PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${NEOM_PURPLE}NEOM Transcriber - Recording${RESET}"
echo -e "${NEOM_PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""

# Start animated recording display with SoX waveform
RECORDING_START=$(date +%s)
while kill -0 "$REC_PID" 2>/dev/null; do
    # Check for key press to stop
    read -s -k 1 -t 0.5
    if [ $? -eq 0 ]; then 
        echo ""
        echo -e "${NEOM_GREEN}Stopping recording...${RESET}"
        break
    fi
    
    # Calculate elapsed time
    ELAPSED=$(($(date +%s) - RECORDING_START))
    MINUTES=$((ELAPSED / 60))
    SECONDS=$((ELAPSED % 60))
    
    # Display animated recording interface using new emoticon system
    local recording_message="Recording... $(printf "%02d:%02d" $MINUTES $SECONDS) │ Press any key to stop"
    neom_emoticon_show "singing" "$recording_message"
done

# Calculate final elapsed time
ELAPSED=$(($(date +%s) - RECORDING_START))
echo ""
echo ""

# Stop recording
kill -INT "$REC_PID" 2>/dev/null
wait "$REC_PID" 2>/dev/null
sleep 0.5; clear

# Check if recording file was created successfully
if [ ! -f "$OUTPUT_FILE" ] || [ ! -s "$OUTPUT_FILE" ]; then
    show_error "Recording Failed" "No audio file was created" \
"• Check microphone permissions in System Preferences > Security & Privacy > Microphone
• Ensure your microphone is not muted
• Try speaking closer to the microphone
• Restart the application and try again"
fi

# Check file size (minimum 1KB for valid audio)
FILE_SIZE=$(stat -f%z "$OUTPUT_FILE" 2>/dev/null || echo "0")
if [ "$FILE_SIZE" -lt 1024 ]; then
    show_error "Invalid Recording" "Audio file is too small ($FILE_SIZE bytes)" \
"• The recording may be too short or silent
• Check microphone input levels
• Try speaking louder or closer to the microphone
• Ensure no other applications are using the microphone"
fi

# Play stop recording sound (non-blocking)
if [ -f "$STOP_SOUND" ]; then
    afplay "$STOP_SOUND" &
    SOUND_PIDS+=($!)
else
    afplay "$FINAL_WARN_SOUND" &
    SOUND_PIDS+=($!)
fi
echo "Recording finished: $OUTPUT_FILE"

# --- 2. TRANSCRIBE & SUMMARIZE ---
show_processing_screen "Transcription" "$NEOM_PURPLE"
if [ -z "$OPENAI_API_KEY" ]; then echo "Error: OPENAI_API_KEY not set." >&2; exit 1; fi

# Start thinking sound loop during transcription with proper process group
if [ -f "$THINKING_SOUND" ]; then
    (
        while true; do 
            afplay "$THINKING_SOUND" 2>/dev/null || break
            sleep 0.5  # Add delay to prevent overwhelming
        done
    ) &
    THINKING_PID=$!
    echo "Started thinking sound PID: $THINKING_PID"
fi

# Start neomoticon animation during API call
echo ""
echo -e "${NEOM_PURPLE}Processing with AI...${RESET}"
NEOMOTICON_PID=$(neom_emoticon_start "thinking" "Processing with AI...")

# Make API call
apiResponse=$(curl -sS https://api.openai.com/v1/audio/transcriptions -H "Authorization: Bearer $OPENAI_API_KEY" -F file="@$OUTPUT_FILE" -F model="whisper-1")

# Stop both thinking sound and neomoticon animation
cleanup_sounds
neom_emoticon_stop "success" "Transcription complete!"

# Enhanced API error handling
if echo "$apiResponse"|jq -e 'has("error")'>/dev/null; then
    ERROR_MESSAGE=$(echo "$apiResponse"|jq -r .error.message)
    ERROR_TYPE=$(echo "$apiResponse"|jq -r .error.type)
    
    case "$ERROR_TYPE" in
        "invalid_request_error")
            show_error "API Request Error" "$ERROR_MESSAGE" \
"• Check your OpenAI API key is valid and active
• Ensure you have sufficient API credits
• Verify the audio file format is supported"
            ;;
        "rate_limit_exceeded")
            show_error "Rate Limit Exceeded" "$ERROR_MESSAGE" \
"• You've exceeded the API rate limit
• Wait a few minutes before trying again
• Consider upgrading your OpenAI plan"
            ;;
        "insufficient_quota")
            show_error "Insufficient Quota" "$ERROR_MESSAGE" \
"• Your OpenAI account has insufficient credits
• Add credits to your OpenAI account
• Check your usage limits in the OpenAI dashboard"
            ;;
        *)
            show_error "API Error" "$ERROR_MESSAGE" \
"• Check your internet connection
• Verify your OpenAI API key is correct
• Try again in a few moments
• Contact support if the issue persists"
            ;;
    esac
fi
transcriptionText=$(echo "$apiResponse" | jq -r '.text')


# --- 3. ASSEMBLE & COPY ---
show_loading "Preparing content" 2
# Sanitize the full transcript to be safe for the code block
transcriptionTextSanitized=$(echo "$transcriptionText" | sed 's/[^[:print:]\n]//g')

# Calculate metrics for enhanced results screen
WORD_COUNT=$(echo "$transcriptionText" | wc -w | xargs)
RECORDING_DURATION=$((ELAPSED))
FILE_SIZE_KB=$((FILE_SIZE / 1024))
PREVIEW_TEXT=$(echo "$transcriptionText" | cut -c1-200)
if [ ${#transcriptionText} -gt 200 ]; then
    PREVIEW_TEXT="${PREVIEW_TEXT}..."
fi

# Enhanced results screen with preview and metrics
clear
echo -e "${NEOM_PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${NEOM_PURPLE}✨ Transcription Complete${RESET}"
echo -e "${NEOM_PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "${NEOM_GREEN}📊 Session Metrics:${RESET}"
echo -e "  ${NEOM_GREEN}Words:${RESET} $WORD_COUNT"
echo -e "  ${NEOM_GREEN}Duration:${RESET} ${RECORDING_DURATION}s"
echo -e "  ${NEOM_GREEN}File Size:${RESET} ${FILE_SIZE_KB}KB"
echo ""
echo -e "${NEOM_PURPLE}📝 Content Preview:${RESET}"
echo -e "${NEOM_GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo "$PREVIEW_TEXT"
echo -e "${NEOM_GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "${NEOM_PURPLE}🎨 Choose Output Format:${RESET}"
echo ""
echo -e "${NEOM_GREEN}┌─ Format Options ─────────────────────────────────────────────────────────┐${RESET}"
echo -e "${NEOM_GREEN}│${RESET} ${NEOM_PURPLE}0)${RESET} 🔙 ${NEOM_GREEN}Go Back to neom-home${RESET}                                    ${NEOM_GREEN}│${RESET}"
echo -e "${NEOM_GREEN}│${RESET} ${NEOM_PURPLE}1)${RESET} 📄 ${NEOM_GREEN}Plain Text${RESET} ${NEOM_PURPLE}(minimal formatting)${RESET}                    ${NEOM_GREEN}│${RESET}"
echo -e "${NEOM_GREEN}│${RESET} ${NEOM_PURPLE}2)${RESET} 🎨 ${NEOM_GREEN}Notion AI Paste${RESET} ${NEOM_PURPLE}(with formatting instructions)${RESET}  ${NEOM_GREEN}│${RESET}"
echo -e "${NEOM_GREEN}└────────────────────────────────────────────────────────────────────────────┘${RESET}"
echo ""

# Get user choice with validation
while true; do
    echo -n "Enter your choice (0, 1, or 2): "
    read choice
    case $choice in
        0)
            echo ""
            echo -e "${NEOM_PURPLE}Returning to neom-home...${RESET}"
            sleep 1
            ~/Documents/NEOM_OS/neom-home
            exit 0
            ;;
        1)
            # Format as plain text
            show_loading "Formatting as Plain Text" 1
            formattedContent=$(format_plain_text "$OUTPUT_FILE" "$transcriptionTextSanitized")
            echo "$formattedContent" | pbcopy
            formatChosen="Plain Text"
            break
            ;;
        2)
            # Format for Notion AI paste
            show_loading "Formatting for Notion AI" 1
            formattedContent=$(format_notion_paste "$OUTPUT_FILE" "$transcriptionTextSanitized")
            echo "$formattedContent" | pbcopy
            formatChosen="Notion AI Paste"
            break
            ;;
        *)
            echo "Invalid choice. Please enter 0, 1, or 2."
            ;;
    esac
done

# Calculate word count
wordCount=$(echo "$transcriptionText" | wc -w | xargs)

# Play complete sound (non-blocking)
if [ -f "$COMPLETE_SOUND" ]; then
    afplay "$COMPLETE_SOUND" &
    SOUND_PIDS+=($!)
else
    afplay "$SUCCESS_SOUND" &
    SOUND_PIDS+=($!)
fi

# Show session summary
show_session_summary "$formatChosen" "$wordCount" "$OUTPUT_FILE" "$RECORDING_DURATION" "$FILE_SIZE_KB" "$PREVIEW_TEXT"

# Clean up the audio file
rm -f "$OUTPUT_FILE"
echo "neom-transcriber finished."
#!/usr/bin/env zsh

# Finds the active sink for PipeWire and increments the volume.
# Useful when you have multiple audio outputs and have a key bound to vol-up and down.

osd='no'
inc='2'
capvol='no'
maxvol='200'
autosync='yes'

# Muted status
# yes: muted
# no : not muted
curStatus="no"
active_sink=""
limit=$((100 - inc))
maxlimit=$((maxvol - inc))

reloadSink() {
    active_sink=$(pw-cli list-objects | grep -B 1 'node.name = "alsa_output' | grep 'id' | awk '{print $NF}')
}

function volUp {
    getCurVol

    if [ "$capvol" = 'yes' ]; then
        if [ "$curVol" -le 100 ] && [ "$curVol" -ge "$limit" ]; then
            wpctl set-volume "$active_sink" 100%
        elif [ "$curVol" -lt "$limit" ]; then
            wpctl set-volume "$active_sink" "$inc"%
        fi
    elif [ "$curVol" -le "$maxvol" ] && [ "$curVol" -ge "$maxlimit" ]; then
        wpctl set-volume "$active_sink" "$maxvol%"
    elif [ "$curVol" -lt "$maxlimit" ]; then
        wpctl set-volume "$active_sink" "$inc"%
    fi

    getCurVol

    if [ ${osd} = 'yes' ]; then
        qdbus org.kde.kded /modules/kosd showVolume "$curVol" 0
    fi

    if [ ${autosync} = 'yes' ]; then
        volSync
    fi
}

function volDown {
    wpctl set-volume "$active_sink" "-$inc%"
    getCurVol

    if [ ${osd} = 'yes' ]; then
        qdbus org.kde.kded /modules/kosd showVolume "$curVol" 0
    fi

    if [ ${autosync} = 'yes' ]; then
        volSync
    fi
}

function getSinkInputs {
    input_array=$(pw-cli list-objects | grep -B 1 'media.class = "Audio/Sink"' | grep 'id' | awk '{print $NF}')
}

function volSync {
    getSinkInputs "$active_sink"
    getCurVol

    for each in $input_array; do
        wpctl set-volume "$each" "$curVol%"
    done
}

function getCurVol {
    curVol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100}' | cut -d '.' -f 1)
}

function volMute {
    case "$1" in
        mute)
            wpctl set-mute "$active_sink" 1
            curVol=0
            status=1
            ;;
        unmute)
            wpctl set-mute "$active_sink" 0
            getCurVol
            status=0
            ;;
    esac

    if [ ${osd} = 'yes' ]; then
        qdbus org.kde.kded /modules/kosd showVolume ${curVol} ${status}
    fi
}

function volMuteStatus {
    curStatus=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -oE 'MUTED')
    if [ "$curStatus" = "MUTED" ]; then
        curStatus="yes"
    else
        curStatus="no"
    fi
}

# Prints output for bar
# Listens for events for fast update speed
function listen {
    firstrun=0

    pw-mon | {
        while true; do
            {
                # If this is the first time just continue
                # and print the current state
                # Otherwise wait for events
                # This is to prevent the module being empty until
                # an event occurs
                if [ $firstrun -eq 0 ]; then
                    firstrun=1
                else
                    read -r event || break
                    if ! echo "$event" | grep -e "node" -e "device"; then
                        # Avoid double events
                        continue
                    fi
                fi
            } &>/dev/null
            output
        done
    }
}

function output {
    reloadSink
    getCurVol
    volMuteStatus
    if [ "${curStatus}" = 'yes' ]; then
        echo " $curVol%"
    else
        echo " $curVol%"
    fi
}

reloadSink
case "$1" in
    --up)
        volUp
        ;;
    --down)
        volDown
        ;;
    --togmute)
        volMuteStatus
        if [ "$curStatus" = 'yes' ]; then
            volMute unmute
        else
            volMute mute
        fi
        ;;
    --mute)
        volMute mute
        ;;
    --unmute)
        volMute unmute
        ;;
    --sync)
        volSync
        ;;
    --listen)
        # Listen for changes and immediately create new output for the bar
        # This is faster than having the script on an interval
        listen
        ;;
    *)
        # By default print output for bar
        output
        ;;
esac


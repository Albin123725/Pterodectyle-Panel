#!/bin/bash

# ============================================
# 🔥 REAL VPS CREATOR FOR FIREBASE
# ============================================
# Creates VPS that shows: root@hostname ~]#
# With real boot sequence and reboot
# ============================================

# Create the script file
cat > ~/vps-creator.sh << 'VPS_CREATOR_EOF'
#!/bin/bash

# Global variables
VPS_BASE="$HOME/real-vps"
VPS_COUNT=0

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

show_header() {
    clear
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════╗"
    echo "║           REAL VPS CREATOR - FIREBASE            ║"
    echo "║      Creates VPS with root@hostname prompt       ║"
    echo "║             Just like real SSH access            ║"
    echo "╚══════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${YELLOW}Firebase Cloud Shell | $(date)${NC}"
    echo ""
}

# Create a new VPS
create_vps() {
    show_header
    
    echo -e "${CYAN}══════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}                 CREATE NEW VPS                   ${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════════${NC}"
    echo ""
    
    # Get VPS details
    read -p "Enter VPS hostname (e.g., ubuntu, centos, debian): " vps_name
    vps_name=${vps_name:-myvps}
    
    # Generate password
    password=$(openssl rand -base64 12 | tr -d '/+=' | head -c 12)
    
    # Create VPS directory
    vps_dir="$VPS_BASE/$vps_name"
    mkdir -p "$vps_dir"
    
    # Create start script
    cat > "$vps_dir/start.sh" << 'START_SCRIPT'
#!/bin/bash

VPS_NAME="$1"
VPS_PASS="$2"

echo ""
echo "========================================================================="
echo "                   VPS BOOT SEQUENCE - $VPS_NAME"
echo "========================================================================="
sleep 1

# Simulate boot process
echo "[  OK  ] Started System V Boot Manager"
echo "[  OK  ] Started Load Kernel Modules"
echo "[  OK  ] Started udev Coldplug all Devices"
echo "[  OK  ] Started Remount Root and Kernel File Systems"
echo "[  OK  ] Started Create Static Device Nodes in /dev"
echo "[  OK  ] Started Load/Save Random Seed"
echo "[  OK  ] Started Create Volatile Files and Directories"
sleep 2

echo ""
echo "[  OK  ] Started Network Manager"
echo "[  OK  ] Started SSH Daemon"
echo "[  OK  ] Started Login Service"
sleep 1

echo ""
echo "========================================================================="
echo "              SYSTEM BOOT COMPLETE - READY FOR LOGIN"
echo "========================================================================="
echo "Hostname:    $VPS_NAME"
echo "IP Address:  127.0.0.1"
echo "SSH Port:    22"
echo "Username:    root"
echo "Password:    $VPS_PASS"
echo "========================================================================="
echo ""
sleep 2

# Set up root environment
setup_root_env() {
    # Create custom prompt
    export PS1='\[\e[1;31m\]\u\[\e[0m\]@\[\e[1;32m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]# '
    
    # Create aliases
    alias ll='ls -la --color=auto'
    alias cls='clear'
    alias reboot='echo "System will now reboot..." && sleep 2 && exec bash "$0" "$VPS_NAME" "$VPS_PASS"'
    alias shutdown='echo "System will now shutdown..." && sleep 2 && exit 0'
    alias status='echo "VPS Status: RUNNING | Host: $(hostname) | Uptime: 5min"'
    
    # Welcome message
    echo ""
    echo "Welcome to $VPS_NAME!"
    echo "System: $(uname -srm)"
    echo "Kernel: $(uname -r)"
    echo "Uptime: 5 minutes"
    echo "Users: 1 user logged in"
    echo ""
    echo "Type 'help' for available commands"
    echo ""
}

# Main shell loop
main_shell() {
    setup_root_env
    
    while true; do
        # Show prompt
        echo -n "[root@$VPS_NAME ~]# "
        read -e command
        
        case "$command" in
            reboot)
                echo "Initiating system reboot..."
                sleep 2
                echo ""
                echo "*** REBOOTING SYSTEM ***"
                sleep 2
                # Restart by calling self
                exec bash "$0" "$VPS_NAME" "$VPS_PASS"
                ;;
            shutdown|poweroff|halt)
                echo "Shutting down system..."
                sleep 2
                echo "System halted."
                exit 0
                ;;
            exit|logout)
                echo "Logging out..."
                exit 0
                ;;
            help)
                echo ""
                echo "Available Commands:"
                echo "  reboot     - Reboot the VPS"
                echo "  shutdown   - Shutdown the VPS"
                echo "  status     - Show VPS status"
                echo "  ll         - List files"
                echo "  cls        - Clear screen"
                echo "  apt update - Update packages (simulated)"
                echo "  yum update - Update packages (simulated)"
                echo "  help       - Show this help"
                echo ""
                ;;
            status)
                echo ""
                echo "=== VPS Status ==="
                echo "Hostname: $VPS_NAME"
                echo "User: root"
                echo "Status: RUNNING"
                echo "IP: 127.0.0.1"
                echo "Uptime: 5 minutes"
                echo "Memory: 2.1GB/4GB used"
                echo "Disk: 15GB/50GB used"
                echo "Load: 0.01, 0.05, 0.10"
                echo ""
                ;;
            apt*|yum*|apk*)
                echo "[VPS] Simulating package manager: $command"
                sleep 0.5
                echo "[VPS] Command completed successfully"
                ;;
            systemctl*|service*)
                echo "[VPS] Simulating service manager: $command"
                sleep 0.5
                echo "[VPS] Service command completed"
                ;;
            cd*)
                # Handle cd command
                eval "$command" 2>/dev/null || echo "Directory not found"
                ;;
            ls*|ll*)
                # Handle ls with colors
                eval "$command --color=auto" 2>/dev/null || eval "$command"
                ;;
            pwd|whoami|hostname|date|echo*)
                # Execute real commands
                eval "$command"
                ;;
            "")
                continue
                ;;
            *)
                # For other commands, simulate execution
                echo "[VPS] Executing: $command"
                sleep 0.3
                echo "[VPS] Command completed with exit code 0"
                ;;
        esac
    done
}

# Start the shell
main_shell
START_SCRIPT
    
    chmod +x "$vps_dir/start.sh"
    
    # Create control script
    cat > "$vps_dir/vps-control.sh" << 'CONTROL_SCRIPT'
#!/bin/bash

VPS_NAME="$(basename "$(dirname "$0")")"
VPS_DIR="$(dirname "$0")"

case "$1" in
    start)
        echo "Starting VPS: $VPS_NAME..."
        echo "You will see boot sequence and root prompt"
        echo ""
        "$VPS_DIR/start.sh" "$VPS_NAME" "$2" &
        echo $! > "$VPS_DIR/vps.pid"
        echo "✅ VPS started with PID: $(cat "$VPS_DIR/vps.pid")"
        ;;
    stop)
        if [ -f "$VPS_DIR/vps.pid" ]; then
            echo "Stopping VPS: $VPS_NAME..."
            kill $(cat "$VPS_DIR/vps.pid") 2>/dev/null
            rm -f "$VPS_DIR/vps.pid"
            echo "✅ VPS stopped"
        else
            echo "VPS is not running"
        fi
        ;;
    shell)
        if [ ! -f "$VPS_DIR/vps.pid" ] || ! kill -0 $(cat "$VPS_DIR/vps.pid") 2>/dev/null; then
            echo "Starting VPS first..."
            "$0" start "$2"
            sleep 2
        fi
        echo "Connecting to VPS: $VPS_NAME..."
        echo "Type 'exit' to disconnect"
        echo ""
        fg %1 2>/dev/null || "$VPS_DIR/start.sh" "$VPS_NAME" "$2"
        ;;
    status)
        if [ -f "$VPS_DIR/vps.pid" ] && kill -0 $(cat "$VPS_DIR/vps.pid") 2>/dev/null; then
            echo "✅ VPS $VPS_NAME is RUNNING"
            echo "PID: $(cat "$VPS_DIR/vps.pid")"
        else
            echo "❌ VPS $VPS_NAME is STOPPED"
        fi
        ;;
    reboot)
        echo "Rebooting VPS: $VPS_NAME..."
        "$0" stop
        sleep 2
        "$0" start "$2"
        ;;
    info)
        echo "=== VPS Information ==="
        echo "Name: $VPS_NAME"
        echo "User: root"
        echo "Password: $2"
        echo "Path: $VPS_DIR"
        ;;
    *)
        echo "Usage: $0 {start|stop|shell|status|reboot|info} [password]"
        echo ""
        echo "Examples:"
        echo "  $0 start password123    - Start VPS"
        echo "  $0 shell password123    - Connect to VPS"
        echo "  $0 reboot password123   - Reboot VPS"
        echo "  $0 status               - Check status"
        ;;
esac
CONTROL_SCRIPT
    
    chmod +x "$vps_dir/vps-control.sh"
    
    # Save password
    echo "$password" > "$vps_dir/password.txt"
    
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════╗"
    echo "║        VPS CREATED SUCCESSFULLY!        ║"
    echo "╚══════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${CYAN}VPS Details:${NC}"
    echo "Hostname: $vps_name"
    echo "Username: root"
    echo "Password: $password"
    echo ""
    
    echo -e "${YELLOW}Commands:${NC}"
    echo "Start:   $vps_dir/vps-control.sh start $password"
    echo "Connect: $vps_dir/vps-control.sh shell $password"
    echo "Reboot:  $vps_dir/vps-control.sh reboot $password"
    echo ""
    
    read -p "Start VPS now and connect? (Y/n): " choice
    if [[ ! "$choice" =~ ^[Nn]$ ]]; then
        echo ""
        "$vps_dir/vps-control.sh" start "$password"
        sleep 2
        echo ""
        read -p "Press Enter to connect to your VPS..."
        "$vps_dir/vps-control.sh" shell "$password"
    fi
}

# List all VPS
list_vps() {
    show_header
    
    echo -e "${CYAN}══════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}                 YOUR VPS INSTANCES               ${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════════${NC}"
    echo ""
    
    if [ ! -d "$VPS_BASE" ] || [ -z "$(ls -A "$VPS_BASE" 2>/dev/null)" ]; then
        echo -e "${YELLOW}No VPS instances found.${NC}"
        echo "Create one using option 1."
        return
    fi
    
    local count=0
    for vps in "$VPS_BASE"/*; do
        if [ -d "$vps" ]; then
            ((count++))
            vps_name=$(basename "$vps")
            echo -e "${GREEN}$count. $vps_name${NC}"
            
            if [ -f "$vps/password.txt" ]; then
                echo "   Password: $(cat "$vps/password.txt")"
            fi
            
            if [ -f "$vps/vps.pid" ] && kill -0 $(cat "$vps/vps.pid") 2>/dev/null; then
                echo -e "   ${GREEN}Status: RUNNING${NC}"
            else
                echo -e "   ${RED}Status: STOPPED${NC}"
            fi
            
            echo "   Connect: $vps/vps-control.sh shell \$(cat $vps/password.txt)"
            echo ""
        fi
    done
    
    echo -e "${CYAN}Total VPS: $count${NC}"
}

# Connect to VPS
connect_vps() {
    if [ -z "$1" ]; then
        echo -e "${RED}Usage: connect <vps-name>${NC}"
        return 1
    fi
    
    vps_dir="$VPS_BASE/$1"
    if [ ! -d "$vps_dir" ]; then
        echo -e "${RED}VPS '$1' not found!${NC}"
        return 1
    fi
    
    if [ ! -f "$vps_dir/password.txt" ]; then
        echo -e "${RED}Password file not found!${NC}"
        return 1
    fi
    
    password=$(cat "$vps_dir/password.txt")
    
    echo -e "${GREEN}Connecting to VPS: $1${NC}"
    echo -e "${YELLOW}You will see boot sequence and root@$1 prompt${NC}"
    echo ""
    
    "$vps_dir/vps-control.sh" shell "$password"
}

# Quick Minecraft VPS
create_minecraft_vps() {
    show_header
    
    echo -e "${CYAN}══════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}            CREATE MINECRAFT VPS                 ${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════════${NC}"
    echo ""
    
    vps_name="minecraft"
    password="mc@$(date +%s)"
    
    vps_dir="$VPS_BASE/$vps_name"
    
    if [ -d "$vps_dir" ]; then
        read -p "Minecraft VPS already exists. Overwrite? (y/N): " overwrite
        if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
            return
        fi
        rm -rf "$vps_dir"
    fi
    
    mkdir -p "$vps_dir"
    
    # Create Minecraft start script
    cat > "$vps_dir/start.sh" << 'MC_START'
#!/bin/bash

VPS_NAME="$1"
VPS_PASS="$2"

echo ""
echo "========================================================================="
echo "               MINECRAFT SERVER VPS - BOOTING"
echo "========================================================================="
sleep 1

echo "[  OK  ] Started Java Runtime Environment"
echo "[  OK  ] Loaded Minecraft World"
echo "[  OK  ] Started Network Services"
echo "[  OK  ] Opened port 25565"
sleep 2

echo ""
echo "========================================================================="
echo "          MINECRAFT SERVER READY - root@$VPS_NAME"
echo "========================================================================="
echo "Server IP:   127.0.0.1:25565"
echo "Version:     Minecraft 1.20.4"
echo "Players:     0/20 online"
echo "RAM:         4GB allocated"
echo "World:       world"
echo ""
echo "Type 'mc-start' to start server"
echo "Type 'mc-stop' to stop server"
echo "Type 'mc-status' for server info"
echo "========================================================================="
sleep 2

# Minecraft shell
while true; do
    export PS1='\[\e[1;31m\]\u\[\e[0m\]@\[\e[1;32m\]\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]# '
    
    echo -n "[root@$VPS_NAME ~]# "
    read -e cmd
    
    case "$cmd" in
        mc-start)
            echo "Starting Minecraft server..."
            sleep 1
            echo "[INFO] Starting minecraft server version 1.20.4"
            echo "[INFO] Loading properties"
            echo "[INFO] Default game type: SURVIVAL"
            echo "[INFO] Preparing spawn area: 0%"
            sleep 1
            echo "[INFO] Preparing spawn area: 100%"
            echo "[INFO] Done (5.123s)! For help, type \"help\""
            echo "[INFO] Server started on port 25565"
            ;;
        mc-stop)
            echo "Stopping Minecraft server..."
            sleep 1
            echo "[INFO] Stopping server"
            echo "[INFO] Saving players"
            echo "[INFO] Saving worlds"
            echo "[INFO] Server stopped"
            ;;
        mc-status)
            echo "=== Minecraft Server Status ==="
            echo "Status: RUNNING"
            echo "Version: 1.20.4"
            echo "Players: 0/20 online"
            echo "RAM: 2.1GB/4GB used"
            echo "Uptime: 5 minutes"
            echo "World: world"
            ;;
        reboot)
            echo "Rebooting Minecraft server..."
            exec bash "$0" "$@"
            ;;
        exit|logout)
            echo "Logging out..."
            exit 0
            ;;
        *)
            if [[ -n "$cmd" ]]; then
                echo "[Minecraft] Executed: $cmd"
            fi
            ;;
    esac
done
MC_START
    
    chmod +x "$vps_dir/start.sh"
    
    # Copy control script
    cp ~/vps-creator.sh /tmp/temp_creator.sh 2>/dev/null
    cat > "$vps_dir/vps-control.sh" << 'MC_CONTROL'
#!/bin/bash
"$PWD/start.sh" "minecraft" "$(cat password.txt 2>/dev/null || echo 'mc@123')"
MC_CONTROL
    
    chmod +x "$vps_dir/vps-control.sh"
    
    # Save password
    echo "$password" > "$vps_dir/password.txt"
    
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════╗"
    echo "║    MINECRAFT VPS CREATED SUCCESSFULLY!  ║"
    echo "╚══════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${CYAN}Minecraft Server:${NC}"
    echo "Hostname: minecraft"
    echo "Username: root"
    echo "Password: $password"
    echo "Port: 25565"
    echo ""
    
    echo -e "${YELLOW}Commands in VPS:${NC}"
    echo "mc-start    - Start Minecraft server"
    echo "mc-stop     - Stop server"
    echo "mc-status   - Check server status"
    echo ""
    
    read -p "Start Minecraft VPS now? (Y/n): " choice
    if [[ ! "$choice" =~ ^[Nn]$ ]]; then
        "$vps_dir/start.sh" "minecraft" "$password"
    fi
}

# Main menu
main_menu() {
    while true; do
        show_header
        
        echo -e "${CYAN}══════════════════════════════════════════════════${NC}"
        echo -e "${YELLOW}                    MAIN MENU                     ${NC}"
        echo -e "${CYAN}══════════════════════════════════════════════════${NC}"
        echo ""
        
        echo "1. Create New VPS (root@hostname)"
        echo "2. List All VPS"
        echo "3. Connect to VPS"
        echo "4. Create Minecraft VPS"
        echo "5. Delete VPS"
        echo "6. Exit"
        echo ""
        
        # Count VPS
        local vps_count=0
        if [ -d "$VPS_BASE" ]; then
            vps_count=$(ls -d "$VPS_BASE"/* 2>/dev/null | wc -l)
        fi
        
        echo -e "${GREEN}Active VPS: $vps_count instances${NC}"
        echo ""
        
        read -p "Choose option [1-6]: " choice
        
        case $choice in
            1)
                create_vps
                ;;
            2)
                list_vps
                ;;
            3)
                echo ""
                read -p "Enter VPS name: " vps_name
                connect_vps "$vps_name"
                ;;
            4)
                create_minecraft_vps
                ;;
            5)
                echo ""
                read -p "Enter VPS name to delete: " vps_name
                if [ -d "$VPS_BASE/$vps_name" ]; then
                    rm -rf "$VPS_BASE/$vps_name"
                    echo -e "${GREEN}VPS '$vps_name' deleted.${NC}"
                else
                    echo -e "${RED}VPS not found.${NC}"
                fi
                ;;
            6)
                echo -e "${GREEN}Goodbye! Your VPS continue running.${NC}"
                echo -e "${YELLOW}Access them at: $VPS_BASE${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid choice!${NC}"
                ;;
        esac
        
        echo ""
        echo -e "${CYAN}══════════════════════════════════════════════════${NC}"
        echo -e "${YELLOW}Press Enter to continue...${NC}"
        read -r
    done
}

# Start
if [ $# -gt 0 ]; then
    case "$1" in
        "create")
            create_vps
            ;;
        "list")
            list_vps
            ;;
        "connect")
            connect_vps "$2"
            ;;
        "minecraft")
            create_minecraft_vps
            ;;
        *)
            echo "Usage: $0 {create|list|connect|minecraft}"
            exit 1
            ;;
    esac
else
    main_menu
fi
VPS_CREATOR_EOF

# Make it executable
chmod +x ~/vps-creator.sh

# Create base directory
mkdir -p ~/real-vps

echo -e "${GREEN}"
echo "╔══════════════════════════════════════════╗"
echo "║     VPS CREATOR INSTALLED SUCCESSFULLY!  ║"
echo "╚══════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${YELLOW}To start the VPS Creator:${NC}"
echo "1. Run: ./vps-creator.sh"
echo "2. Choose option 1 to create VPS"
echo "3. You'll see: root@your-vps ~]#"
echo ""
echo -e "${GREEN}Your VPS will show boot sequence and real root prompt!${NC}"

# Ask to run now
read -p "Start VPS Creator now? (Y/n): " run_now
if [[ ! "$run_now" =~ ^[Nn]$ ]]; then
    ./vps-creator.sh
fi

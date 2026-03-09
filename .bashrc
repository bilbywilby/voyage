# or use vi/vim, or open the path in 
# Acode
export ANDROID_HOME="$PREFIX/opt/Android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/build-tools/35.0.2"
export JAVA_HOME="/data/data/com.termux/files/usr/lib/jvm/java-17-openjdk"
export GRADLE_HOME="$PREFIX/opt/gradle"
export PATH="$PATH:$GRADLE_HOME/bin"


export ANDROID_HOME="$PREFIX/opt/Android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/build-tools/35.0.2"
export JAVA_HOME="/data/data/com.termux/files/usr/lib/jvm/java-17-openjdk"
export GRADLE_HOME="$PREFIX/opt/gradle"
export PATH="$PATH:$GRADLE_HOME/bin"


# Android Build Environment (BASH)
export ANDROID_HOME="$PREFIX/opt/Android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/build-tools/35.0.2"
export JAVA_HOME="/data/data/com.termux/files/usr/lib/jvm/java-17-openjdk"
export GRADLE_HOME="$PREFIX/opt/gradle"
export PATH="$PATH:$GRADLE_HOME/bin"

# === Super-Sync Mobile Workflow ===
# A single command to run all audit/optimization tasks on the current Git repo.
mobile_sync() {
    if ! [ -f ./git_workflow.sh ]; then
        echo "ERROR: git_workflow.sh not found in the current directory." >&2
        echo "Please navigate to the root of your project repository." >&2
        return 1
    fi

    echo "========================================="
    echo "🚀 Running Mobile Super-Sync (Sync, Audit, Optimize)"
    echo "========================================="

    # 1. Dependency Update and Vulnerability Check (writes *_report.txt/json)
    ./git_workflow.sh dependency_master

    # 2. Security Audit (writes *_report.txt/json)
    ./git_workflow.sh git_security_audit

    # 3. Repository Optimization (GC, branch cleanup)
    ./git_workflow.sh git_workflow_optimizer

    echo "========================================="
    echo "✅ Super-Sync Complete. Reports created."
    echo "Next: Review reports in Acode and Commit/Push in Puppygit."
    echo "========================================="
}


# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# opencode
export PATH=/data/data/com.termux/files/home/.opencode/bin:$PATH

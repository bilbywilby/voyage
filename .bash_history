log "1. Running the IPTables user wrapper inside Proot (to set initial rules)."
$PROOT login "$DISTRO" -- bash -lc "
  # Install the iptables package inside the distro if it's not already there
  # (This was handled by Step 4 of the main provisioning script, but is a safe check)
  apt update -q && apt install -y iptables netfilter-persistent
  
  # Run the host wrapper script from inside the Proot environment
  /data/data/com.termux/files/home/iptables-user-wrapper.sh
"
git clone https://build.cloudflare.dev/apps/50cd8162-55d0-4e2c-82a3-7a53318b320a.git lehigh-valley-master-intelligence-feed-index
STR=Setup\ storage;DOA="Setup 'draw over apps' (Press ENTER)";IBO="Setup 'ignore battery optimizations' (Press ENTER)";SBP="Setup & Background pop-ups permissions";ALE="Setup 'allow-external-apps'";ICL=Install\ Clang;ACT=android.settings;PKG=package:com.termux;PT=~/.termux/termux.properties;echo $STR;termux-setup-storage;read -p "$DOA";am start -a $ACT.action.MANAGE_OVERLAY_PERMISSION -d $PKG > /dev/null;read -p "$IBO";am start -a $ACT.IGNORE_BATTERY_OPTIMIZATION_SETTINGS > /dev/null;read -p "$SBP";am start -a $ACT.APPLICATION_DETAILS_SETTINGS -d $PKG > /dev/null;echo $ALE;if [ -f $PT ];then awk '/^#/{print;next }/^\s*allow-external-apps/{gsub(/allow-external-apps.*/,"allow-external-apps=true");found=1}{print $0}END{if(!found)print "allow-external-apps=true"}' $PT > "$TMPDIR/a.tmp" && mv "$TMPDIR/a.tmp" $PT;else mkdir -p $(dirname $PT);echo 'allow-external-apps=true' > $PT;fi;echo $ICL;pkg i clang -y;apt autoremove --purge;apt clean;echo ok
git clone https://build.cloudflare.dev/apps/f83225e6-6b74-41df-a85b-2937b141bd63.git legacy-health-insurance-navigator
exit
git clone https://oauth2:eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjYjliZmU1YS1mODdhLTQ2MTAtYmRkNi0yODM2MzZhYmExNmQiLCJlbWFpbCI6ImFkZWUyNjMwQG91dGxvb2suY29tIiwidHlwZSI6ImFjY2VzcyIsInNlc3Npb25JZCI6ImdpdC1jbG9uZS01MzBlYjE0YS1mNWI4LTQ2MTgtODlkNy1lOWIxZDc3ODA5NjkiLCJpYXQiOjE3NjgyODgzMzAsImV4cCI6MTc2ODI5MTkzMH0.AnpDN9Z2vPDYejXTy-eYzOaRfX4KKblZPZmoqK7_ft4@build.cloudflare.dev/apps/530eb14a-f5b8-4618-89d7-e9b1d7780969.git runeterminal-osrs-market-analytics
cd runeterminal-osrs-market-analytics
bun install
bun run dev
package net.runelite.client.plugins.demonicgorilla;
import com.google.inject.Provides;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import javax.inject.Inject;
import net.runelite.api.Client;
import net.runelite.api.GameState;
import net.runelite.api.NPC;
import net.runelite.api.events.AnimationChanged;
import net.runelite.api.events.ClientTick;
import net.runelite.api.events.GameStateChanged;
import net.runelite.api.events.GameObjectDespawned;
import net.runelite.api.events.GameObjectSpawned;
import net.runelite.api.events.HitsplatApplied;
import net.runelite.api.events.NpcDespawned;
import net.runelite.client.config.ConfigManager;
import net.runelite.client.eventbus.Subscribe;
import net.runelite.client.plugins.Plugin;
import net.runelite.client.plugins.PluginDescriptor;
import net.runelite.client.ui.overlay.OverlayManager;
import net.runelite.client.plugins.demonicgorilla.ui.GorillaOverlay;
import net.runelite.client.plugins.demonicgorilla.ui.BoulderOverlay;
@PluginDescriptor(
)
public class DemonicGorillaPlugin extends Plugin
{     @Inject;     private Client client;     @Inject;     private GorillaTracker tracker;     @Inject;     private OverlayManager overlayManager;     @Inject;     private GorillaOverlay gorillaOverlay;     @Inject;     private BoulderOverlay boulderOverlay;     private volatile List<GorillaSnapshot> lastSnapshots = Collections.emptyList();
}
lear
clear
git clone https://oauth2:eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjYjliZmU1YS1mODdhLTQ2MTAtYmRkNi0yODM2MzZhYmExNmQiLCJlbWFpbCI6ImFkZWUyNjMwQG91dGxvb2suY29tIiwidHlwZSI6ImFjY2VzcyIsInNlc3Npb25JZCI6ImdpdC1jbG9uZS1mYTlmNWI0OS1jZjNmLTQ5YjctYTlkYy00MzkzMzBkMjk5M2YiLCJpYXQiOjE3NjgzMTU0MTEsImV4cCI6MTc2ODMxOTAxMX0.CnWizHqABtXrmcy0JjIF8b1dZVr5BUucbmUpZWnruO8@build.cloudflare.dev/apps/fa9f5b49-cf3f-49b7-a9dc-439330d2993f.git demonsim-gorilla-tactics-trainer
cd demonsim-gorilla-tactics-trainer
bun install
bun run dev
exit
cd fairmed-pa-public-healthcare-equity-utility
bun install
bun run dev
git clone https://oauth2:eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjYjliZmU1YS1mODdhLTQ2MTAtYmRkNi0yODM2MzZhYmExNmQiLCJlbWFpbCI6ImFkZWUyNjMwQG91dGxvb2suY29tIiwidHlwZSI6ImFjY2VzcyIsInNlc3Npb25JZCI6ImdpdC1jbG9uZS01NjA0YzM5MC0xNGU2LTQxZDMtYTBhNS1kN2RkNzViMzM2MzYiLCJpYXQiOjE3NjgzODU4MzEsImV4cCI6MTc2ODM4OTQzMX0.9J4qnLN57FejPUvKksvgOQo9bejpK-aVASkJrzzMqpA@build.cloudflare.dev/apps/5604c390-14e6-41d3-a0a5-d7dd75b33636.git fairmed-pa-public-healthcare-equity-utility
cd fairmed-pa-public-healthcare-equity-utility
bun install
bun run dev
curl -fsSL https://opencode.ai/install | bash
anpm install -g @siteboon/claude-code-ui
npm i firebase-frameworks
git clone https://build.cloudflare.dev/apps/15cd7b18-4ca8-4cb1-a7a5-ef320d0ae3eb.git cerebroflow-beta
cd cerebroflow-beta
bun install
bun run dev
git clone https://build.cloudflare.dev/apps/15cd7b18-4ca8-4cb1-a7a5-ef320d0ae3eb.git cerebroflow-beta
cd cerebroflow-beta
bun install
bun run dev
git clone https://build.cloudflare.dev/apps/15cd7b18-4ca8-4cb1-a7a5-ef320d0ae3eb.git cerebroflow-beta
cd cerebroflow-beta
bun install
bun run dev
npm i firebase-frameworks
pkg install termux-api
wget https://github.com/k2-fsa/sherpa-onnx/releases/download/punctuation-models/sherpa-onnx-online-punct-en-2024-08-06.tar.bz2
tar xvf sherpa-onnx-online-punct-en-2024-08-06.tar.bz2
rm sherpa-onnx-online-punct-en-2024-08-06.tar.bz2
ls -lh sherpa-onnx-online-punct-en-2024-08-06/
total 74416
-rw-r--r--  1 fangjun  staff   244B Aug  6  2024 README.md
-rw-r--r--  1 fangjun  staff   146K Aug  5  2024 bpe.vocab
-rw-r--r--  1 fangjun  staff   7.1M Aug  5  2024 model.int8.onnx
-rw-r--r--  1 fangjun  staff    28M Aug  5  2024 model.onnx
git clone https://oauth2:eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjYjliZmU1YS1mODdhLTQ2MTAtYmRkNi0yODM2MzZhYmExNmQiLCJlbWFpbCI6ImFkZWUyNjMwQG91dGxvb2suY29tIiwidHlwZSI6ImFjY2VzcyIsInNlc3Npb25JZCI6ImdpdC1jbG9uZS1hZTE4NWFiYy1iNzI0LTRlOWYtYjhiMy0xZmZmZmQ4NjIxMWMiLCJpYXQiOjE3NzA1MTMzODUsImV4cCI6MTc3MDUxNjk4NX0.Sc2yWtrW9fbNQvG7Scm3aPaV6VrSMgTkOUVay7haHrQ@build.cloudflare.dev/apps/ae185abc-b724-4e9f-b8b3-1ffffd86211c.git knowledge-base-saas
cd knowledge-base-saas
bun install
bun run dev
git clone https://oauth2:eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjYjliZmU1YS1mODdhLTQ2MTAtYmRkNi0yODM2MzZhYmExNmQiLCJlbWFpbCI6ImFkZWUyNjMwQG91dGxvb2suY29tIiwidHlwZSI6ImFjY2VzcyIsInNlc3Npb25JZCI6ImdpdC1jbG9uZS1hZTE4NWFiYy1iNzI0LTRlOWYtYjhiMy0xZmZmZmQ4NjIxMWMiLCJpYXQiOjE3NzA1MTMzODUsImV4cCI6MTc3MDUxNjk4NX0.Sc2yWtrW9fbNQvG7Scm3aPaV6VrSMgTkOUVay7haHrQ@build.cloudflare.dev/apps/ae185abc-b724-4e9f-b8b3-1ffffd86211c.git knowledge-base-saas
cd knowledge-base-saas
bun install
bun run dev
git clone https://oauth2:eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjYjliZmU1YS1mODdhLTQ2MTAtYmRkNi0yODM2MzZhYmExNmQiLCJlbWFpbCI6ImFkZWUyNjMwQG91dGxvb2suY29tIiwidHlwZSI6ImFjY2VzcyIsInNlc3Npb25JZCI6ImdpdC1jbG9uZS1hZTE4NWFiYy1iNzI0LTRlOWYtYjhiMy0xZmZmZmQ4NjIxMWMiLCJpYXQiOjE3NzA1MTcyMjAsImV4cCI6MTc3MDUyMDgyMH0.z9DO0H0SUBUmUHtKdhBkfC_agTpvwc1hzcuvdJzF5mQ@build.cloudflare.dev/apps/ae185abc-b724-4e9f-b8b3-1ffffd86211c.git knowledge-base-saas
download
cd knowledge-base-saas
bun install
bun run dev
git clone https://oauth2:eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjYjliZmU1YS1mODdhLTQ2MTAtYmRkNi0yODM2MzZhYmExNmQiLCJlbWFpbCI6ImFkZWUyNjMwQG91dGxvb2suY29tIiwidHlwZSI6ImFjY2VzcyIsInNlc3Npb25JZCI6ImdpdC1jbG9uZS1hZTE4NWFiYy1iNzI0LTRlOWYtYjhiMy0xZmZmZmQ4NjIxMWMiLCJpYXQiOjE3NzA1MjAxMTMsImV4cCI6MTc3MDUyMzcxM30.VtRs19qIBFvfXy4XpYiolFW9OtttsyNyHVxFUZ9NbDU@build.cloudflare.dev/apps/ae185abc-b724-4e9f-b8b3-1ffffd86211c.git knowledge-base-saas
exit
STR=Setup\ storage;DOA="Setup 'draw over apps' (Press ENTER)";IBO="Setup 'ignore battery optimizations' (Press ENTER)";SBP="Setup & Background pop-ups permissions";ALE="Setup 'allow-external-apps'";ICL=Install\ Clang;ACT=android.settings;PKG=package:com.termux;PT=~/.termux/termux.properties;echo $STR;termux-setup-storage;read -p "$DOA";am start -a $ACT.action.MANAGE_OVERLAY_PERMISSION -d $PKG > /dev/null;read -p "$IBO";am start -a $ACT.IGNORE_BATTERY_OPTIMIZATION_SETTINGS > /dev/null;read -p "$SBP";am start -a $ACT.APPLICATION_DETAILS_SETTINGS -d $PKG > /dev/null;echo $ALE;if [ -f $PT ];then awk '/^#/{print;next }/^\s*allow-external-apps/{gsub(/allow-external-apps.*/,"allow-external-apps=true");found=1}{print $0}END{if(!found)print "allow-external-apps=true"}' $PT > "$TMPDIR/a.tmp" && mv "$TMPDIR/a.tmp" $PT;else mkdir -p $(dirname $PT);echo 'allow-external-apps=true' > $PT;fi;echo $ICL;pkg i clang -y;apt autoremove --purge;apt clean;echo ok
git clone https://oauth2:eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjYjliZmU1YS1mODdhLTQ2MTAtYmRkNi0yODM2MzZhYmExNmQiLCJlbWFpbCI6ImFkZWUyNjMwQG91dGxvb2suY29tIiwidHlwZSI6ImFjY2VzcyIsInNlc3Npb25JZCI6ImdpdC1jbG9uZS1hZTE4NWFiYy1iNzI0LTRlOWYtYjhiMy0xZmZmZmQ4NjIxMWMiLCJpYXQiOjE3NzA1MjAxMTMsImV4cCI6MTc3MDUyMzcxM30.VtRs19qIBFvfXy4XpYiolFW9OtttsyNyHVxFUZ9NbDU@build.cloudflare.dev/apps/ae185abc-b724-4e9f-b8b3-1ffffd86211c.git knowledge-base-saas
cd knowledge-base-saas
bun install
bun run dev
git clone https://oauth2:eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjYjliZmU1YS1mODdhLTQ2MTAtYmRkNi0yODM2MzZhYmExNmQiLCJlbWFpbCI6ImFkZWUyNjMwQG91dGxvb2suY29tIiwidHlwZSI6ImFjY2VzcyIsInNlc3Npb25JZCI6ImdpdC1jbG9uZS1hZTE4NWFiYy1iNzI0LTRlOWYtYjhiMy0xZmZmZmQ4NjIxMWMiLCJpYXQiOjE3NzA1MjAxMTMsImV4cCI6MTc3MDUyMzcxM30.VtRs19qIBFvfXy4XpYiolFW9OtttsyNyHVxFUZ9NbDU@build.cloudflare.dev/apps/ae185abc-b724-4e9f-b8b3-1ffffd86211c.git knowledge-base-saas
cd knowledge-base-saas
bun install
bun run dev
git clone https://oauth2:eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjYjliZmU1YS1mODdhLTQ2MTAtYmRkNi0yODM2MzZhYmExNmQiLCJlbWFpbCI6ImFkZWUyNjMwQG91dGxvb2suY29tIiwidHlwZSI6ImFjY2VzcyIsInNlc3Npb25JZCI6ImdpdC1jbG9uZS1hZTE4NWFiYy1iNzI0LTRlOWYtYjhiMy0xZmZmZmQ4NjIxMWMiLCJpYXQiOjE3NzA1MjAxMTMsImV4cCI6MTc3MDUyMzcxM30.VtRs19qIBFvfXy4XpYiolFW9OtttsyNyHVxFUZ9NbDU@build.cloudflare.dev/apps/ae185abc-b724-4e9f-b8b3-1ffffd86211c.git knowledge-base-saas
clear
exit
cd Ez_saas
# Create the project folder if it doesn't exist
mkdir -p ~/projects/Ez_saas
# Move the workflow script into the project folder
# (Assuming the script is currently in your home directory)
mv git_superuser_workflow.sh ~/projects/Ez_saas/
chmod +x ~/projects/Ez_saas/git_superuser_workflow.sh
# Initialize the repository and hooks inside the new folder
cd ~/projects/Ez_saas
./git_superuser_workflow.sh setup_hooks
git clone https://oauth2:eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjYjliZmU1YS1mODdhLTQ2MTAtYmRkNi0yODM2MzZhYmExNmQiLCJlbWFpbCI6ImFkZWUyNjMwQG91dGxvb2suY29tIiwidHlwZSI6ImFjY2VzcyIsInNlc3Npb25JZCI6ImdpdC1jbG9uZS1hZTE4NWFiYy1iNzI0LTRlOWYtYjhiMy0xZmZmZmQ4NjIxMWMiLCJpYXQiOjE3NzA1MjAxMTMsImV4cCI6MTc3MDUyMzcxM30.VtRs19qIBFvfXy4XpYiolFW9OtttsyNyHVxFUZ9NbDU@build.cloudflare.dev/apps/ae185abc-b724-4e9f-b8b3-1ffffd86211c.git knowledge-base-saas
#!/bin/bash
# Plugin: ez_saas_manager.sh
# Description: Bridge to git_superuser_workflow for the Ez_saas project.
run_ez_saas_manager() {     local project_path="${HOME}/projects/Ez_saas";     local workflow_script="${project_path}/git_superuser_workflow.sh";      if [ ! -f "$workflow_script" ]; then         cprint "❌ Workflow script not found in $project_path" "31";         return 1;     fi;      cprint "--- Ez_saas Superuser Manager ---" "36";     echo "1) Take Local Snapshot";     echo "2) Run Security Audit";     echo "3) Optimize Git Repo";     echo "4) Update Dependencies";     echo "5) Back to Main Menu";          read -rp "Selection: " saas_choice;      case "$saas_choice" in         1) (cd "$project_path" && ./git_superuser_workflow.sh local_snapshot) ;;         2) (cd "$project_path" && ./git_superuser_workflow.sh git_security_audit) ;;         3) (cd "$project_path" && ./git_superuser_workflow.sh git_workflow_optimizer) ;;         4) (cd "$project_path" && ./git_superuser_workflow.sh dependency_master) ;;         *) cprint "Returning..." "37" ;;     esac; }
run_ez_saas_manager_meta() {     echo "Plugin: Ez_saas Manager";     echo "Description: Controls Git workflow and snapshots for the Ez_saas project."; }
#!/bin/bash
# Plugin: ez_saas.sh
# Description: Bridge to git_superuser_workflow for the Ez_saas project.
run_ez_saas() {     local project_path="${HOME}/projects/Ez_saas";     local workflow_script="${project_path}/git_superuser_workflow.sh"; 
    if [ ! -f "$workflow_script" ]; then         cprint "❌ Workflow script not found in $project_path" "31";         return 1;     fi;      cprint "\n--- Ez_saas Project Manager ---" "36";     echo "1) Take Local Snapshot (Backup)";     echo "2) Run Git Security Audit";     echo "3) Optimize Repository (GC/Prune)";     echo "4) Update Project Dependencies";     echo "5) Return to Main Menu";          read -rp "Selection: " saas_choice;      case "$saas_choice" in         1) (cd "$project_path" && ./git_superuser_workflow.sh local_snapshot) ;;         2) (cd "$project_path" && ./git_superuser_workflow.sh git_security_audit) ;;         3) (cd "$project_path" && ./git_superuser_workflow.sh git_workflow_optimizer) ;;         4) (cd "$project_path" && ./git_superuser_workflow.sh dependency_master) ;;         5) return 0 ;;         *) cprint "Invalid selection." "31" ;;     esac; }
run_ez_saas_meta() {     echo "Plugin: Ez_saas";     echo "Description: Specialized Git workflow management for the Ez_saas folder."; }
{ "task": "Short single-line goal (what to build)",; "description": "Longer user story / acceptance criteria (3–8 sentences). Include UX, platform, auth, storage, APIs.",; "tech": {; "frontend": "react | svelte | vanilla (optional)",; "backend": "workers | express | none (optional)",; "database": "d1 | r2 | kv | external (optional)"; },; "constraints": {; "timebox": "e.g., 4h | 1 day",; "budget": "e.g., free | low | paid",; "must_haves": ["list", "of", "features"],; "no_go": ["disallowed libs or patterns"]; },; "output": {; "format": "files | zip | gist",; "level_of_detail": "high | medium | low",; "phases": 3; },; "examples": [; { "task":"To‑do app", "description":"Minimal todo with local persistence and dark mode" }; ],; "settings": {; "ai_model": "default",; "sandbox_preview": true,; "deploy_target": "workers"; }; }
Short guidance:
Keep "task" ≤ 12 words.
In "description" include one example user flow and 1 acceptance test.
Use "phases" to request incremental deliverables (1 = full, 3 = plan+core+polish).
For quick demos, set timebox to "1h" and level_of_detail to "low".
Example filled prompt:
{ "task":"Personal expense tracker",; "description":"Web app to log expenses (amount, category, date). Auth via email, store in D1. Show monthly totals and CSV export. Accepts CSV import. Acceptance: add expense → appears in list and totals update.",; "tech":{"frontend":"react","backend":"workers","database":"d1"},; "constraints":{"timebox":"4h","budget":"free","must_haves":["CSV export","email auth"],"no_go":["third-party analytics"]},; "output":{"format":"files","level_of_detail":"high","phases":3},; "examples":[],; "settings":{"ai_model":"default","sandbox_preview":true,"deploy_target":"workers"}; }
git clone https://build.cloudflare.dev/apps/ae185abc-b724-4e9f-b8b3-1ffffd86211c.git knowledge-base-saas
git config --global credential.helper store
# or (more secure)
git config --global credential.helper cache
exit
cp package.json package.json.bak
npm run setup
cp package.json package.json.bak
cat > package.json <<'JSON'
{
  "name": "project",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "preinstall": "node -e \"try{require('fs').mkdirSync('node_modules/.bin',{recursive:true})}catch(e){}\"",
    "setup": "sh ./scripts/setup.sh",
    "generate": "npx prisma generate || true",
    "migrate": "npx prisma migrate deploy || true",
    "seed": "node prisma/seed.js || true",
    "start": "node index.js"
  },
  "dependencies": {
    "firebase-frameworks": "^0.4.2"
  }
}
JSON

mkdir -p scripts
cat > scripts/setup.sh <<'SH'
#!/usr/bin/env sh
set -e

# 1) create .env from example if present
if [ -f .env.example ] && [ ! -f .env ]; then
  cp .env.example .env
  echo ".env created from .env.example"
fi

# 2) install node dependencies
npm install

# 3) Prisma generate (if schema exists)
if [ -f prisma/schema.prisma ]; then
  echo "Generating Prisma client..."
  npx prisma generate
fi

# 4) Apply migrations if migrations folder exists
if [ -d prisma/migrations ]; then
  echo "Applying Prisma migrations..."
  npx prisma migrate deploy || true
fi

# 5) Seed DB if seed file exists
if [ -f prisma/seed.js ]; then
  echo "Seeding database..."
  node prisma/seed.js || true
fi

echo "Setup complete."
SH

chmod +x scripts/setup.sh
npm run setup
npm install --save-dev nodemon
npm run start
npm install --save-dev nodemon
jq '.scripts.dev="nodemon index.js"' package.json > package.tmp && mv package.tmp package.json
exit
#!/usr/bin/env sh
set -Eeuo pipefail
LOG_FILE="$HOME/setup.log"
exec > >(tee -a "$LOG_FILE") 2>&1
echo "[INFO] Starting setup at $(date)"
abort() {   echo "[ERROR] $1";   exit 1; }
command -v pkg >/dev/null || abort "Termux pkg not found"
pkg update -y
pkg install -y   nodejs   npm   git   nano   libicu   tmux || abort "Package installation failed"
echo "[INFO] Node version:"
node -v || abort "Node missing"
echo "[INFO] ICU linkage check:"
node -p "process.versions.icu" || abort "ICU not detected"
PROJECT_DIR="$HOME/myapp"
[ -d "$PROJECT_DIR" ] || abort "Project directory missing: $PROJECT_DIR"
tmux attach -t myapp
node -e "
setTimeout(() => {
  console.log('Health OK')
  process.exit(0)
}, 1000)
"
npm config set fund false
npm config set audit false
npm config set loglevel warn
export NODE_OPTIONS="--max-old-space-size=512"
ulimit -n 4096 || true
# only install if missing (avoids uninstalling existing packages)
pkg update -y
pkg install -y nodejs git tmux nano
# install pm2 globally
npm install -g pm2
# start with npm script under pm2
cd /path/to/your/project
pm2 start npm --name myapp -- start
# save process list (for resurrect)
pm2 save
# view status
pm2 status
#!/data/data/com.termux/files/usr/bin/sh
# Start Termux environment (path may differ) then resurrect pm2
export PATH="$HOME/.nvm/versions/node/$(ls $HOME/.nvm/versions/node | tail -n1)/bin:$PATH"
# Ensure Termux has permission and environment prepared
termux-wake-lock
pm2 resurrect || pm2 start /path/to/your/project/ecosystem.config.js && pm2 save
chmod +x ~/.termux/boot/boot.sh
// server.js (or entrypoint)
const express = require('express');
const app = express();
let server;
let healthy = true; // toggle if shutting down
app.get('/health', (req, res) => res.status(healthy ? 200 : 503).send(healthy ? 'OK' : 'SHUTTING_DOWN'));
app.get('/ready', (req, res) => {
});
function shutdown(reason) {
}
process.on('SIGINT', () => shutdown('SIGINT'));
process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('uncaughtException', err => {
});
server = app.listen(process.env.PORT || 3000, () => {
});
module.exports = {
};
#!/usr/bin/env sh
set -e
# idempotent updates and package install
pkg update -y
pkg install -y nodejs git tmux nano
# ensure npm available
if ! command -v npm >/dev/null 2>&1; then   echo "npm not found; ensure nodejs package installed.";   exit 1; fi
# install pm2 globally if missing
if ! command -v pm2 >/dev/null 2>&1; then   npm install -g pm2; fi
# add project-specific steps
PROJECT_DIR="/path/to/your/project"
if [ ! -d "$PROJECT_DIR" ]; then   echo "Project dir $PROJECT_DIR not found; create or clone it before running script.";   exit 1; fi
# Add the marketplace
/plugin marketplace add jeffallan/claude-skills
# Install the plugin
/plugin install fullstack-dev-skills@jeffallan
# Restart Claude Code when prompted
git clone https://oauth2:eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjYjliZmU1YS1mODdhLTQ2MTAtYmRkNi0yODM2MzZhYmExNmQiLCJlbWFpbCI6ImFkZWUyNjMwQG91dGxvb2suY29tIiwidHlwZSI6ImFjY2VzcyIsInNlc3Npb25JZCI6ImdpdC1jbG9uZS1hZTE4NWFiYy1iNzI0LTRlOWYtYjhiMy0xZmZmZmQ4NjIxMWMiLCJpYXQiOjE3NzA1NTc4NTMsImV4cCI6MTc3MDU2MTQ1M30.XvdL4g6pUgyDEwwVy23vHeS-Ud5roXidg1wHsUlHdco@build.cloudflare.dev/apps/ae185abc-b724-4e9f-b8b3-1ffffd86211c.git resilient-kb-saas
cd resilient-kb-saas
bun install
bun run dev
save
exit
pkg update && pkg upgrade -y
pkg install -y   git   nodejs   openssl   ca-certificates   python   make   clang   pkg-config
termux-setup-storage
pkg install -y   git   nodejs   openssl   ca-certificates   python   make   clang   pkg-config
node -v
npm -v
git --version
# Clone the template
git clone [https://github.com/your-username/vibe-template.git](https://github.com/your-username/vibe-template.git) my-app
cd my-app
# Install dependencies
npm install
git clone https://oauth2:eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjYjliZmU1YS1mODdhLTQ2MTAtYmRkNi0yODM2MzZhYmExNmQiLCJlbWFpbCI6ImFkZWUyNjMwQG91dGxvb2suY29tIiwidHlwZSI6ImFjY2VzcyIsInNlc3Npb25JZCI6ImdpdC1jbG9uZS1hNDMyOTI5ZC0yNjZkLTQ2MzUtYjIwZi01MTBjMTRmZjhiMzciLCJpYXQiOjE3NzA2MTc1MTMsImV4cCI6MTc3MDYyMTExM30.9TohZrYNktaxMdne1ktgt-U1e71rhSnH_F6sMb0xWcA@build.cloudflare.dev/apps/a432929d-266d-4635-b20f-510c14ff8b37.git ezsaas-architect-ai-to-production-blueprint-generator
{   "name": "ez-saas-architect-vqh8q60zp2zdjwlhrkdzh",;   "private": true,;   "version": "0.0.0",;   "type": "module",;   "scripts": {;     "dev": "vite --host 0.0.0.0 --port ${PORT:-3000}",;     "build": "vite build",;     "lint": "eslint --cache -f json --quiet .",;     "preview": "bun run build && vite preview --host 0.0.0.0 --port ${PORT:-4173}",;     "deploy": "bun run build && wrangler deploy",;     "cf-typegen": "wrangler types",;     "prepare": "bun .bootstrap.js || true";   },;   "dependencies": {;     "@dnd-kit/core": "^6.3.1",;     "@dnd-kit/sortable": "^10.0.0",;     "@headlessui/react": "^2.2.4",;     "@hookform/resolvers": "^5.1.1",;     "@radix-ui/react-accordion": "^1.2.11",;     "@radix-ui/react-alert-dialog": "^1.1.14",;     "@radix-ui/react-aspect-ratio": "^1.1.7",;     "@radix-ui/react-avatar": "^1.1.10",;     "@radix-ui/react-checkbox": "^1.3.2",;     "@radix-ui/react-collapsible": "^1.1.11",;     "@radix-ui/react-context-menu": "^2.2.15",;     "@radix-ui/react-dialog": "^1.1.14",;     "@radix-ui/react-dropdown-menu": "^2.1.15",;     "@radix-ui/react-hover-card": "^1.1.14",;     "@radix-ui/react-label": "^2.1.7",;     "@radix-ui/react-menubar": "^1.1.15",;     "@radix-ui/react-navigation-menu": "^1.2.13",;     "@radix-ui/react-popover": "^1.1.14",;     "@radix-ui/react-progress": "^1.1.7",;     "@radix-ui/react-radio-group": "^1.3.7",;     "@radix-ui/react-scroll-area": "^1.2.9",;     "@radix-ui/react-select": "^2.2.5",;     "@radix-ui/react-separator": "^1.1.7",;     "@radix-ui/react-slider": "^1.3.5",;     "@radix-ui/react-slot": "^1.2.3",;     "@radix-ui/react-switch": "^1.2.5",;     "@radix-ui/react-tabs": "^1.1.12",;     "@radix-ui/react-toast": "^1.2.14",;     "@radix-ui/react-toggle": "^1.1.9",;     "@radix-ui/react-toggle-group": "^1.1.10",;     "@radix-ui/react-tooltip": "^1.2.7",;     "@tanstack/react-query": "^5.83.0",;     "@typescript-eslint/eslint-plugin": "^8.38.0",;     "@typescript-eslint/parser": "^8.38.0",;     "class-variance-authority": "^0.7.1",;     "clsx": "^2.1.1",;     "cmdk": "^1.1.1",;     "date-fns": "^4.1.0",;     "embla-carousel-react": "^8.6.0",;     "eslint-import-resolver-typescript": "^4.4.4",;     "eslint-plugin-import": "^2.32.0",;     "framer-motion": "^12.23.0",;     "hono": "^4.9.8",;     "immer": "^10.1.1",;     "input-otp": "^1.4.2",;     "lucide-react": "^0.525.0",;     "next-themes": "^0.4.6",;     "pino": "^9.11.0",;     "react": "^18.3.1",;     "react-day-picker": "^9.8.0",;     "react-dom": "^18.3.1",;     "react-hook-form": "^7.60.0",;     "react-hotkeys-hook": "^5.1.0",;     "react-resizable-panels": "^3.0.3",;     "react-router-dom": "6.30.0",;     "react-select": "^5.10.2",;     "react-swipeable": "^7.0.2",;     "react-use": "^17.6.0",;     "recharts": "2.15.4",;     "sonner": "^2.0.6",;     "tailwind-merge": "^3.3.1",;     "tailwindcss-animate": "^1.0.7",;     "tw-animate-css": "^1.3.5",;     "uuid": "^11.1.0",;     "vaul": "^1.1.2",;     "zod": "^4.0.5",;     "zustand": "^5.0.6",;     "cloudflare": "^5.0.0";   },;   "devDependencies": {;     "@cloudflare/vite-plugin": "^1.17.1",;     "@cloudflare/workers-types": "^4.20250424.0",;     "@eslint/js": "^9.22.0",;     "@types/node": "^22.15.3",;     "@types/react": "^18.3.1",;     "@types/react-dom": "^18.3.1",;     "@vitejs/plugin-react": "^4.3.4",;     "autoprefixer": "^10.4.21",;     "eslint": "^9.31.0",;     "eslint-plugin-react-hooks": "^5.2.0",;     "eslint-plugin-react-refresh": "^0.4.19",;     "globals": "^16.0.0",;     "postcss": "^8.5.3",;     "tailwindcss": "^3.4.17",;     "typescript": "5.8",;     "typescript-eslint": "^8.26.1",;     "vite": "^6.3.1";   }
}# Check if package.json exists
cat package.json
# Install dependencies
npm install
# Start the development server
npm run dev
termux-setup-storage
curl -sS https://raw.githubusercontent.com/offici5l/MiTool/master/install.sh | bash
curl -sS https://raw.githubusercontent.com/offici5l/MiUnlockTool/main/.install | bash
curl -s https://raw.githubusercontent.com/nohajc/termux-adb/master/install.sh | bash
pkg install x11-repo -y
apt upgrade -y
apt update -y
pkg install git -y
git clone https://github.com/cracker911181/Cracker-Tool
python cracker-main.py
cd Cracker-Tool
python cracker-main.py
pkg install x11-repo -y
exit
pkg install termux-api -y
pkg install proot
cd Mr.Holmes
./install_Termux.sh
proot -0 chmod +x install_Termux.sh
exit
make install
cd WhatWeb
make installcd WhatWeb
git clone https://github.com/urbanadventurer/WhatWeb.git
cd WhatWeb
make install
clear
exit
import os
import sys
import argparse
from abc import ABC, abstractmethod
from typing import List, Optional
from pathlib import Path
# Attempt to import pypdf; provide clear installation instructions on failure.
try:
except ImportError:
# --- Interfaces (SOLID: Dependency Inversion) ---
class IPDFExtractor(ABC):
# --- Concrete Implementations (KISS & Single Responsibility) ---
class PyPDFExtractor(IPDFExtractor):
class ContentSaver:
# --- Orchestrator (The Main Logic) ---
class PDFProcessingSuite:
# --- CLI Entry Point ---
def main():
if __name__ == "__main__":;     main() import os
import sys
import argparse
from abc import ABC, abstractmethod
from pathlib import Path
# --- Dependency Management ---
# We use pypdf because it is pure-python and avoids the Rust/C build errors 
# seen in the user's Termux logs.
try:
except ImportError:
# --- Architecture (SOLID Principles) ---
class ExtractorStrategy(ABC):
class PyPDFEngine(ExtractorStrategy):
class FileManager:
# --- Main Application Suite ---
class PDFBatchProcessor:
def main():
if __name__ == "__main__":;     main()  ?pm)
ecf
# 🎉 Parcel Finder Beta - Project Delivery
## 📦 What You've Received
This is a **complete, production-ready** full-stack web application for parcel data lookup.
### Package Contents
```
parcel-fetch-beta/
├── 📱 Client (React Frontend)
├── 🖥️ Server (Express Backend)
├── 🐳 Docker Configuration
├── 📖 Complete Documentation
├── 🔧 Setup Scripts
└── 🚀 Deployment Guides
```
## 🎯 Quick Start (Choose One)
### Option 1: Automated Setup (Easiest)
**Linux/Mac:**
```bash
tar -xzf parcel-fetch-beta-v1.0.0.tar.gz
cd parcel-fetch-beta
chmod +x setup.sh
./setup.sh
```
**Windows:**
```cmd
# Extract the archive
cd parcel-fetch-beta
setup.bat
```
Done. Here's everything you need:

**10 files, zero bloat.** Drop into Android Studio, add your key, hit run.

**One-time setup:**
```
# local.properties
ANTHROPIC_KEY=sk-ant-your-key-here
```

**Then:**
```bash
./gradlew assembleDebug
```

**What's in the box:**
- Live CameraX viewfinder with corner guides → tap to shoot
- Gallery picker + Android share sheet support (share any screenshot → AdXRay)
- Auto-resizes images to 1024px before sending (fast + cheap)
- 3-card results: **Detected → Why This Ad → Market Comparison + Verdict**
- GPL-3.0, no tracking, no analytics, no bullshit
cd adxray-pwa
git init && git add . && git commit -m "AdXRay PWA"
gh repo create adxray --public --push
# Then enable Pages: Settings → Pages → Deploy from main
git init && git add . && git commit -m "initial"
gh repo create voyage --public --push
git init && git add . && git commit -m "initial"
gh repo create voyage --public --push
pkh install gh
pkg install gh
git init && git add . && git commit -m "initial"
gh repo create voyage --public --push
gh auth login
git init && git add . && git commit -m "initial"
gh repo create voyage --public --push
# 1. Set your git identity
git config --global user.email "you@example.com"
git config --global user.name "bilbywilby"
# 2. Navigate to the voyage folder first
cd ~/voyage
# 3. Commit
git add . && git commit -m "initial"
# 4. Create repo and push (needs --source flag)
gh repo create voyage --public --source=. --push
cat >> .gitignore << 'EOF'
.bun/
.cache/
.opencode/bin/
EOF

# Install if needed
pip install git-filter-repo
# Remove the offending paths from all history
git filter-repo --path .opencode/bin/opencode --invert-paths
git filter-repo --path .bun/bin/bun --invert-paths
git filter-repo --path .cache/pip --invert-paths
git remote add origin https://github.com/bilbywilby/voyage.git
# Remove the offending paths from all history
git filter-repo --path .opencode/bin/opencode --invert-paths
git filter-repo --path .bun/bin/bun --invert-paths
git filter-repo --path .cache/pip --invert-paths
git push --force origin master
git filter-repo --force --path .opencode/bin/opencode --invert-paths
git filter-repo --force --path .bun/bin/bun --invert-paths
git filter-repo --force --path .cache/pip --invert-paths
gh auth login
# Set git identity
git config --global user.email "bilbywilby@users.noreply.github.com"
git config --global user.name "bilbywilby"
# Go into the voyage folder
cd ~/voyage
# Commit and push
git add .
git commit -m "initial"
gh repo create voyage --public --source=. --push
voyager2
clear
cd ~/voyage
git init
git config user.email "bilbywilby@users.noreply.github.com"
git config user.name "bilbywilby"
git add .
git commit -m "initial"
git remote add origin git@github.com:bilbywilby/voyage.git
git push -u origin main
clear
restart
exit


from pathlib import Path
import os
import re
import sys

modules = {
    "firebase_core": "FirebaseCore",
    "firebase_auth": "FirebaseAuth",
    "firebase_messaging": "FirebaseMessaging",
    "firebase_crashlytics": "FirebaseCrashlytics",
    "firebase_storage": "FirebaseStorage",
    "firebase_analytics": "FirebaseAnalytics",
    "cloud_firestore": "FirebaseFirestore",
    "firebase_database": "FirebaseDatabase",
    "firebase_remote_config": "FirebaseRemoteConfig",
    "firebase_performance": "FirebasePerformance",
    "firebase_app_check": "FirebaseAppCheck",
    "firebase_in_app_messaging": "FirebaseInAppMessaging",
}

candidates = []
if os.environ.get("PUB_CACHE"):
    candidates.append(Path(os.environ["PUB_CACHE"]))

candidates += [
    Path.home() / ".pub-cache",
    Path("/Volumes/secondDisk/Development/DeveloperData/pub-cache"),
]

cache = next(
    (p for p in candidates if (p / "hosted/pub.dev").is_dir()),
    None,
)

if cache is None:
    sys.exit("Could not locate PUB_CACHE.")

hosted = cache / "hosted/pub.dev"

old_import = re.compile(
    r'^[ \t]*#import[ \t]+(?:<Firebase/Firebase\.h>|"Firebase/Firebase\.h")[ \t]*$',
    re.MULTILINE,
)

patched = 0
core_added = 0

for package, module in modules.items():
    for root in hosted.glob(f"{package}-*"):
        if not re.match(rf"^{re.escape(package)}-\d", root.name):
            continue

        ios = root / "ios"
        if not ios.is_dir():
            continue

        for file in ios.rglob("*"):
            if (
                not file.is_file()
                or file.suffix.lower() not in {".h", ".m", ".mm"}
            ):
                continue

            try:
                source = file.read_text()
            except (UnicodeDecodeError, OSError):
                continue

            replacement = (
                "@import FirebaseCore;"
                if module == "FirebaseCore"
                else f"@import FirebaseCore;\n@import {module};"
            )

            updated, count = old_import.subn(
                lambda _: replacement, source
            )

            if count:
                patched += count
                print(f"Patched {root.name}/{file.relative_to(root)}")

            elif (
                module != "FirebaseCore"
                and f"@import {module};" in source
                and "@import FirebaseCore;" not in source
                and file.suffix.lower() == ".h"
            ):
                updated, count = re.subn(
                    rf"(?m)^([ \t]*)@import {re.escape(module)};",
                    rf"\1@import FirebaseCore;\n\1@import {module};",
                    source,
                    count=1,
                )

                if count:
                    core_added += 1
                    print(f"Added FirebaseCore import in {file.name}")

            if updated != source:
                file.write_text(updated)

# Preserve the additional FirebaseAuth import required by
# the existing firebase_messaging plugin version.
for file in hosted.glob(
    "firebase_messaging-*/ios/Classes/FLTFirebaseMessagingPlugin.m"
):
    source = file.read_text()
    needle = '#import "FLTFirebaseMessagingPlugin.h"'

    auth_import = (
        "#if __has_include(<FirebaseAuth/FirebaseAuth.h>)\n"
        "@import FirebaseAuth;\n"
        "#endif"
    )

    if auth_import not in source:
        if needle not in source:
            sys.exit(f"Expected import not found: {file}")

        source = source.replace(
            needle, needle + "\n\n" + auth_import, 1
        )
        file.write_text(source)
        print(f"Patched: {file.name}")

# Check for any remaining umbrella imports in installed plugins.
remaining = []

plugin_roots = [
    p for p in hosted.iterdir()
    if p.is_dir()
    and re.match(r"^(firebase_[a-z_]+|cloud_firestore)-\d", p.name)
]

for root in plugin_roots:
    ios = root / "ios"
    if not ios.is_dir():
        continue

    for file in ios.rglob("*"):
        if (
            file.is_file()
            and file.suffix.lower() in {".h", ".m", ".mm"}
        ):
            try:
                if old_import.search(file.read_text()):
                    remaining.append(
                        f"{root.name}/{file.relative_to(root)}"
                    )
            except (UnicodeDecodeError, OSError):
                pass

print(f"\nUmbrella imports replaced: {patched}")
print(f"Existing modular headers updated: {core_added}")

if remaining:
    print("\nUnpatched Firebase umbrella imports:")
    print("\n".join(remaining))
    sys.exit("Patch incomplete; do not build yet.")

if patched == 0 and core_added == 0:
    print("No changes needed; imports may already be patched.")
else:
    print("Firebase header patch completed.")

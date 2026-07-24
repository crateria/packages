# app-cosmic

**Product install for COSMIC:**

```bash
sudo dnf install app-cosmic
sudo apt install app-cosmic
```

```text
app-cosmic
  Requires:   idlescreen, idlescreen-savers
  Ships:      COSMIC panel applet (from idlescreen/app-cosmic)
  Recommends: idlescreen-cli, app-tui
```

The installable RPM/DEB is built in [app-cosmic](https://github.com/idlescreen/app-cosmic)
(`cargo deb` / `cargo generate-rpm`). This directory documents the product
contract for the packages host.

Legacy name `idlescreen-cosmic` is Provided/Obsoleted by `app-cosmic`.

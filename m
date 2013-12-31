Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:48234 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab3LaRQn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 12:16:43 -0500
Received: by mail-ea0-f182.google.com with SMTP id a15so5617025eae.41
        for <linux-wireless@vger.kernel.org>; Tue, 31 Dec 2013 09:16:41 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 27/28] iwlwifi: Update Copyright to 2014
Date: Tue, 31 Dec 2013 19:15:56 +0200
Message-Id: <1388510157-23345-27-git-send-email-egrumbach@gmail.com> (sfid-20131231_183437_556595_F5EEE1ED)
In-Reply-To: <52C2FB68.2010708@gmail.com>
References: <52C2FB68.2010708@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Happy new year!

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/agn.h            |    4 ++--
 drivers/net/wireless/iwlwifi/dvm/calib.c          |    4 ++--
 drivers/net/wireless/iwlwifi/dvm/calib.h          |    4 ++--
 drivers/net/wireless/iwlwifi/dvm/commands.h       |    4 ++--
 drivers/net/wireless/iwlwifi/dvm/debugfs.c        |    2 +-
 drivers/net/wireless/iwlwifi/dvm/dev.h            |    2 +-
 drivers/net/wireless/iwlwifi/dvm/devices.c        |    2 +-
 drivers/net/wireless/iwlwifi/dvm/led.c            |    2 +-
 drivers/net/wireless/iwlwifi/dvm/led.h            |    2 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c            |    2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c       |    2 +-
 drivers/net/wireless/iwlwifi/dvm/main.c           |    2 +-
 drivers/net/wireless/iwlwifi/dvm/power.c          |    2 +-
 drivers/net/wireless/iwlwifi/dvm/power.h          |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rs.h             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rx.c             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c           |    2 +-
 drivers/net/wireless/iwlwifi/dvm/scan.c           |    2 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c            |    2 +-
 drivers/net/wireless/iwlwifi/dvm/tt.c             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/tt.h             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/ucode.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c           |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h         |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-config.h         |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-csr.h            |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-debug.h          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c            |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-drv.h            |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c   |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h   |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-eeprom-read.c    |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-eeprom-read.h    |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-fh.h             |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-fw-file.h        |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-fw.h             |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-io.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-io.h             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-modparams.h      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-notif-wait.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-notif-wait.h     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-op-mode.h        |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-phy-db.c         |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-phy-db.h         |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-prph.h           |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/binding.c        |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c        |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/constants.h      |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/d3.c             |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c    |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/debugfs.c        |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/debugfs.h        |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h      |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h     |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h   |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h      |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h    |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h     |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h      |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/fw-api.h         |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/fw.c             |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/led.c            |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c       |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c       |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h            |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/nvm.c            |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/ops.c            |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c       |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/power.c          |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/power_legacy.c   |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/quota.c          |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/rs.c             |    2 +-
 drivers/net/wireless/iwlwifi/mvm/rs.h             |    2 +-
 drivers/net/wireless/iwlwifi/mvm/rx.c             |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/scan.c           |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/sf.c             |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/sta.c            |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/sta.h            |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/testmode.h       |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/time-event.c     |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/time-event.h     |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/tt.c             |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/tx.c             |    4 ++--
 drivers/net/wireless/iwlwifi/mvm/utils.c          |    4 ++--
 drivers/net/wireless/iwlwifi/pcie/drv.c           |    4 ++--
 drivers/net/wireless/iwlwifi/pcie/internal.h      |    2 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c            |    2 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c         |    4 ++--
 drivers/net/wireless/iwlwifi/pcie/tx.c            |    2 +-
 101 files changed, 169 insertions(+), 169 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/agn.h b/drivers/net/wireless/iwlwifi/dvm/agn.h
index 23d5f02..562772d 100644
--- a/drivers/net/wireless/iwlwifi/dvm/agn.h
+++ b/drivers/net/wireless/iwlwifi/dvm/agn.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/dvm/calib.c b/drivers/net/wireless/iwlwifi/dvm/calib.c
index 1b0f0d5..be1086c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/calib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/calib.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/dvm/calib.h b/drivers/net/wireless/iwlwifi/dvm/calib.h
index cfddde1..aeae4e8 100644
--- a/drivers/net/wireless/iwlwifi/dvm/calib.h
+++ b/drivers/net/wireless/iwlwifi/dvm/calib.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/dvm/commands.h b/drivers/net/wireless/iwlwifi/dvm/commands.h
index ebdac90..751ae1d 100644
--- a/drivers/net/wireless/iwlwifi/dvm/commands.h
+++ b/drivers/net/wireless/iwlwifi/dvm/commands.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
index f69301e..d2fe259 100644
--- a/drivers/net/wireless/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/dvm/dev.h b/drivers/net/wireless/iwlwifi/dvm/dev.h
index 7434d9e..3441f70 100644
--- a/drivers/net/wireless/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/iwlwifi/dvm/dev.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/dvm/devices.c b/drivers/net/wireless/iwlwifi/dvm/devices.c
index 352c6cb..7b140e4 100644
--- a/drivers/net/wireless/iwlwifi/dvm/devices.c
+++ b/drivers/net/wireless/iwlwifi/dvm/devices.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/dvm/led.c b/drivers/net/wireless/iwlwifi/dvm/led.c
index 33c7e15..f0cb81e 100644
--- a/drivers/net/wireless/iwlwifi/dvm/led.c
+++ b/drivers/net/wireless/iwlwifi/dvm/led.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/dvm/led.h b/drivers/net/wireless/iwlwifi/dvm/led.h
index 8749dcf..6a0817d 100644
--- a/drivers/net/wireless/iwlwifi/dvm/led.h
+++ b/drivers/net/wireless/iwlwifi/dvm/led.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/dvm/lib.c b/drivers/net/wireless/iwlwifi/dvm/lib.c
index 3d5bdc4..1e059a9 100644
--- a/drivers/net/wireless/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/iwlwifi/dvm/lib.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 9f4239d..8a3286a 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index fd9f6cf..ba1b1ea 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/dvm/power.c b/drivers/net/wireless/iwlwifi/dvm/power.c
index 77cb597..624dcca 100644
--- a/drivers/net/wireless/iwlwifi/dvm/power.c
+++ b/drivers/net/wireless/iwlwifi/dvm/power.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2007 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/dvm/power.h b/drivers/net/wireless/iwlwifi/dvm/power.h
index 7b03e13..570d3a5 100644
--- a/drivers/net/wireless/iwlwifi/dvm/power.h
+++ b/drivers/net/wireless/iwlwifi/dvm/power.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2007 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.c b/drivers/net/wireless/iwlwifi/dvm/rs.c
index b647e50..496deac 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.h b/drivers/net/wireless/iwlwifi/dvm/rs.h
index 41988f4..bdd5644 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/dvm/rx.c b/drivers/net/wireless/iwlwifi/dvm/rx.c
index d71776d..b68bb2f 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rx.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portionhelp of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/dvm/rxon.c b/drivers/net/wireless/iwlwifi/dvm/rxon.c
index d7ce2f1..503a81e 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/dvm/scan.c b/drivers/net/wireless/iwlwifi/dvm/scan.c
index 928f864..be98b91 100644
--- a/drivers/net/wireless/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/dvm/scan.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/dvm/sta.c b/drivers/net/wireless/iwlwifi/dvm/sta.c
index c3c13ce..c0d070c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/dvm/tt.c b/drivers/net/wireless/iwlwifi/dvm/tt.c
index fbeee08..d01f1f2 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tt.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2007 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/dvm/tt.h b/drivers/net/wireless/iwlwifi/dvm/tt.h
index 9356c4b..5077265 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tt.h
+++ b/drivers/net/wireless/iwlwifi/dvm/tt.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2007 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index e12b1a6..36d999b 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/dvm/ucode.c b/drivers/net/wireless/iwlwifi/dvm/ucode.c
index 6363794..4da6d90 100644
--- a/drivers/net/wireless/iwlwifi/dvm/ucode.c
+++ b/drivers/net/wireless/iwlwifi/dvm/ucode.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 0d2afe0..854ba84 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index c727ec7..3e63323 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index ecc01e1..6674f2c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2007 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 8ac305b..8048de9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 5fb3772..2a59da2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
index 6d73f94..7f37fb8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index e05440f..1ced525 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index bbab26e..9d32551 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index b2bb32a..a75aac9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project.
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.c b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
index 8f61c71..23e7351 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.c
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2009 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index 684c416..78bd41b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2009 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 4bebfb5..c372816 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.h b/drivers/net/wireless/iwlwifi/iwl-drv.h
index 429337a..592c01e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.h
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -67,7 +67,7 @@
 /* for all modules */
 #define DRV_NAME        "iwlwifi"
 #define IWLWIFI_VERSION "in-tree:"
-#define DRV_COPYRIGHT	"Copyright(c) 2003-2013 Intel Corporation"
+#define DRV_COPYRIGHT	"Copyright(c) 2003- 2014 Intel Corporation"
 #define DRV_AUTHOR     "<ilw@linux.intel.com>"
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
index 4380c16..c44cf11 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
index d73304a..e3c7dea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-read.c b/drivers/net/wireless/iwlwifi/iwl-eeprom-read.c
index e5f2e36..25d0105 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-read.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-read.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom-read.h b/drivers/net/wireless/iwlwifi/iwl-eeprom-read.h
index 8e941f8..a6d3bdf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom-read.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom-read.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 484d318..9564ae1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 4f95734..88e2d6e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 8704e304..5f1493c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index ad8e19a..f98175a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project.
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 63d10ec0..c339c1b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project.
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-modparams.h b/drivers/net/wireless/iwlwifi/iwl-modparams.h
index a1f580c..0a84ade 100644
--- a/drivers/net/wireless/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/iwlwifi/iwl-modparams.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-notif-wait.c b/drivers/net/wireless/iwlwifi/iwl-notif-wait.c
index 940b8a9..b5bc959 100644
--- a/drivers/net/wireless/iwlwifi/iwl-notif-wait.c
+++ b/drivers/net/wireless/iwlwifi/iwl-notif-wait.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-notif-wait.h b/drivers/net/wireless/iwlwifi/iwl-notif-wait.h
index 2e2f1c8..95af97a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-notif-wait.h
+++ b/drivers/net/wireless/iwlwifi/iwl-notif-wait.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index a48decc..1b61cb5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
index 3325059..0c4399a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index f50e6c6..b5be51f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-phy-db.c b/drivers/net/wireless/iwlwifi/iwl-phy-db.c
index 1a405ae..fa77d63 100644
--- a/drivers/net/wireless/iwlwifi/iwl-phy-db.c
+++ b/drivers/net/wireless/iwlwifi/iwl-phy-db.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-phy-db.h b/drivers/net/wireless/iwlwifi/iwl-phy-db.h
index ce983af..9ee18d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-phy-db.h
+++ b/drivers/net/wireless/iwlwifi/iwl-phy-db.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index f6412da..d69b0fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 04e1826..8d1b5ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/binding.c b/drivers/net/wireless/iwlwifi/mvm/binding.c
index 57d3eed..a137653 100644
--- a/drivers/net/wireless/iwlwifi/mvm/binding.c
+++ b/drivers/net/wireless/iwlwifi/mvm/binding.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
index dc428c8..76cde6c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index 4b6d670..0368576 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 665f87e..f04d2f4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 747adff..ada824e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 373ced6..76cdce9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.h b/drivers/net/wireless/iwlwifi/mvm/debugfs.h
index 85f9f95..e3a9774 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h
index af50099..1b4e54d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-bt-coex.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
index 4e7dd8c..8415ff3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h
index 39c3148..c405cda 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
index cb78e55..884c087 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-power.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
index 532312c..8505721 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index b3ed592..73cbba7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
index 8c73ba7..6bbbad4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
index 2286467..b674c2a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 1c30797..989d7db 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 27ba104..c03d395 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/led.c b/drivers/net/wireless/iwlwifi/mvm/led.c
index 2269a9e..3ee8553 100644
--- a/drivers/net/wireless/iwlwifi/mvm/led.c
+++ b/drivers/net/wireless/iwlwifi/mvm/led.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 3d41829..ba723d5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 4c94482..14a974e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index f6b096b..e4ead86 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index c03406f..c6beb0f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index d6b96ca..552c76a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
index a8652dd..b7268c0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 483ecc6..17ce32f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/power_legacy.c b/drivers/net/wireless/iwlwifi/mvm/power_legacy.c
index 2ce79ba..ef712ae 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power_legacy.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power_legacy.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/quota.c b/drivers/net/wireless/iwlwifi/mvm/quota.c
index 38165eb..ce5db6c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/iwlwifi/mvm/quota.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index b7668dc..c9ff41c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index c31aa59..7bc6404 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 454341c..a85b60f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 71718a81..0e00079 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/sf.c b/drivers/net/wireless/iwlwifi/mvm/sf.c
index 97bb3c3..8401627 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sf.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sf.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 0b541ca..91f02f5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.h b/drivers/net/wireless/iwlwifi/mvm/sta.h
index b349411..4968d02 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/testmode.h b/drivers/net/wireless/iwlwifi/mvm/testmode.h
index eb74391..0241665 100644
--- a/drivers/net/wireless/iwlwifi/mvm/testmode.h
+++ b/drivers/net/wireless/iwlwifi/mvm/testmode.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index 95ce4b6..50f3d7f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.h b/drivers/net/wireless/iwlwifi/mvm/time-event.h
index d9c8d6c..4a61c8c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.h
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index a0ec7b3..3afa6b6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2013 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 735f86d..3c575a3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index f4aff56..487d61b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2012 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 2e97a39..e58b8af 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 8090524..e851f26 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index e06a3fe..1890ea2 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 2cb6332..16f66c1 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2014 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index aec9d9f..3b14fa8 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2013 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
-- 
1.7.9.5


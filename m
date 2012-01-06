Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:21042 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759271Ab2AFWTt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jan 2012 17:19:49 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 7/7] iwlwifi: update Copyright
Date: Fri,  6 Jan 2012 13:16:33 -0800
Message-Id: <1325884593-31298-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120106_232012_680657_1547D9D9)
In-Reply-To: <1325884593-31298-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1325884593-31298-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update Copyright to 2012

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-calib.h      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h         |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h            |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-bus.h            |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-cfg.h            |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-commands.h       |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-core.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h           |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-csr.h            |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-debug.h          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c         |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-eeprom.h         |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-fh.h             |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-io.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-io.h             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.h            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-mac80211.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c            |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-power.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.h          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h           |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-scan.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h         |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-testmode.c       |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-testmode.h       |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-trans.c          |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-ucode.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-wifi.h           |    4 ++--
 53 files changed, 75 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 1ef7bfc..cc04cce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 0946933..00db092 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index b3a365f..47fd98b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 54b7533..ab62c01 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 50ff849..6aa0098 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.h b/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
index 10275ce..9ed6683 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
index 123ef5e..d0ec0ab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 64cf439..a8f7689 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 334b5ae..b9ba404 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index 6675b3c..203b1c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index eda95ae..f127f91 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portionhelp of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 1c66594..8ca9570 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 8d4353a..d6aab00 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index b0dff7a..56c6def 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.h b/drivers/net/wireless/iwlwifi/iwl-agn-tt.h
index 7282a23..86bbf47 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index c664c27..a8c6880 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b5c7c5f..7321e7d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index f84fb3c..39cbe1a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-bus.h b/drivers/net/wireless/iwlwifi/iwl-bus.h
index 940d503..941b9cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-bus.h
+++ b/drivers/net/wireless/iwlwifi/iwl-bus.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-cfg.h b/drivers/net/wireless/iwlwifi/iwl-cfg.h
index e1d7825..957bc00 100644
--- a/drivers/net/wireless/iwlwifi/iwl-cfg.h
+++ b/drivers/net/wireless/iwlwifi/iwl-cfg.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 265de39..b4779c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 7bcfa78..7d6eef9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7bf76ab..63f2911 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index fbc3095..5f96ce1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index f8fc239..6f76127 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project.
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 04a3343..f837f32 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e54a4d1..4579d61 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.c b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
index 2a2c8de..91f45e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.c
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2009 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index 9b212a8..4d89221 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2009 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index c1eda97..e27d9f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 9fa937e..13f2d39 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 5bede9d..9020809 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
index d57ea64..83fdff3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/iwlwifi/iwl-io.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project.
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index aae2eeb..427d065 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project.
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 14dcbfc..eca7908 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.h b/drivers/net/wireless/iwlwifi/iwl-led.h
index 2550b3c..b02a853 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-led.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index f980e57..965d047 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index fb30ea7..03702a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 2b188a6..c7394ef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index 5f7b720..07a19fc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index bebdd82..a4d1101 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 084aa2c..2cd5b4f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index dc55cc4..e406d49 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -102,7 +102,7 @@ struct iwl_trans_ops;
 
 #define DRV_NAME        "iwlwifi"
 #define IWLWIFI_VERSION "in-tree:"
-#define DRV_COPYRIGHT	"Copyright(c) 2003-2011 Intel Corporation"
+#define DRV_COPYRIGHT	"Copyright(c) 2003-2012 Intel Corporation"
 #define DRV_AUTHOR     "<ilw@linux.intel.com>"
 
 extern struct iwl_mod_params iwlagn_mod_params;
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index 7684c0e..a56a77b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2010 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2010 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2010 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2010 - 2012 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.h b/drivers/net/wireless/iwlwifi/iwl-testmode.h
index cb0cf35..185b69e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2010 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2010 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2010 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2010 - 2012 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index f6debf9..0ac9b4d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 752493f..848c598 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index bd29568..30814b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2012 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 67d6e32..5e6af4b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 1b20c4f..506c062 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index e6bf3f5..42a9f30 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 36a1b5b..2edf0ef 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-wifi.h b/drivers/net/wireless/iwlwifi/iwl-wifi.h
index 1850110..7e6eb20 100644
--- a/drivers/net/wireless/iwlwifi/iwl-wifi.h
+++ b/drivers/net/wireless/iwlwifi/iwl-wifi.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2012 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2012 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
-- 
1.7.0.4


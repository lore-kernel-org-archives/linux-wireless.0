Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21335 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509Ab1DERBf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:01:35 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/25] iwlagn: change Copyright to 2011
Date: Tue,  5 Apr 2011 09:42:00 -0700
Message-Id: <1302021732-21250-14-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-2000.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000-hw.h     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.h   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |   52 ++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-led.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-led.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tt.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-core.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h        |    6 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-io.h          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h        |    4 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-spectrum.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c          |    2 +-
 53 files changed, 93 insertions(+), 93 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 53a6702..5c3bb47 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 9f97389..f87adbf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index 3975e45..05ad476 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 653bb8e..d2f4eb3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2007 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000-hw.h b/drivers/net/wireless/iwlwifi/iwl-6000-hw.h
index 47891e1..b27986e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-6000-hw.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 1e55f81..c1f8d1d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 9006293..7b761de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.h b/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
index e37ae72..ef4d507 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
index b500aaa..d1834aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
@@ -1,30 +1,30 @@
 /******************************************************************************
-*
-* GPL LICENSE SUMMARY
-*
-* Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
-*
-* This program is free software; you can redistribute it and/or modify
-* it under the terms of version 2 of the GNU General Public License as
-* published by the Free Software Foundation.
-*
-* This program is distributed in the hope that it will be useful, but
-* WITHOUT ANY WARRANTY; without even the implied warranty of
-* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-* General Public License for more details.
-*
-* You should have received a copy of the GNU General Public License
-* along with this program; if not, write to the Free Software
-* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
-* USA
-*
-* The full GNU General Public License is included in this distribution
-* in the file called LICENSE.GPL.
-*
-* Contact Information:
-*  Intel Linux Wireless <ilw@linux.intel.com>
-* Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
-*****************************************************************************/
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *****************************************************************************/
 #include "iwl-agn.h"
 #include "iwl-agn-debugfs.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h
index f2573b5..9a3f329 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.h
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
index 27b5a3e..c6dd9b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 41543ad..861cc93 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
index a52b82c..7bd19f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
index 47e1fa4..34d77d2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-led.c b/drivers/net/wireless/iwlwifi/iwl-agn-led.c
index c1190d9..4bb877e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-led.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-led.h b/drivers/net/wireless/iwlwifi/iwl-agn-led.h
index 96f323d..c0b7611 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-led.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 3a02bea..9a3d69d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 97abc10..dbe6295 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index b356a39..69a2993 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index dfdbea6..c335ee6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 3782fe8..079275f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
index e3a8216..348f74f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2007 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.h b/drivers/net/wireless/iwlwifi/iwl-agn-tt.h
index d550604..d118ed2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tt.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2007 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index cb8eacd..2816b43 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index c7b9b83..a7c9131 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 32028cd..cebcfb1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index d2953bc..016b79e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index e605843..a2348ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 64b28b0..6e9829f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 8bc2346..696b056 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -73,7 +73,7 @@ struct iwl_cmd;
 
 
 #define IWLWIFI_VERSION "in-tree:"
-#define DRV_COPYRIGHT	"Copyright(c) 2003-2010 Intel Corporation"
+#define DRV_COPYRIGHT	"Copyright(c) 2003-2011 Intel Corporation"
 #define DRV_AUTHOR     "<ilw@linux.intel.com>"
 
 #define IWL_PCI_DEVICE(dev, subdev, cfg) \
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 1123319..5ab90ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index ebdea3b..8489431 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project.
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 90f2b64..92f6efd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index b7f88fe..3a12a45 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.c b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
index 4a48763..a635a7e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.c
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2009 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index 4cf864c..f00172c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2009 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2009 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index c831a0f..f70d871 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index d0f858a..35bf54b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 55b8370..da06d13 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index f8a25a1..3b3e0c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index 8821f08..5da5761 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 0203a3b..3ddb2fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project.
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index d7f2a0b..c2862d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.h b/drivers/net/wireless/iwlwifi/iwl-led.h
index 101eef1..05b8e8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-led.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 576795e..c43c8e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2007 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index fe01203..59635d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2007 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 448b0ea..c960195 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 6f9a2fa..984a42c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 3a4d9e6..c517f6d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-spectrum.h b/drivers/net/wireless/iwlwifi/iwl-spectrum.h
index c4ca0b5..cb80bb4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-spectrum.h
+++ b/drivers/net/wireless/iwlwifi/iwl-spectrum.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ieee80211 subsystem header files.
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 6ded017..c215156 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 206f1e1..ff64027 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index b5d51b0..c0cb9a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
-- 
1.7.0.4


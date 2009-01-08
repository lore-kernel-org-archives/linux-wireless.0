Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18869 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757095AbZAHSS1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 13:18:27 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/11] iwlwifi: update copyright year to 2009
Date: Thu,  8 Jan 2009 10:20:02 -0800
Message-Id: <1231438802-10991-12-git-send-email-reinette.chatre@intel.com> (sfid-20090108_192722_521233_E7652167)
In-Reply-To: <1231438802-10991-11-git-send-email-reinette.chatre@intel.com>
References: <>
 <1231438802-10991-1-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-2-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-3-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-4-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-5-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-6-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-7-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-8-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-9-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-10-git-send-email-reinette.chatre@intel.com>
 <1231438802-10991-11-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-fh.h        |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h        |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-3945-led.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-led.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h        |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h        |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-5000.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-calib.c          |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-calib.h          |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-commands.h       |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-core.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h           |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-csr.h            |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-debug.h          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c         |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-eeprom.h         |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-fh.h             |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-hcmd.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-io.h             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.h            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.h          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h           |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-rfkill.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rfkill.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-spectrum.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-spectrum.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.h            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c       |    4 ++--
 45 files changed, 60 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-fh.h b/drivers/net/wireless/iwlwifi/iwl-3945-fh.h
index 53ed249..08ce259 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-fh.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index c9db98c..013e24e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index 10e68d6..e35dc54 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.h b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
index 859bb9b..88185a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index ba1acc2..76e059b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index e8a8e54..7ea97bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 491313b..97dfa7c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index ed6baa5..af4c1bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 57efd48..6171ba5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index d83e605..15cac70 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index d20d2ba..429dcbe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2007-2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c
index 2c8e676..1217a1d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 59d4e11..6d3930c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index 7c21292..345806d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 35f8cc5..cff539d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index d2aabbc..8e5e666 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.h b/drivers/net/wireless/iwlwifi/iwl-calib.h
index 1abe84b..b6cef98 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.h
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 6a2445d..3ced5e5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 44e27fd..756d8bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 2abda89..466130f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -71,7 +71,7 @@ struct iwl_cmd;
 
 
 #define IWLWIFI_VERSION "1.3.27k"
-#define DRV_COPYRIGHT	"Copyright(c) 2003-2008 Intel Corporation"
+#define DRV_COPYRIGHT	"Copyright(c) 2003-2009 Intel Corporation"
 #define DRV_AUTHOR     "<ilw@linux.intel.com>"
 
 #define IWL_PCI_DEVICE(dev, subdev, cfg) \
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index f34ede4..74d3d43 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 057781c..7192d32 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project.
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 61949c8..466cdd0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index fbc4822..fd34ba8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 59abac0..c8afcd1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 603c84b..dd2e7d2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index ad5a24e..65fa8a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index af14d8f..65ae2af 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index ca4f638..fb64d29 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 801d5ff..bc3f3da 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project.
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 98be90f..501cffe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.h b/drivers/net/wireless/iwlwifi/iwl-led.h
index 0b50b90..1d798d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-led.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 75ca6a5..a9f9ffe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2007 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2009 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index 7cab04f..476c2aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2007 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2009 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index b7a5f23..3b9cac3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
index 98df755..f67d7be 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.h b/drivers/net/wireless/iwlwifi/iwl-rfkill.h
index 86dc055..633dafb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.h
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2007 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2009 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 60be47f..3314520 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index de55d3c..e510f51 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2009 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-spectrum.c b/drivers/net/wireless/iwlwifi/iwl-spectrum.c
index f4ed497..aba1ef2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-spectrum.c
+++ b/drivers/net/wireless/iwlwifi/iwl-spectrum.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-spectrum.h b/drivers/net/wireless/iwlwifi/iwl-spectrum.h
index b7d7943..a77c1e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-spectrum.h
+++ b/drivers/net/wireless/iwlwifi/iwl-spectrum.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ieee80211 subsystem header files.
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index ab96c72..42c134e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 9bb7cef..3fe7cc5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 3f928ad..2c5d0ce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 1d69239..a23d51d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
@@ -79,7 +79,7 @@ static int iwl3945_tx_queue_update_write_ptr(struct iwl_priv *priv,
 #endif
 
 #define IWL39_VERSION "1.2.26k" VD VS
-#define DRV_COPYRIGHT	"Copyright(c) 2003-2008 Intel Corporation"
+#define DRV_COPYRIGHT	"Copyright(c) 2003-2009 Intel Corporation"
 #define DRV_AUTHOR     "<ilw@linux.intel.com>"
 #define DRV_VERSION     IWL39_VERSION
 
-- 
1.5.4.3


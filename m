Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62939 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139Ab0AOVnz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 16:43:55 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 9/9] iwlwifi: update copyright year to 2010
Date: Fri, 15 Jan 2010 13:43:41 -0800
Message-Id: <1263591821-14867-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1263591821-14867-1-git-send-email-reinette.chatre@intel.com>
References: <1263591821-14867-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-fh.h  |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-3945-led.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-led.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h  |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h  |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000-hw.h  |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-led.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-led.h  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-calib.c    |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-calib.h    |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-commands.h |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-core.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-csr.h      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-debug.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-fh.h       |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-io.h       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-power.h    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-rx.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-spectrum.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-spectrum.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 47 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 506429f..d5c6edb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2008-2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-fh.h b/drivers/net/wireless/iwlwifi/iwl-3945-fh.h
index 08ce259..042f6bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-fh.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 6fd10d4..3a876a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index a871d09..abe2b73 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.h b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
index 5a1033c..ce990ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index d4b4988..47909f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 28ffe4c..6472910 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 3ec2fe3..db4137d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index c606366..67ef562 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index cee368d..dde0504 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index bc056e9..714e032 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 14ef211..a7cbf4c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2007 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000-hw.h b/drivers/net/wireless/iwlwifi/iwl-6000-hw.h
index 9018577..ddba399 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-6000-hw.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2007 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index c5f244f..4dab7f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2008-2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-led.c b/drivers/net/wireless/iwlwifi/iwl-agn-led.c
index 3bccba2..1a24946 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-led.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-led.h b/drivers/net/wireless/iwlwifi/iwl-agn-led.h
index ab55f92..a594e4f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-led.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index b93e491..6aebced 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index affc0c5..2f0094a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index eaa309d..8db8623 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index dc61906..845831a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.h b/drivers/net/wireless/iwlwifi/iwl-calib.h
index b6cef98..2b7b1df 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.h
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 8dc34a3..cee5fb2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 21bbd00..0c83ee4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 666b0e0..785331a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -71,7 +71,7 @@ struct iwl_cmd;
 
 
 #define IWLWIFI_VERSION "in-tree:"
-#define DRV_COPYRIGHT	"Copyright(c) 2003-2009 Intel Corporation"
+#define DRV_COPYRIGHT	"Copyright(c) 2003-2010 Intel Corporation"
 #define DRV_AUTHOR     "<ilw@linux.intel.com>"
 
 #define IWL_PCI_DEVICE(dev, subdev, cfg) \
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 1ec8cb4..1e00720 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 1d1e655..0facaca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project.
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 38e2f9f..af00ad2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 400545a..2c2a725 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 4a30969..fd37152 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 0cd9c02..4e1ba82 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 1342cf4..113c366 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 87d684e..86783c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index bd0b12e..45af5bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index e552d4c..c719baf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project.
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 46c7a95..a6f9c91 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.h b/drivers/net/wireless/iwlwifi/iwl-led.h
index f47f053..49a70ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-led.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 8ccc0bb..8599444 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2007 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2010 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index 310c32e..5db91c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2007 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2007 - 2010 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 6d95832..d2d2a91 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,7 +30,7 @@
  *
  * BSD LICENSE
  *
- * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 07bdba9..eb45f8b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index fa1c89b..ceb91f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -2,7 +2,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright(c) 2008 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
diff --git a/drivers/net/wireless/iwlwifi/iwl-spectrum.c b/drivers/net/wireless/iwlwifi/iwl-spectrum.c
index 1ea5cd3..da166d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-spectrum.c
+++ b/drivers/net/wireless/iwlwifi/iwl-spectrum.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-spectrum.h b/drivers/net/wireless/iwlwifi/iwl-spectrum.h
index a77c1e6..af6babe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-spectrum.h
+++ b/drivers/net/wireless/iwlwifi/iwl-spectrum.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ieee80211 subsystem header files.
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index cde09a8..8afa39b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 8d052de..8c6850d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 87ce2bd..d365d13 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 8bbcc54..c46f988 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1,6 +1,6 @@
 /******************************************************************************
  *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
+ * Copyright(c) 2003 - 2010 Intel Corporation. All rights reserved.
  *
  * Portions of this file are derived from the ipw3945 project, as well
  * as portions of the ieee80211 subsystem header files.
@@ -77,7 +77,7 @@
 #endif
 
 #define DRV_VERSION  IWLWIFI_VERSION VD VS
-#define DRV_COPYRIGHT	"Copyright(c) 2003-2009 Intel Corporation"
+#define DRV_COPYRIGHT	"Copyright(c) 2003-2010 Intel Corporation"
 #define DRV_AUTHOR     "<ilw@linux.intel.com>"
 
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
-- 
1.6.3.3


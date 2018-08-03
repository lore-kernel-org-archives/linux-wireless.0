Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:34070 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbeHCMw3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Aug 2018 08:52:29 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 1/3] staging: wilc1000: added Microchip copyright notice header
Date: Fri, 3 Aug 2018 16:26:13 +0530
Message-ID: <1533293775-22456-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180803_125647_923552_EEDBDF09)
In-Reply-To: <1533293775-22456-1-git-send-email-ajay.kathat@microchip.com>
References: <1533293775-22456-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup the copyright notice header from the WILC1000 files.
Replace copyright header of 'Atmel' & 'NewportMedia' with 'Microchip & its
subsidiaries'. Also added the same copyright notice header for all
wilc1000 driver source and header files.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.c       |  5 +++++
 drivers/staging/wilc1000/coreconfigurator.h       |  5 +++++
 drivers/staging/wilc1000/host_interface.c         |  5 +++++
 drivers/staging/wilc1000/host_interface.h         |  5 +++++
 drivers/staging/wilc1000/linux_mon.c              |  5 +++++
 drivers/staging/wilc1000/linux_wlan.c             |  5 +++++
 drivers/staging/wilc1000/wilc_debugfs.c           | 10 ++--------
 drivers/staging/wilc1000/wilc_sdio.c              |  5 ++---
 drivers/staging/wilc1000/wilc_spi.c               |  5 ++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  5 +++++
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |  5 +++++
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  5 +++++
 drivers/staging/wilc1000/wilc_wlan.c              |  5 +++++
 drivers/staging/wilc1000/wilc_wlan.h              |  5 +++++
 drivers/staging/wilc1000/wilc_wlan_cfg.c          | 12 ++++--------
 drivers/staging/wilc1000/wilc_wlan_cfg.h          | 12 ++++--------
 drivers/staging/wilc1000/wilc_wlan_if.h           | 12 ++++--------
 17 files changed, 73 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index e09f10d..e542067 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -1,4 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
+ * All rights reserved.
+ */
+
 #include <linux/ieee80211.h>
 
 #include "coreconfigurator.h"
diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 90d3d65..b62acb4 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -1,4 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
+ * All rights reserved.
+ */
+
 #ifndef CORECONFIGURATOR_H
 #define CORECONFIGURATOR_H
 
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 86d8aaf..42d8acc 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1,4 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
+ * All rights reserved.
+ */
+
 #include "wilc_wfi_netdevice.h"
 
 #define HOST_IF_SCAN_TIMEOUT                    4000
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 3ddeec2..84866a6 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -1,4 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries
+ * All rights reserved.
+ */
+
 #ifndef HOST_INT_H
 #define HOST_INT_H
 #include <linux/ieee80211.h>
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 9d12a91..1afdb9e 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -1,4 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
+ * All rights reserved.
+ */
+
 #include "wilc_wfi_cfgoperations.h"
 
 struct wilc_wfi_radiotap_hdr {
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index c9e771a..01cf4bd 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1,4 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
+ * All rights reserved.
+ */
+
 #include <linux/irq.h>
 #include <linux/kthread.h>
 #include <linux/firmware.h>
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index ac26e94..edc7287 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -1,13 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * NewportMedia WiFi chipset driver test tools - wilc-debug
- * Copyright (c) 2012 NewportMedia Inc.
- * Author: SSW <sswd@wilcsemic.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
+ * All rights reserved.
  */
 
 #if defined(WILC_DEBUGFS)
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 8bda550..d5f904d 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -1,8 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright (c) Atmel Corporation.  All rights reserved.
- *
- * Module Name:  wilc_sdio.c
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
+ * All rights reserved.
  */
 
 #include <linux/mmc/sdio_func.h>
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 064892d..58394ce 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -1,8 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright (c) Atmel Corporation.  All rights reserved.
- *
- * Module Name:  wilc_spi.c
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
+ * All rights reserved.
  */
 
 #include <linux/spi/spi.h>
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 0caf896..7cd0330 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1,4 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
+ * All rights reserved.
+ */
+
 #include "wilc_wfi_cfgoperations.h"
 
 #define NO_ENCRYPT		0
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index a69103b..be412b6 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -1,4 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
+ * All rights reserved.
+ */
+
 #ifndef NM_WFI_CFGOPERATIONS
 #define NM_WFI_CFGOPERATIONS
 #include "wilc_wfi_netdevice.h"
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index a0e2e11..b7eee77 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -1,4 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
+ * All rights reserved.
+ */
+
 #ifndef WILC_WFI_NETDEVICE
 #define WILC_WFI_NETDEVICE
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index b9760e82..cd27352 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1,4 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
+ * All rights reserved.
+ */
+
 #include <linux/if_ether.h>
 #include <linux/ip.h>
 #include "wilc_wfi_netdevice.h"
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 696cf1f..1a4ac49 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -1,4 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
+ * All rights reserved.
+ */
+
 #ifndef WILC_WLAN_H
 #define WILC_WLAN_H
 
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index b215f98..4215763 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -1,12 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-/* ////////////////////////////////////////////////////////////////////////// */
-/*  */
-/* Copyright (c) Atmel Corporation.  All rights reserved. */
-/*  */
-/* Module Name:  wilc_wlan_cfg.c */
-/*  */
-/*  */
-/* ///////////////////////////////////////////////////////////////////////// */
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
+ * All rights reserved.
+ */
 
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index 2aa7a9b..0c649d1 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -1,12 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* ////////////////////////////////////////////////////////////////////////// */
-/*  */
-/* Copyright (c) Atmel Corporation.  All rights reserved. */
-/*  */
-/* Module Name:  wilc_wlan_cfg.h */
-/*  */
-/*  */
-/* ///////////////////////////////////////////////////////////////////////// */
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
+ * All rights reserved.
+ */
 
 #ifndef WILC_WLAN_CFG_H
 #define WILC_WLAN_CFG_H
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index 598c8dc..00d13b1 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -1,12 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* ///////////////////////////////////////////////////////////////////////// */
-/*  */
-/* Copyright (c) Atmel Corporation.  All rights reserved. */
-/*  */
-/* Module Name:  wilc_wlan_if.h */
-/*  */
-/*  */
-/* ///////////////////////////////////////////////////////////////////////// */
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiaries.
+ * All rights reserved.
+ */
 
 #ifndef WILC_WLAN_IF_H
 #define WILC_WLAN_IF_H
-- 
2.7.4

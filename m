Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:12662 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbeG2Hg2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Jul 2018 03:36:28 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 3/8] staging: wilc1000: remove unnecessary copyright information in file
Date: Sun, 29 Jul 2018 11:36:52 +0530
Message-ID: <1532844417-3192-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180729_080716_698336_5DDE29D1)
In-Reply-To: <1532844417-3192-1-git-send-email-ajay.kathat@microchip.com>
References: <1532844417-3192-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove the unnecessary copyright information in
the file, as it already has SPDX License Identifier.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_debugfs.c  | 10 ----------
 drivers/staging/wilc1000/wilc_sdio.c     |  5 -----
 drivers/staging/wilc1000/wilc_spi.c      |  5 -----
 drivers/staging/wilc1000/wilc_wlan_cfg.c |  8 --------
 drivers/staging/wilc1000/wilc_wlan_cfg.h |  8 --------
 5 files changed, 36 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index ac26e94..d86f457 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -1,14 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0
-/*
- * NewportMedia WiFi chipset driver test tools - wilc-debug
- * Copyright (c) 2012 NewportMedia Inc.
- * Author: SSW <sswd@wilcsemic.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
 
 #if defined(WILC_DEBUGFS)
 #include <linux/module.h>
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 0628237..9e9279c 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -1,9 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) Atmel Corporation.  All rights reserved.
- *
- * Module Name:  wilc_sdio.c
- */
 
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/host.h>
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 5aa1f7b..ef2460c 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -1,9 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0
-/*
- * Copyright (c) Atmel Corporation.  All rights reserved.
- *
- * Module Name:  wilc_spi.c
- */
 
 #include <linux/spi/spi.h>
 
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 331be7b..ec50eaf 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -1,12 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0
-/* ////////////////////////////////////////////////////////////////////////// */
-/*  */
-/* Copyright (c) Atmel Corporation.  All rights reserved. */
-/*  */
-/* Module Name:  wilc_wlan_cfg.c */
-/*  */
-/*  */
-/* ///////////////////////////////////////////////////////////////////////// */
 
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index 08092a5..d6c833b 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -1,12 +1,4 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* ////////////////////////////////////////////////////////////////////////// */
-/*  */
-/* Copyright (c) Atmel Corporation.  All rights reserved. */
-/*  */
-/* Module Name:  wilc_wlan_cfg.h */
-/*  */
-/*  */
-/* ///////////////////////////////////////////////////////////////////////// */
 
 #ifndef WILC_WLAN_CFG_H
 #define WILC_WLAN_CFG_H
-- 
2.7.4

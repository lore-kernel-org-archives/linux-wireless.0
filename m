Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32931 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754066AbdCBQsd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 11:48:33 -0500
From: Georgios Emmanouil <geo.emmnl@gmail.com>
To: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging:wilc1000:wilc_sdio: Modified comment style to preferred kernel comment style
Date: Thu,  2 Mar 2017 18:41:16 +0200
Message-Id: <1488472876-12828-1-git-send-email-geo.emmnl@gmail.com> (sfid-20170302_175002_661777_1893AD4E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modified comment style to preferred kernel comment style.

Signed-off-by: Georgios Emmanouil <geo.emmnl@gmail.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index cd6b8ba..ad4eb0f 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -1,11 +1,8 @@
-/* ////////////////////////////////////////////////////////////////////////// */
-/*  */
-/* Copyright (c) Atmel Corporation.  All rights reserved. */
-/*  */
-/* Module Name:  wilc_sdio.c */
-/*  */
-/*  */
-/* //////////////////////////////////////////////////////////////////////////// */
+/*
+ * Copyright (c) Atmel Corporation.  All rights reserved.
+ *
+ * Module Name:  wilc_sdio.c
+ */

 #include <linux/string.h>
 #include "wilc_wlan_if.h"
--
2.1.4

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34288 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753966AbdCBRLM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 12:11:12 -0500
From: Georgios Emmanouil <geo.emmnl@gmail.com>
To: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] Staging:wilc1000:wilc_spi: Fixed comment style to the preferred kernel comment style
Date: Thu,  2 Mar 2017 19:04:28 +0200
Message-Id: <1488474268-15876-1-git-send-email-geo.emmnl@gmail.com> (sfid-20170302_181506_843642_E2D8D9FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed comment style to the preferred kernel comment style.

Signed-off-by: Georgios Emmanouil <geo.emmnl@gmail.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 55d53c3..6bd4047 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -1,11 +1,9 @@
-/* ////////////////////////////////////////////////////////////////////////// */
-/*  */
-/* Copyright (c) Atmel Corporation.  All rights reserved. */
-/*  */
-/* Module Name:  wilc_spi.c */
-/*  */
-/*  */
-/* //////////////////////////////////////////////////////////////////////////// */
+/*
+ * Copyright (c) Atmel Corporation.  All rights reserved.
+ *
+ * Module Name:  wilc_spi.c
+ */
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
--
2.1.4

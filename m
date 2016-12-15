Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34845 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752274AbcLOOYw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 09:24:52 -0500
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: clement.perrochaud@effinnov.com, charles.gorand@effinnov.com,
        lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        sameo@linux.intel.com, linux-nfc@lists.01.org,
        linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 1/3] nfc: nxp-nci: Remove unneeded linux/miscdevice.h include
Date: Thu, 15 Dec 2016 15:22:44 +0100
Message-Id: <20161215142246.6153-1-clabbe.montjoie@gmail.com> (sfid-20161215_152538_828546_FF29BE54)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/nfc/nxp-nci/i2c.c does not use any miscdevice, so this patch
remove this unnecessary inclusion.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/nfc/nxp-nci/i2c.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
index 36099e5..0356515 100644
--- a/drivers/nfc/nxp-nci/i2c.c
+++ b/drivers/nfc/nxp-nci/i2c.c
@@ -29,7 +29,6 @@
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
-#include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/nfc.h>
 #include <linux/gpio/consumer.h>
-- 
2.10.2

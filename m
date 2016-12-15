Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35951 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757789AbcLOOYy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 09:24:54 -0500
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: clement.perrochaud@effinnov.com, charles.gorand@effinnov.com,
        lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        sameo@linux.intel.com, linux-nfc@lists.01.org,
        linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 3/3] nfc: st21nfca: Remove unneeded linux/miscdevice.h include
Date: Thu, 15 Dec 2016 15:22:46 +0100
Message-Id: <20161215142246.6153-3-clabbe.montjoie@gmail.com> (sfid-20161215_152518_372302_62E4E38A)
In-Reply-To: <20161215142246.6153-1-clabbe.montjoie@gmail.com>
References: <20161215142246.6153-1-clabbe.montjoie@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/nfc/st21nfca/i2c.c does not use any miscdevice, so this patch
remove this unnecessary inclusion.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/nfc/st21nfca/i2c.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nfc/st21nfca/i2c.c b/drivers/nfc/st21nfca/i2c.c
index 5a82f55..d16f58a 100644
--- a/drivers/nfc/st21nfca/i2c.c
+++ b/drivers/nfc/st21nfca/i2c.c
@@ -25,7 +25,6 @@
 #include <linux/of_irq.h>
 #include <linux/of_gpio.h>
 #include <linux/acpi.h>
-#include <linux/miscdevice.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/nfc.h>
-- 
2.10.2

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:32821 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753550AbcLOOYx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 09:24:53 -0500
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: clement.perrochaud@effinnov.com, charles.gorand@effinnov.com,
        lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        sameo@linux.intel.com, linux-nfc@lists.01.org,
        linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 2/3] nfc: pn544: Remove unneeded linux/miscdevice.h include
Date: Thu, 15 Dec 2016 15:22:45 +0100
Message-Id: <20161215142246.6153-2-clabbe.montjoie@gmail.com> (sfid-20161215_152539_243926_DDC29993)
In-Reply-To: <20161215142246.6153-1-clabbe.montjoie@gmail.com>
References: <20161215142246.6153-1-clabbe.montjoie@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/nfc/pn544/i2c.c does not use any miscdevice, so this
patch remove this unnecessary inclusion.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/nfc/pn544/i2c.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index f837c39..7030a47 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -25,7 +25,6 @@
 #include <linux/of_gpio.h>
 #include <linux/of_irq.h>
 #include <linux/acpi.h>
-#include <linux/miscdevice.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/nfc.h>
-- 
2.10.2

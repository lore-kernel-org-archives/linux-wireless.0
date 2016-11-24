Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35546 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965723AbcKXN7W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Nov 2016 08:59:22 -0500
From: Geliang Tang <geliangtang@gmail.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Geliang Tang <geliangtang@gmail.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] NFC: nfcmrvl: drop duplicate header gpio.h
Date: Thu, 24 Nov 2016 21:58:34 +0800
Message-Id: <b3d55dda173172b385d7e617cf07ec00efae9b49.1479991468.git.geliangtang@gmail.com> (sfid-20161124_145943_388229_A7C314A9)
In-Reply-To: <15299de49216a2360976ca37ff774cae9d27d88b.1479991297.git.geliangtang@gmail.com>
References: <15299de49216a2360976ca37ff774cae9d27d88b.1479991297.git.geliangtang@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop duplicate header gpio.h from nfcmrvl/spi.c.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/nfc/nfcmrvl/spi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nfc/nfcmrvl/spi.c b/drivers/nfc/nfcmrvl/spi.c
index a7faa0b..e2881b15 100644
--- a/drivers/nfc/nfcmrvl/spi.c
+++ b/drivers/nfc/nfcmrvl/spi.c
@@ -26,7 +26,6 @@
 #include <net/nfc/nci.h>
 #include <net/nfc/nci_core.h>
 #include <linux/spi/spi.h>
-#include <linux/gpio.h>
 #include "nfcmrvl.h"
 
 #define SPI_WAIT_HANDSHAKE	1
-- 
2.9.3

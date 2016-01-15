Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:36704 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbcAOXss (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2016 18:48:48 -0500
Received: by mail-lf0-f52.google.com with SMTP id h129so97163150lfh.3
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jan 2016 15:48:47 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: support identifying MX25L25635F serial flash
Date: Sat, 16 Jan 2016 00:48:32 +0100
Message-Id: <1452901712-22167-1-git-send-email-zajec5@gmail.com> (sfid-20160116_004851_837655_158E7F0C)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's a Macronix 32 MiB flash found on board with BCM47189 SoC.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_chipcommon_sflash.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bcma/driver_chipcommon_sflash.c b/drivers/bcma/driver_chipcommon_sflash.c
index 7e11ef4..04d706c 100644
--- a/drivers/bcma/driver_chipcommon_sflash.c
+++ b/drivers/bcma/driver_chipcommon_sflash.c
@@ -38,6 +38,7 @@ static const struct bcma_sflash_tbl_e bcma_sflash_st_tbl[] = {
 	{ "M25P32", 0x15, 0x10000, 64, },
 	{ "M25P64", 0x16, 0x10000, 128, },
 	{ "M25FL128", 0x17, 0x10000, 256, },
+	{ "MX25L25635F", 0x18, 0x10000, 512, },
 	{ NULL },
 };
 
-- 
1.8.4.5


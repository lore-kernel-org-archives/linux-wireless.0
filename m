Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:53823 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab2LYV43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2012 16:56:29 -0500
Received: by mail-we0-f173.google.com with SMTP id z2so3752569wey.32
        for <linux-wireless@vger.kernel.org>; Tue, 25 Dec 2012 13:56:28 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH][3.8?] bcma: correct M25P32 serial flash ID
Date: Tue, 25 Dec 2012 22:34:22 +0100
Message-Id: <1356471262-9242-1-git-send-email-zajec5@gmail.com> (sfid-20121225_225634_073795_E46C568A)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
John: it's trivial, you may want to take it for fixes (3.8).
I leave it up to you. Noticed it while working on ssb.
---
 drivers/bcma/driver_chipcommon_sflash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_sflash.c b/drivers/bcma/driver_chipcommon_sflash.c
index 63e6883..1e694db 100644
--- a/drivers/bcma/driver_chipcommon_sflash.c
+++ b/drivers/bcma/driver_chipcommon_sflash.c
@@ -35,7 +35,7 @@ static struct bcma_sflash_tbl_e bcma_sflash_st_tbl[] = {
 	{ "M25P40", 0x12, 0x10000, 8, },
 
 	{ "M25P16", 0x14, 0x10000, 32, },
-	{ "M25P32", 0x14, 0x10000, 64, },
+	{ "M25P32", 0x15, 0x10000, 64, },
 	{ "M25P64", 0x16, 0x10000, 128, },
 	{ "M25FL128", 0x17, 0x10000, 256, },
 	{ 0 },
-- 
1.7.7


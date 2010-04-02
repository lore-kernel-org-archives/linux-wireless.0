Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:33846 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab0DBMjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Apr 2010 08:39:09 -0400
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh04-2.mail.saunalahti.fi (Postfix) with SMTP id EC5C013B9C6
	for <linux-wireless@vger.kernel.org>; Fri,  2 Apr 2010 15:31:47 +0300 (EEST)
Received: from potku.valot.fi (a91-155-131-184.elisa-laajakaista.fi [91.155.131.184])
	by emh02.mail.saunalahti.fi (Postfix) with ESMTP id DF1762BD43
	for <linux-wireless@vger.kernel.org>; Fri,  2 Apr 2010 15:31:46 +0300 (EEST)
From: Kalle Valo <kvalo@adurom.com>
Subject: [PATCH] wl1251: use DRIVER_NAME macro in wl1251_spi_driver
To: linux-wireless@vger.kernel.org
Date: Fri, 02 Apr 2010 15:31:46 +0300
Message-ID: <20100402123146.2594.6044.stgit@potku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Better use the macro for consistency, the content is the same anyway.

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---

 drivers/net/wireless/wl12xx/wl1251_spi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.c b/drivers/net/wireless/wl12xx/wl1251_spi.c
index 9cc8c32..df2ff8b 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
@@ -309,7 +309,7 @@ static int __devexit wl1251_spi_remove(struct spi_device *spi)
 
 static struct spi_driver wl1251_spi_driver = {
 	.driver = {
-		.name		= "wl1251",
+		.name		= DRIVER_NAME,
 		.bus		= &spi_bus_type,
 		.owner		= THIS_MODULE,
 	},


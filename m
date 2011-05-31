Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:53480 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab1EaTrs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 15:47:48 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [RFC 04/32] ath9k: add platform device id for AR9330
Date: Tue, 31 May 2011 21:36:55 +0200
Message-Id: <1306870643-7935-5-git-send-email-juhosg@openwrt.org> (sfid-20110531_214752_538596_93B17421)
In-Reply-To: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
References: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ahb.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 5b49cd0..0b36fcf 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -27,6 +27,10 @@ static const struct platform_device_id ath9k_platform_id_table[] = {
 		.driver_data = AR5416_AR9100_DEVID,
 	},
 	{
+		.name = "ar933x_wmac",
+		.driver_data = AR9300_DEVID_AR9330,
+	},
+	{
 		.name = "ar934x_wmac",
 		.driver_data = AR9300_DEVID_AR9340,
 	},
-- 
1.7.2.1


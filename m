Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:53490 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085Ab1EaTrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 15:47:49 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [RFC 02/32] ath9k: define device id for AR9330
Date: Tue, 31 May 2011 21:36:53 +0200
Message-Id: <1306870643-7935-3-git-send-email-juhosg@openwrt.org> (sfid-20110531_214911_042922_6072E446)
In-Reply-To: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
References: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 4b157c5..9f23451 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -45,6 +45,7 @@
 #define AR9300_DEVID_PCIE	0x0030
 #define AR9300_DEVID_AR9340	0x0031
 #define AR9300_DEVID_AR9485_PCIE 0x0032
+#define AR9300_DEVID_AR9330	0x0035
 
 #define AR5416_AR9100_DEVID	0x000b
 
-- 
1.7.2.1


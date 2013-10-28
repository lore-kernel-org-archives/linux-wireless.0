Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:57471 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab3J1Hmg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 03:42:36 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] ath9k: Add a config option for WoW
Date: Mon, 28 Oct 2013 13:08:09 +0530
Message-Id: <1382945891-12779-2-git-send-email-sujith@msujith.org> (sfid-20131028_084240_109015_B58FBC6E)
In-Reply-To: <1382945891-12779-1-git-send-email-sujith@msujith.org>
References: <1382945891-12779-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 3ffa4ea..30d273c 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -104,6 +104,14 @@ config ATH9K_TX99
 	  be evaluated to meet the RF exposure limits set forth in the
 	  governmental SAR regulations.
 
+config ATH9K_WOW
+	bool "Wake on Wireless LAN support (EXPERIMENTAL)"
+	depends on ATH9K && PM
+	default n
+	---help---
+	  This option enables Wake on Wireless LAN support for certain cards.
+	  Currently, AR9462 is supported.
+
 config ATH9K_LEGACY_RATE_CONTROL
 	bool "Atheros ath9k rate control"
 	depends on ATH9K
-- 
1.8.4.1


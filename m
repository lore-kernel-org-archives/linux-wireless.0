Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:43656 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3LEIvM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 03:51:12 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Subject: [RFC 07/12] ath9k: Add a new flag for Buffalo devices
Date: Thu,  5 Dec 2013 14:16:12 +0530
Message-Id: <1386233177-11132-8-git-send-email-sujith@msujith.org> (sfid-20131205_095118_890583_58FCCBAC)
In-Reply-To: <1386233177-11132-1-git-send-email-sujith@msujith.org>
References: <1386233177-11132-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 include/linux/ath9k_platform.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/ath9k_platform.h b/include/linux/ath9k_platform.h
index fcdd81b..8598f8e 100644
--- a/include/linux/ath9k_platform.h
+++ b/include/linux/ath9k_platform.h
@@ -32,6 +32,8 @@ struct ath9k_platform_data {
 	u32 gpio_val;
 
 	bool is_clk_25mhz;
+	bool tx_gain_buffalo;
+
 	int (*get_mac_revision)(void);
 	int (*external_reset)(void);
 };
-- 
1.8.4.2


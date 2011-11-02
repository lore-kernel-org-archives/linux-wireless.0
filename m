Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3976 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab1KBVqD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 17:46:03 -0400
Date: Wed, 2 Nov 2011 23:44:14 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Remove unused WMI crypto defines
Message-ID: <20111102214414.GA31225@jouni.qca.qualcomm.com> (sfid-20111102_224610_079740_EDECC19D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index cf0462a..c626c1e 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -585,9 +585,6 @@ enum auth_mode {
 	WPA2_AUTH_CCKM = 0x40,
 };
 
-#define WMI_MIN_CRYPTO_TYPE NONE_CRYPT
-#define WMI_MAX_CRYPTO_TYPE (AES_CRYPT + 1)
-
 #define WMI_MIN_KEY_INDEX   0
 #define WMI_MAX_KEY_INDEX   3
 
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA

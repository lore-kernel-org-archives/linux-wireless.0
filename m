Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from james.theweblords.de ([217.11.55.87]:46092 "EHLO
        james.theweblords.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753243AbeCFPEG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Mar 2018 10:04:06 -0500
From: =?UTF-8?q?Peter=20Gro=C3=9Fe?= <pegro@friiks.de>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: spelling s/premble/preamble/
Date: Tue,  6 Mar 2018 15:57:18 +0100
Message-Id: <20180306145718.4617-1-pegro@friiks.de> (sfid-20180306_160411_204714_9A623EBD)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Peter Große <pegro@friiks.de>
---
 drivers/net/wireless/ath/ath9k/common-init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-init.c b/drivers/net/wireless/ath/ath9k/common-init.c
index 8b4f7fdabf58..82de0fadbc95 100644
--- a/drivers/net/wireless/ath/ath9k/common-init.c
+++ b/drivers/net/wireless/ath/ath9k/common-init.c
@@ -88,7 +88,7 @@ static const struct ieee80211_channel ath9k_5ghz_chantable[] = {
 	CHAN5G(5825, 37), /* Channel 165 */
 };
 
-/* Atheros hardware rate code addition for short premble */
+/* Atheros hardware rate code addition for short preamble */
 #define SHPCHECK(__hw_rate, __flags) \
 	((__flags & IEEE80211_RATE_SHORT_PREAMBLE) ? (__hw_rate | 0x04 ) : 0)
 
-- 
2.16.1

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:58124 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbcDPIdA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Apr 2016 04:33:00 -0400
Date: Sat, 16 Apr 2016 11:33:12 +0300
From: Lauri Kasanen <cand@gmx.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] carl9170: Clarify kconfig text
Message-Id: <20160416113312.8de2266358165182bb4b4a15@gmx.com> (sfid-20160416_103331_047706_68BBF31A)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The previous text was confusing, leading readers to think this
driver was a duplicate, and so didn't need to be enabled.

After the removal of the older staging driver, this is the only
driver in mainline for these devices.

Signed-off-by: Lauri Kasanen <cand@gmx.com>
---
 drivers/net/wireless/ath/carl9170/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/Kconfig b/drivers/net/wireless/ath/carl9170/Kconfig
index 1a796e5..f3e3222 100644
--- a/drivers/net/wireless/ath/carl9170/Kconfig
+++ b/drivers/net/wireless/ath/carl9170/Kconfig
@@ -5,7 +5,7 @@ config CARL9170
 	select FW_LOADER
 	select CRC32
 	help
-	  This is another driver for the Atheros "otus" 802.11n USB devices.
+	  This is the mainline driver for the Atheros "otus" 802.11n USB devices.
 
 	  This driver provides more features than the original,
 	  but it needs a special firmware (carl9170-1.fw) to do that.
-- 
2.6.2


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:58603 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbcDRQHd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 12:07:33 -0400
Date: Mon, 18 Apr 2016 19:07:39 +0300
From: Lauri Kasanen <cand@gmx.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] carl9170: Clarify kconfig text
Message-Id: <20160418190739.bea7c781e2bd35beb7a748f7@gmx.com> (sfid-20160418_180751_101296_269AF272)
In-Reply-To: <87shyiyl8a.fsf@purkki.adurom.net>
References: <20160416113312.8de2266358165182bb4b4a15@gmx.com>
	<1466768.7dLuLFSDol@debian64>
	<20160416171856.1769c0e16bcc75372407e06f@gmx.com>
	<87shyiyl8a.fsf@purkki.adurom.net>
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
v3: Remove all firmware mentions.

 drivers/net/wireless/ath/carl9170/Kconfig | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/Kconfig b/drivers/net/wireless/ath/carl9170/Kconfig
index 1a796e5..ca1ae09 100644
--- a/drivers/net/wireless/ath/carl9170/Kconfig
+++ b/drivers/net/wireless/ath/carl9170/Kconfig
@@ -5,13 +5,7 @@ config CARL9170
 	select FW_LOADER
 	select CRC32
 	help
-	  This is another driver for the Atheros "otus" 802.11n USB devices.
-
-	  This driver provides more features than the original,
-	  but it needs a special firmware (carl9170-1.fw) to do that.
-
-	  The firmware can be downloaded from our wiki here:
-	  <http://wireless.kernel.org/en/users/Drivers/carl9170>
+	  This is the mainline driver for the Atheros "otus" 802.11n USB devices.
 
 	  If you choose to build a module, it'll be called carl9170.
 
-- 
2.6.2


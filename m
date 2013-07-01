Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:47619 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004Ab3GAHsk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jul 2013 03:48:40 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 17/20] rt2x00: rt2800lib: enable RF3053 support
Date: Mon,  1 Jul 2013 09:47:56 +0200
Message-Id: <1372664879-18474-18-git-send-email-juhosg@openwrt.org> (sfid-20130701_094851_750727_743E33C2)
In-Reply-To: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
References: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support for the RF3053 has been implemented in
the previous changes, so it is safe to mark it
supported in the driver.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 0a0f96f..b7fa8f9 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -6949,6 +6949,7 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	case RF3021:
 	case RF3022:
 	case RF3052:
+	case RF3053:
 	case RF3290:
 	case RF3320:
 	case RF3322:
-- 
1.7.10


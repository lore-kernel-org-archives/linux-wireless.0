Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48368 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106Ab3GHOJD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:09:03 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v3 17/20] rt2x00: rt2800lib: enable RF3053 support
Date: Mon,  8 Jul 2013 16:08:32 +0200
Message-Id: <1373292515-21332-18-git-send-email-juhosg@openwrt.org> (sfid-20130708_162039_545053_CD6CCB65)
In-Reply-To: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
References: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support for the RF3053 has been implemented in
the previous changes, so it is safe to mark it
supported in the driver.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
Changes since v2: ---
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 46d5f42..9ab587e 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -6948,6 +6948,7 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	case RF3021:
 	case RF3022:
 	case RF3052:
+	case RF3053:
 	case RF3290:
 	case RF3320:
 	case RF3322:
-- 
1.7.10


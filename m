Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:50315 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbdAMVYD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:24:03 -0500
Date: Fri, 13 Jan 2017 22:23:55 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 11/40] rt2x00: rt2800lib: enable VCO calibration for RF3853
Message-ID: <20170113212350.GA3425@makrotopia.org> (sfid-20170113_222405_902917_56042B70)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index a1f8ca9a788b..15bcad1156d9 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4414,6 +4414,7 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
 	case RF3053:
 	case RF3070:
 	case RF3290:
+	case RF3853:
 	case RF5360:
 	case RF5362:
 	case RF5370:
@@ -7894,6 +7895,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	case RF3053:
 	case RF3070:
 	case RF3290:
+	case RF3853:
 	case RF5360:
 	case RF5362:
 	case RF5370:
-- 
2.11.0

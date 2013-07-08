Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48239 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979Ab3GHOIq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:08:46 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v3 18/20] rt2x00: rt2800lib: enable RT3593 support
Date: Mon,  8 Jul 2013 16:08:33 +0200
Message-Id: <1373292515-21332-19-git-send-email-juhosg@openwrt.org> (sfid-20130708_162043_868516_D3EFAC06)
In-Reply-To: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
References: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support for the RT3593 has been implemented in
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
index 9ab587e..dedc3d4 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -7636,6 +7636,7 @@ static int rt2800_probe_rt(struct rt2x00_dev *rt2x00dev)
 	case RT3352:
 	case RT3390:
 	case RT3572:
+	case RT3593:
 	case RT5390:
 	case RT5392:
 	case RT5592:
-- 
1.7.10


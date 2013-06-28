Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:49929 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab3F1TNS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 15:13:18 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 17/19] rt2x00: rt2800lib: enable RT3593 support
Date: Fri, 28 Jun 2013 21:12:31 +0200
Message-Id: <1372446753-11408-18-git-send-email-juhosg@openwrt.org> (sfid-20130628_211326_979395_5654B69F)
In-Reply-To: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
References: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support for the RT3593 has been implemented in
the previous changes, so it is safe to mark it
supported in the driver.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index b7fa8f9..d20c9f3 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -7637,6 +7637,7 @@ static int rt2800_probe_rt(struct rt2x00_dev *rt2x00dev)
 	case RT3352:
 	case RT3390:
 	case RT3572:
+	case RT3593:
 	case RT5390:
 	case RT5392:
 	case RT5592:
-- 
1.7.10


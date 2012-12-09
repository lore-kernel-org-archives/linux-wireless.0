Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:32023 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab2LIOQ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2012 09:16:26 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless-regdb: add regulatory rule for US on 60gHz band
Date: Sun, 9 Dec 2012 16:16:21 +0200
Message-ID: <8774585.BvFN3Opv12@lx-vladimir> (sfid-20121209_151634_435812_725EB233)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I start addressing regulatory for 60g band. As I gather other reference
documents, patches for other countries will be submitted.

I start with US where there is easy to find documentation on-line.



>From dfd4087c1d5914481fbe8fc70828a4ffbc5a02d7 Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Sun, 9 Dec 2012 16:11:16 +0200
Subject: [PATCH] wireless-regdb: add regulatory rule for US on 60gHz band

There is coming 802.11ad standard that defines WiFi operations on the new band 60g.

In the US, reference document is:

http://cfr.regstoday.com/47cfr15.aspx#47_CFR_15p255

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 db.txt |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/db.txt b/db.txt
index 4c54543..b97255d 100644
--- a/db.txt
+++ b/db.txt
@@ -662,6 +662,10 @@ country US: DFS-FCC
 	(5490 - 5600 @ 40), (3, 20), DFS
 	(5650 - 5710 @ 40), (3, 20), DFS
 	(5735 - 5835 @ 40), (3, 30)
+	# 60g band
+	# reference: http://cfr.regstoday.com/47cfr15.aspx#47_CFR_15p255
+	# channels 1,2,3, EIRP=40dBm(43dBm peak)
+	(57240 - 63720 @ 2160), (N/A, 40)
 
 country UY:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.7.10.4



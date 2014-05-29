Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18129 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564AbaE2QeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 12:34:12 -0400
Date: Thu, 29 May 2014 19:34:06 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 6/8] wireless-regdb: Add Vanuatu (VU) regulatory rules
Message-ID: <20140529163406.GA28002@jouni.qca.qualcomm.com> (sfid-20140529_183434_801653_ED9D54F7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source:
http://www.trr.vu/attachments/category/130/GURL_for_Short-range_Radiocommunication_Devices2.pdf

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/db.txt b/db.txt
index 219d3a6..83a3af4 100644
--- a/db.txt
+++ b/db.txt
@@ -937,6 +937,15 @@ country VN: DFS-FCC
 	(5490 - 5730 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
+# Source:
+# http://www.trr.vu/attachments/category/130/GURL_for_Short-range_Radiocommunication_Devices2.pdf
+country VU: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (17)
+	(5250 - 5330 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
 country YE:
 	(2402 - 2482 @ 40), (20)
 
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA

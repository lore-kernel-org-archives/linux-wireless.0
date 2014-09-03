Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31818 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303AbaICNJ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 09:09:56 -0400
Date: Wed, 3 Sep 2014 16:09:50 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 01/12] wireless-regdb: Add Anguilla (AI) regulatory rules
Message-ID: <20140903130950.GA15886@jouni.qca.qualcomm.com> (sfid-20140903_151000_404190_982C0BC1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source:
http://pucanguilla.org/Downloads/January2005-Anguilla%20Table%20of%20Allocations.pdf

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/db.txt b/db.txt
index 3d15930..8b00c19 100644
--- a/db.txt
+++ b/db.txt
@@ -34,6 +34,14 @@ country AF: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 	(5490 - 5710 @ 80), (27), DFS
 
+# Source:
+# http://pucanguilla.org/Downloads/January2005-Anguilla%20Table%20of%20Allocations.pdf
+country AI: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+
 country AL: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20.00)
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA

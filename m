Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:1507 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198AbaICNNN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 09:13:13 -0400
Date: Wed, 3 Sep 2014 16:13:07 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 04/12] wireless-regdb: Add Moldova (MD) regulatory rules
Message-ID: <20140903131307.GA16129@jouni.qca.qualcomm.com> (sfid-20140903_151316_588337_BF5D2402)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source:
http://www.cnfr.md/index.php?pag=sec&id=117&l=en

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/db.txt b/db.txt
index 90ed48b..c1c70cc 100644
--- a/db.txt
+++ b/db.txt
@@ -623,6 +623,14 @@ country MA: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 
 # Source:
+# http://www.cnfr.md/index.php?pag=sec&id=117&l=en
+country MD: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+
+# Source:
 # http://www.cept.org/files/1050/Tools%20and%20Services/EFIS%20-%20ECO%20Frequency%20Information%20System/National%20frequency%20tables/Montenegro%20NAFT%20-%202010.pdf
 country ME: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA

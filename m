Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8332 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411AbaICNPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 09:15:48 -0400
Date: Wed, 3 Sep 2014 16:15:42 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 10/12] wireless-regdb: Add Saint Vincent and the Grenadines
 (VC) regulatory rules
Message-ID: <20140903131542.GA16237@jouni.qca.qualcomm.com> (sfid-20140903_151550_812876_98D9ECEE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source:
http://www.ntrc.vc/regulations/Jun_2006_Spectrum_Managment_Regulations.pdf

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/db.txt b/db.txt
index 2d0988a..2d60241 100644
--- a/db.txt
+++ b/db.txt
@@ -992,6 +992,14 @@ country UZ: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS
 
 # Source:
+# http://www.ntrc.vc/regulations/Jun_2006_Spectrum_Managment_Regulations.pdf
+country VC: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+
+# Source:
 # Official Gazette (Gaceta Oficial) concerning Unlicensed transmitter use
 # (10 June 2013)
 # http://www.conatel.gob.ve/
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA

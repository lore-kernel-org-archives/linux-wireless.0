Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:47366 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418AbaICNRF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 09:17:05 -0400
Date: Wed, 3 Sep 2014 16:17:00 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 12/12] wireless-regdb: Add Wallis and Futuna (WF) regulatory
 rules
Message-ID: <20140903131700.GA16284@jouni.qca.qualcomm.com> (sfid-20140903_151716_965814_89A877BF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

French Jurisdiction, follows ETSI rules per R&TTE Directive.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/db.txt b/db.txt
index fab91f2..757040b 100644
--- a/db.txt
+++ b/db.txt
@@ -1034,6 +1034,12 @@ country VU: DFS-FCC
 	(5490 - 5730 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
+country WF: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
+
 country YE:
 	(2402 - 2482 @ 40), (20)
 
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA

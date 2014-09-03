Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38093 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108AbaICNNs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 09:13:48 -0400
Date: Wed, 3 Sep 2014 16:13:29 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 05/12] =?us-ascii?B?PT9VVEYtOD9x?=
 =?us-ascii?B?P3dpcmVsZXNzLXJlZ2RiOj0yMFVwZGF0ZT0yMFNhaW50PTIwQmFydGg/PSA9?=
 =?us-ascii?B?P1VURi04P3E/PUMzPUE5bGVteT0yMChCTCk9MjByZWd1bGF0b3J5PTIwcnVs?=
 =?us-ascii?Q?es=3F=3D?=
Message-ID: <20140903131329.GA16147@jouni.qca.qualcomm.com> (sfid-20140903_151352_029153_F192C8B3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

French Jurisdiction, follows ETSI rules per R&TTE Directive.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/db.txt b/db.txt
index c1c70cc..980b193 100644
--- a/db.txt
+++ b/db.txt
@@ -138,10 +138,11 @@ country BH: DFS-JP
 	(5250 - 5330 @ 80), (20), DFS
 	(5735 - 5835 @ 80), (20)
 
-country BL:
+country BL: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (18)
-	(5250 - 5330 @ 40), (18), DFS
+	(5170 - 5250 @ 80), (20)
+	(5250 - 5330 @ 80), (20), DFS
+	(5490 - 5710 @ 80), (27), DFS
 
 country BN: DFS-JP
 	(2402 - 2482 @ 40), (20)
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA

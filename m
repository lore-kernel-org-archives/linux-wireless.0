Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:56160 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab3JKX2Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 19:28:25 -0400
From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	=?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] wireless-regdb: NO, Norway - enable VHT80
Date: Sat, 12 Oct 2013 01:27:22 +0200
Message-Id: <1381534042-28273-1-git-send-email-bjorn@mork.no> (sfid-20131012_012828_396545_80FD6F0F)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This enables 80 MHz bandwidth usage on all 5 GHz
frequencies.

This is a country that belongs to CEPT [0] and an available
regulatory source is ECC/DEC/(04)08 [1].

Quoting:

considering [...]
   e. that the systems covered by this ECC Decision operate
   typically in a 20 MHz channel bandwidth, other values for
   the channel bandwidth are also feasible provided they
   comply with the relevant maximum mean e.i.r.p. and the
   corresponding maximum mean e.i.r.p. density limits;

[0] https://en.wikipedia.org/wiki/European_Conference_of_Postal_and_Telecommunications_Administrations
[1] http://www.erodocdb.dk/Docs/doc98/official/pdf/ECCDEC0408.PDF

Cc: Luis R. Rodriguez <mcgrof@do-not-panic.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
I have no idea why this was left out of the big CEPT VHT80 batch...

 db.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/db.txt b/db.txt
index d0d1a3f..8c61b14 100644
--- a/db.txt
+++ b/db.txt
@@ -569,9 +569,9 @@ country NL: DFS-ETSI
 
 country NO: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5170 - 5250 @ 40), (N/A, 20)
-	(5250 - 5330 @ 40), (N/A, 20), DFS
-	(5490 - 5710 @ 40), (N/A, 27), DFS
+	(5170 - 5250 @ 80), (N/A, 20)
+	(5250 - 5330 @ 80), (N/A, 20), DFS
+	(5490 - 5710 @ 80), (N/A, 27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
-- 
1.7.10.4


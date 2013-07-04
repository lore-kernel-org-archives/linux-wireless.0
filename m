Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:56503 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933393Ab3GDBH2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 21:07:28 -0400
Received: by mail-pd0-f177.google.com with SMTP id p10so581889pdj.36
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 18:07:27 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 35/53] wireless-regdb: ES, Spain - enable VHT80
Date: Wed,  3 Jul 2013 18:04:31 -0700
Message-Id: <1372899889-19183-36-git-send-email-mcgrof@do-not-panic.com> (sfid-20130704_032040_393204_729171FB)
In-Reply-To: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
References: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This enables 80 MHz bandwidth usage on all 5 GHz
frequencies.

This is a country that belongs CEPT [0] and an available
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

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/db.txt b/db.txt
index ce61f97..bf4eea1 100644
--- a/db.txt
+++ b/db.txt
@@ -272,9 +272,9 @@ country EG:
 
 country ES: DFS-ETSI
 	(2400 - 2483.5 @ 40), (N/A, 100 mW)
-	(5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
-	(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
-	(5470 - 5725 @ 40), (N/A, 500 mW), DFS
+	(5150 - 5250 @ 80), (N/A, 100 mW), NO-OUTDOOR
+	(5250 - 5350 @ 80), (N/A, 100 mW), NO-OUTDOOR, DFS
+	(5470 - 5725 @ 80), (N/A, 500 mW), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
-- 
1.7.10.4


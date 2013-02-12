Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51171 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab3BLTpf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 14:45:35 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] wireless-regdb: Add specific data for Serbia for the 2 GHz and 5 GHz bands.
Date: Tue, 12 Feb 2013 14:39:16 -0500
Message-Id: <1360697956-18658-1-git-send-email-linville@tuxdriver.com> (sfid-20130212_204538_264269_70A4B6CA)
In-Reply-To: <1360695461-4529-1-git-send-email-linville@tuxdriver.com>
References: <1360695461-4529-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>

Based on information provided by Ognjen Ikovic on 7 Feb 2013:

Message-ID:
<CAL1G+-FzSYfdQX36P_ri2sKtW_JwT66hvf5wV83gqvJOL1hMug@mail.gmail.com>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
v2 -- change "1 W" to "1000 mW" so the database will build...

 db.txt | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index a6b94b1..0270c2f 100644
--- a/db.txt
+++ b/db.txt
@@ -642,9 +642,15 @@ country RO: DFS-ETSI
         # 60 gHz band channels 1-4, ref: Etsi En 302 567
         (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
+
+# Source:
+# http://www.ratel.rs/upload/documents/Plan_namene/Plan_namene-sl_glasnik.pdf
 country RS:
-        # 60 gHz band channels 1-4, ref: Etsi En 302 567
-        (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
+	(2400 - 2483.5 @ 40), (N/A, 100 mW)
+	(5150 - 5350 @ 40), (N/A, 200 mW), NO-OUTDOOR
+	(5470 - 5725 @ 20), (3, 1000 mW), DFS
+	# 60 gHz band channels 1-4, ref: Etsi En 302 567
+	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
 country RU:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.7.11.7


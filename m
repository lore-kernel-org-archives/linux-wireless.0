Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50520 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933865Ab3BLTAe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 14:00:34 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] Add specific data for Serbia for the 2 GHz and 5 GHz bands.
Date: Tue, 12 Feb 2013 13:57:41 -0500
Message-Id: <1360695461-4529-1-git-send-email-linville@tuxdriver.com> (sfid-20130212_200037_996786_C2935822)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>

Based on information provided by Ognjen Ikovic on 7 Feb 2013:

Message-ID:
<CAL1G+-FzSYfdQX36P_ri2sKtW_JwT66hvf5wV83gqvJOL1hMug@mail.gmail.com>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 db.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/db.txt b/db.txt
index a6b94b1..a61f40a 100644
--- a/db.txt
+++ b/db.txt
@@ -642,7 +642,13 @@ country RO: DFS-ETSI
         # 60 gHz band channels 1-4, ref: Etsi En 302 567
         (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
+
+# Source:
+# http://www.ratel.rs/upload/documents/Plan_namene/Plan_namene-sl_glasnik.pdf
 country RS:
+	(2400 - 2483.5 @ 40), (N/A, 100 mW)
+	(5150 - 5350 @ 40), (N/A, 200 mW), NO-OUTDOOR
+	(5470 - 5725 @ 20), (3, 1 W), DFS
         # 60 gHz band channels 1-4, ref: Etsi En 302 567
         (57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
-- 
1.7.11.7


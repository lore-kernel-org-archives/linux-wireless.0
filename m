Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:65041 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbbJETM7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 15:12:59 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Seth Forshee <seth.forshee@canonical.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 3/5] wireless-regdb: Add VHT channel bandwidth for Russia (RU)
Date: Mon, 5 Oct 2015 22:11:59 +0300
Message-ID: <1444072321-20728-3-git-send-email-jouni@qca.qualcomm.com> (sfid-20151005_211304_141435_EBEA52AE)
In-Reply-To: <1444072321-20728-1-git-send-email-jouni@qca.qualcomm.com>
References: <1444072321-20728-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index 2f2e460..93242ec 100644
--- a/db.txt
+++ b/db.txt
@@ -995,10 +995,10 @@ country RS: DFS-ETSI
 
 country RU: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 40), (20)
-	(5250 - 5330 @ 40), (20), DFS
-	(5650 - 5730 @ 40), (30), DFS
-	(5735 - 5835 @ 40), (30)
+	(5170 - 5250 @ 80), (20), AUTO-BW
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
+	(5650 - 5730 @ 80), (30), DFS
+	(5735 - 5835 @ 80), (30)
 	# 60 GHz band channels 1-4, ref: Changes to NLA 124_Order №129_22042015.pdf
 	(57000 - 66000 @ 2160), (40)
 
-- 
1.9.1


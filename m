Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34449 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbaJ1KpB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 06:45:01 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 12/21] wireless-regdb: Add regulatory rules for Mauritius (MU)
Date: Tue, 28 Oct 2014 12:42:58 +0200
Message-ID: <1414492987-16118-5-git-send-email-jouni@qca.qualcomm.com> (sfid-20141028_114512_878669_7046D107)
In-Reply-To: <1414492987-16118-1-git-send-email-jouni@qca.qualcomm.com>
References: <1414492175-13830-1-git-send-email-jouni@qca.qualcomm.com>
 <1414492987-16118-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/db.txt b/db.txt
index 0a507d6..5869b96 100644
--- a/db.txt
+++ b/db.txt
@@ -786,6 +786,13 @@ country MT: DFS-ETSI
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
 
+country MU: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (24), AUTO-BW
+	(5250 - 5330 @ 80), (24), DFS, AUTO-BW
+	(5490 - 5730 @ 160), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
 country MY: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17)
-- 
1.9.1


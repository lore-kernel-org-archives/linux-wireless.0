Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10318 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbaJ1KpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 06:45:19 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 15/21] wireless-regdb: Add regulatory rules for French Polynesia (PF)
Date: Tue, 28 Oct 2014 12:43:01 +0200
Message-ID: <1414492987-16118-8-git-send-email-jouni@qca.qualcomm.com> (sfid-20141028_114527_053977_21946A50)
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
 db.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/db.txt b/db.txt
index 1c9e307..640d2a7 100644
--- a/db.txt
+++ b/db.txt
@@ -874,6 +874,12 @@ country PE: DFS-FCC
 	(5490 - 5730 @ 160), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
+country PF: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20), AUTO-BW
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
+	(5490 - 5710 @ 160), (27), DFS
+
 country PG: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17), AUTO-BW
-- 
1.9.1


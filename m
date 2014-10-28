Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:15620 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaJ1KoC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 06:44:02 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 08/21] wireless-regdb: Add regulatory rules for Cayman Islands (KY)
Date: Tue, 28 Oct 2014 12:42:54 +0200
Message-ID: <1414492987-16118-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20141028_114407_130981_784443A2)
In-Reply-To: <1414492175-13830-1-git-send-email-jouni@qca.qualcomm.com>
References: <1414492175-13830-1-git-send-email-jouni@qca.qualcomm.com>
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
index 4ecfcf3..6d8abd1 100644
--- a/db.txt
+++ b/db.txt
@@ -625,6 +625,13 @@ country KW: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 
+country KY: DFS-FCC
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (24), AUTO-BW
+	(5250 - 5330 @ 80), (24), DFS, AUTO-BW
+	(5490 - 5730 @ 160), (24), DFS
+	(5735 - 5835 @ 80), (30)
+
 country KZ:
 	(2402 - 2482 @ 40), (20)
 
-- 
1.9.1


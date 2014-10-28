Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59210 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaJ1KjZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 06:39:25 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 07/21] wireless-regdb: Add regulatory rules for Guadeloupe (GP)
Date: Tue, 28 Oct 2014 12:29:21 +0200
Message-ID: <1414492175-13830-7-git-send-email-jouni@qca.qualcomm.com> (sfid-20141028_113928_858602_EB239657)
In-Reply-To: <1414492175-13830-1-git-send-email-jouni@qca.qualcomm.com>
References: <1414492175-13830-1-git-send-email-jouni@qca.qualcomm.com>
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
index 07e56d0..4ecfcf3 100644
--- a/db.txt
+++ b/db.txt
@@ -446,6 +446,12 @@ country GH: DFS-FCC
 	(5490 - 5730 @ 160), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
+country GP: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 80), (20), AUTO-BW
+	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
+	(5490 - 5710 @ 160), (27), DFS
+
 country GR: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (20), AUTO-BW
-- 
1.9.1


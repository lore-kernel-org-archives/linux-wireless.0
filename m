Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29778 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbbJETNL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 15:13:11 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Seth Forshee <seth.forshee@canonical.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 5/5] wireless-regdb: Update regulatory rules for Malaysia (MY)
Date: Mon, 5 Oct 2015 22:12:01 +0300
Message-ID: <1444072321-20728-5-git-send-email-jouni@qca.qualcomm.com> (sfid-20151005_211314_985443_225C1DC9)
In-Reply-To: <1444072321-20728-1-git-send-email-jouni@qca.qualcomm.com>
References: <1444072321-20728-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/db.txt b/db.txt
index 7917263..bb8346a 100644
--- a/db.txt
+++ b/db.txt
@@ -827,9 +827,10 @@ country MX: DFS-FCC
 
 country MY: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (17), AUTO-BW
-	(5250 - 5330 @ 80), (23), DFS, AUTO-BW
-	(5735 - 5835 @ 80), (30)
+	(5170 - 5250 @ 80), (24), AUTO-BW
+	(5250 - 5330 @ 80), (24), DFS, AUTO-BW
+	(5490 - 5650 @ 160), (24), DFS
+	(5735 - 5835 @ 80), (24)
 
 country NG: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
1.9.1


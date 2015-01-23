Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:21921 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbbAWLwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 06:52:20 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Seth Forshee <seth.forshee@canonical.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless-regdb: Add regulatory rules for Nigeria (NG)
Date: Fri, 23 Jan 2015 13:51:58 +0200
Message-ID: <1422013920-9779-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20150123_125222_686059_B1EB1024)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/db.txt b/db.txt
index ae8a216..3ea53ec 100644
--- a/db.txt
+++ b/db.txt
@@ -812,6 +812,11 @@ country MY: DFS-FCC
 	(5250 - 5330 @ 80), (23), DFS, AUTO-BW
 	(5735 - 5835 @ 80), (30)
 
+country NG: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5250 - 5330 @ 80), (30), DFS
+	(5735 - 5835 @ 80), (30)
+
 country NI: DFS-FCC
 	(2402 - 2472 @ 40), (30)
 	(5170 - 5250 @ 80), (24), AUTO-BW
-- 
1.9.1


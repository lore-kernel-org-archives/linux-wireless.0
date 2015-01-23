Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64518 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbbAWLwe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 06:52:34 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Seth Forshee <seth.forshee@canonical.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless-regdb: Add regulatory rules for Samoa (WS)
Date: Fri, 23 Jan 2015 13:51:59 +0200
Message-ID: <1422013920-9779-2-git-send-email-jouni@qca.qualcomm.com> (sfid-20150123_125237_750105_412BB21F)
In-Reply-To: <1422013920-9779-1-git-send-email-jouni@qca.qualcomm.com>
References: <1422013920-9779-1-git-send-email-jouni@qca.qualcomm.com>
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
index 85b4bb4..cfd81bf 100644
--- a/db.txt
+++ b/db.txt
@@ -1201,6 +1201,12 @@ country WF: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
 
+country WS: DFS-ETSI
+	(2402 - 2482 @ 40), (20)
+	(5170 - 5250 @ 40), (20)
+	(5250 - 5330 @ 40), (20), DFS
+	(5490 - 5710 @ 40), (27), DFS
+
 country YE:
 	(2402 - 2482 @ 40), (20)
 
-- 
1.9.1


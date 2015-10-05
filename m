Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:65041 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbbJETNC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 15:13:02 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Seth Forshee <seth.forshee@canonical.com>
CC: <wireless-regdb@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 4/5] wireless-regdb: Add VHT channel bandwidth for Ukraine (UA)
Date: Mon, 5 Oct 2015 22:12:00 +0300
Message-ID: <1444072321-20728-4-git-send-email-jouni@qca.qualcomm.com> (sfid-20151005_211306_586917_9C94C662)
In-Reply-To: <1444072321-20728-1-git-send-email-jouni@qca.qualcomm.com>
References: <1444072321-20728-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source is QCA's regulatory team's efforts.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index 93242ec..7917263 100644
--- a/db.txt
+++ b/db.txt
@@ -1138,8 +1138,9 @@ country TZ:
 # disputable definitions there.
 country UA: DFS-ETSI
 	(2400 - 2483.5 @ 40), (20), NO-OUTDOOR
-	(5150 - 5350 @ 40), (20), NO-OUTDOOR
-	(5490 - 5670 @ 80), (20), DFS
+	(5150 - 5250 @ 80), (20), NO-OUTDOOR, AUTO-BW
+	(5250 - 5350 @ 80), (20), DFS, NO-OUTDOOR, AUTO-BW
+	(5490 - 5670 @ 160), (20), DFS
 	(5735 - 5835 @ 80), (20)
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
-- 
1.9.1


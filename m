Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:41221 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaANR3v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 12:29:51 -0500
Received: by mail-ee0-f45.google.com with SMTP id b15so291699eek.32
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jan 2014 09:29:49 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [RFC 5/5] cfg80211: setup CAC time in db.txt for PL
Date: Tue, 14 Jan 2014 18:29:30 +0100
Message-Id: <1389720570-2430-6-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140114_182957_005327_9C290031)
In-Reply-To: <1389720570-2430-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1389720570-2430-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is DFS CAC time setup for PL.
We should do the same for all other
countries that support DFS in wireless-regd.
Here only as example, please don't merge.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/wireless/db.txt |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/db.txt b/net/wireless/db.txt
index 811eb5c..f3813a2 100644
--- a/net/wireless/db.txt
+++ b/net/wireless/db.txt
@@ -632,8 +632,10 @@ country PK:
 country PL: DFS-ETSI
 	(2402 - 2482 @ 40), (N/A, 20)
 	(5170 - 5250 @ 80), (N/A, 20)
-	(5250 - 5330 @ 80), (N/A, 20), DFS
-	(5490 - 5710 @ 80), (N/A, 27), DFS
+	(5250 - 5330 @ 80), (N/A, 20), (60), DFS
+	(5490 - 5590 @ 80), (N/A, 27), (60), DFS
+	(5590 - 5650 @ 80), (N/A, 27), (600), DFS
+	(5650 - 5710 @ 80), (N/A, 27), (60), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (N/A, 40), NO-OUTDOOR
 
-- 
1.7.9.5


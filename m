Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:59786 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3KAODh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 10:03:37 -0400
Received: by mail-wg0-f46.google.com with SMTP id m15so4079481wgh.25
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 07:03:36 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 02/23] wireless-regdb: update CA's 5 GHz rules
Date: Fri,  1 Nov 2013 15:02:57 +0100
Message-Id: <1383314598-21240-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20131101_150340_582690_4F9C81BB)
In-Reply-To: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383314598-21240-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This increases the 2.4 GHz max EIRP from 27 dBm
to 30 dBm, and extends the 5 GHz DFS range.

Source is QCA's regulatory team's efforts.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index 3c03886..16c4865 100644
--- a/db.txt
+++ b/db.txt
@@ -148,10 +148,10 @@ country BZ: DFS-JP
 	(5735 - 5835 @ 80), (30)
 
 country CA: DFS-FCC
-	(2402 - 2472 @ 40), (27)
+	(2402 - 2472 @ 40), (30)
 	(5170 - 5250 @ 80), (17)
 	(5250 - 5330 @ 80), (24), DFS
-	(5490 - 5710 @ 80), (24), DFS
+	(5490 - 5730 @ 80), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
 country CH: DFS-ETSI
-- 
1.8.4.rc3


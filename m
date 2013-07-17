Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:34450 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab3GQCTO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 22:19:14 -0400
Received: by mail-pb0-f52.google.com with SMTP id xa12so1338102pbc.25
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jul 2013 19:19:13 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 05/53] wireless-regdb: NZ, New Zealand - enable VHT80
Date: Tue, 16 Jul 2013 19:17:54 -0700
Message-Id: <1374027522-18488-6-git-send-email-mcgrof@do-not-panic.com> (sfid-20130717_041917_754315_CA1042D2)
In-Reply-To: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
References: <1374027522-18488-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This enables 80 MHz bandwidth usage on all 5 GHz
frequencies and increases the max EIRP on two
5 GHz bands, decreases the max EIRP on the first
5 GHz band and adds a new band 5490 - 5710 MHz.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/db.txt b/db.txt
index bb846af..1f16aff 100644
--- a/db.txt
+++ b/db.txt
@@ -574,9 +574,10 @@ country NP:
 
 country NZ:
 	(2402 - 2482 @ 40), (N/A, 30)
-	(5170 - 5250 @ 20), (3, 23)
-	(5250 - 5330 @ 20), (3, 23), DFS
-	(5735 - 5835 @ 20), (3, 30)
+	(5170 - 5250 @ 80), (3, 17)
+	(5250 - 5330 @ 80), (3, 24), DFS
+	(5490 - 5710 @ 80), (3, 24), DFS
+	(5735 - 5835 @ 80), (3, 30)
 
 country OM:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.7.10.4


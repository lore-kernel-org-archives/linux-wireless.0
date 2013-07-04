Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:62677 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab3GDBFR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 21:05:17 -0400
Received: by mail-pa0-f43.google.com with SMTP id hz11so770873pad.2
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 18:05:16 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 05/53] wireless-regdb: NZ, New Zealand - enable VHT80
Date: Wed,  3 Jul 2013 18:04:01 -0700
Message-Id: <1372899889-19183-6-git-send-email-mcgrof@do-not-panic.com> (sfid-20130704_030532_190026_77EE0C95)
In-Reply-To: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
References: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
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


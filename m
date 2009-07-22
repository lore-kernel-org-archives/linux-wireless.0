Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45503 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493AbZGVRvu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2009 13:51:50 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2009 10:51:51 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<sfalpha@gmail.com>, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Michael Green <michael.green@atheros.com>,
	David Quan <david.quan@atheros.com>
Subject: [PATCH] wireless-regdb: TH gets 5 GHz enabled as of new regulatory rules
Date: Wed, 22 Jul 2009 10:51:48 -0700
Message-ID: <1248285108-10059-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Phattanon Duangdara reported the National Telecommunication
Commisions of Thailand has announced new regulatory rules
about 5GHz for RLAN last year.

I have verified this matches our documentation internally
at Atheros.

Reference in Thai Language:
http://www.ratchakitcha.soc.go.th/DATA/PDF/2551/E/042/64.PDF

Cc: Michael Green <michael.green@atheros.com>
Cc: David Quan <david.quan@atheros.com>
Reported-by: Phattanon Duangdara <sfalpha@gmail.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 db.txt |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/db.txt b/db.txt
index fad098d..01536d6 100644
--- a/db.txt
+++ b/db.txt
@@ -534,7 +534,11 @@ country TW:
 	(5735 - 5815 @ 40), (3, 30)
 
 country TH:
-	(2402 - 2482 @ 40), (N/A, 20)
+	(2402 - 2482 @ 20), (N/A, 20)
+	(5170 - 5250 @ 20), (3, 17)
+	(5250 - 5330 @ 20), (3, 20), DFS
+	(5490 - 5710 @ 20), (3, 20), DFS
+	(5735 - 5835 @ 20), (3, 30)
 
 country TT:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.6.3.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21820 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687AbZIASUy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 14:20:54 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 11:20:57 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Michael Green <michael.green@atheros.com>,
	David Quan <david.quan@atheros.com>
Subject: [PATCH v2] wireless-regdb: TH gets 5 GHz enabled as of new regulatory rules
Date: Tue, 1 Sep 2009 11:20:56 -0700
Message-ID: <1251829256-4895-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Phattanon Duangdara reported the National Telecommunication
Commisions of Thailand has announced new regulatory rules
about 5GHz for RLAN last year.

I have verified this matches our documentation internally
at Atheros. I also verified HT40 is allowed.

Reference in Thai Language:
http://www.ratchakitcha.soc.go.th/DATA/PDF/2551/E/042/64.PDF

Cc: Michael Green <michael.green@atheros.com>
Cc: David Quan <david.quan@atheros.com>
Reported-by: Phattanon Duangdara <sfalpha@gmail.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

John, this is v2, I have verified internally TH does allow for HT40.

 db.txt |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/db.txt b/db.txt
index fad098d..84be443 100644
--- a/db.txt
+++ b/db.txt
@@ -535,6 +535,10 @@ country TW:
 
 country TH:
 	(2402 - 2482 @ 40), (N/A, 20)
+	(5170 - 5250 @ 40), (3, 17)
+	(5250 - 5330 @ 40), (3, 20), DFS
+	(5490 - 5710 @ 40), (3, 20), DFS
+	(5735 - 5835 @ 40), (3, 30)
 
 country TT:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.6.3.3


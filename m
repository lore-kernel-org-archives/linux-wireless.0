Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:56459 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbZAHXcZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 18:32:25 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2009 15:32:25 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] JP: Disable OFDM on channel 14
Date: Thu, 8 Jan 2009 15:32:01 -0800
Message-ID: <1231457521-22531-1-git-send-email-lrodriguez@atheros.com> (sfid-20090109_003229_804320_B9613DA3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only 802.11b is allowed on channel 14. This applies
to the entire world and currently it is only allowed
in JP.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 db.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/db.txt b/db.txt
index 6a282b6..1ab81f0 100644
--- a/db.txt
+++ b/db.txt
@@ -293,7 +293,7 @@ country JM:
 country JP:
 	(2402 - 2472 @ 40), (N/A, 20)
 	(2457 - 2482 @ 40), (N/A, 20)
-	(2474 - 2494 @ 40), (N/A, 20)
+	(2474 - 2494 @ 40), (N/A, 20), NO-OFDM
 	(4910 - 4930 @ 10), (N/A, 23)
 	(4910 - 4990 @ 40), (N/A, 23)
 	(4930 - 4950 @ 10), (N/A, 23)
-- 
1.6.1.rc3.51.g5832d


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:20897 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbZBUFdH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 00:33:07 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2009 21:33:07 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] wireless-regdb: enable 5 GHz world roaming
Date: Fri, 20 Feb 2009 21:32:20 -0800
Message-ID: <1235194340-21355-1-git-send-email-lrodriguez@atheros.com> (sfid-20090221_063319_380627_2547BC3F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 db.txt |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/db.txt b/db.txt
index 89a9d52..3de2c9b 100644
--- a/db.txt
+++ b/db.txt
@@ -1,5 +1,6 @@
 country 00:
 	(2402 - 2472 @ 40), (3, 20)
+	(5170 - 5250 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
 
 country AE:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.6.1.2.253.ga34a


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40963 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZCWXRO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 19:17:14 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Michael.Green@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/2] wireless-regdb: KR few reg updates
Date: Mon, 23 Mar 2009 19:17:12 -0400
Message-Id: <1237850232-24513-2-git-send-email-lrodriguez@atheros.com> (sfid-20090324_001719_100264_303C5A89)
In-Reply-To: <1237850232-24513-1-git-send-email-lrodriguez@atheros.com>
References: <1237850232-24513-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Korea (KR) allows the usage a channel with center of
freq on 5260 MHz. It also specifically disables these
channels though:

128 - 5640 MHz
132 - 5660 MHz
136 - 5680 MHz
140 - 5700 MHz

We refered to the Korean rules regulations, the doc is in
Korean and I am not sure if I can post it but just in case
Atheros refers to this doc internally as "MIC 2007-80 20071017".

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 db.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index 77f1754..6f29be9 100644
--- a/db.txt
+++ b/db.txt
@@ -334,8 +334,8 @@ country KP:
 country KR:
 	(2402 - 2482 @ 20), (N/A, 20)
 	(5170 - 5250 @ 20), (3, 20)
-	(5260 - 5330 @ 20), (3, 20), DFS
-	(5490 - 5710 @ 20), (3, 30), DFS
+	(5250 - 5330 @ 20), (3, 20), DFS
+	(5490 - 5630 @ 20), (3, 30), DFS
 	(5735 - 5815 @ 20), (3, 30)
 
 country KW:
-- 
1.6.0.6


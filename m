Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33305 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbZC0EU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 00:20:59 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, pabs@debian.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/4] wireless-regdb: KR few reg updates
Date: Fri, 27 Mar 2009 00:20:54 -0400
Message-Id: <1238127656-1226-3-git-send-email-lrodriguez@atheros.com> (sfid-20090327_052114_653536_C3DBD87E)
In-Reply-To: <1238127656-1226-1-git-send-email-lrodriguez@atheros.com>
References: <1238127656-1226-1-git-send-email-lrodriguez@atheros.com>
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


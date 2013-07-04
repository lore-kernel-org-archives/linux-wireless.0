Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:48674 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933393Ab3GDBIJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 21:08:09 -0400
Received: by mail-pb0-f47.google.com with SMTP id rr13so668967pbb.6
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 18:08:08 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 44/53] wireless-regdb: KW, Kuwait - enable VHT80
Date: Wed,  3 Jul 2013 18:04:40 -0700
Message-Id: <1372899889-19183-45-git-send-email-mcgrof@do-not-panic.com> (sfid-20130704_032042_591797_B1BD22B5)
In-Reply-To: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
References: <1372899889-19183-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This enables 80 MHz bandwidth usage on 5 GHz.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index a4d0587..16d9f8c 100644
--- a/db.txt
+++ b/db.txt
@@ -469,8 +469,8 @@ country KR:
 
 country KW:
 	(2402 - 2482 @ 40), (N/A, 20)
-	(5170 - 5250 @ 40), (N/A, 20)
-	(5250 - 5330 @ 40), (N/A, 20), DFS
+	(5170 - 5250 @ 80), (N/A, 20)
+	(5250 - 5330 @ 80), (N/A, 20), DFS
 
 country KZ:
 	(2402 - 2482 @ 40), (N/A, 20)
-- 
1.7.10.4


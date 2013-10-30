Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55144 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab3J3Vpa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 17:45:30 -0400
Received: by mail-wi0-f181.google.com with SMTP id ex4so2131334wid.8
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 14:45:29 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 7/7] wireless-regdb: optimize two of NL's rules
Date: Wed, 30 Oct 2013 22:45:09 +0100
Message-Id: <1383169509-22619-8-git-send-email-mcgrof@do-not-panic.com> (sfid-20131030_224535_437033_15232E1F)
In-Reply-To: <1383169509-22619-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383169509-22619-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no reason not to merge these two rules.
This as picked up by the new CRDA optimizer.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index efd9902..429a380 100644
--- a/db.txt
+++ b/db.txt
@@ -557,8 +557,7 @@ country MX: DFS-FCC
 
 country NL: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), NO-OUTDOOR
-	(5250 - 5330 @ 80), (20), NO-OUTDOOR
+	(5170 - 5330 @ 80), (20), NO-OUTDOOR
 	(5490 - 5710 @ 80), (27), DFS
 	# 60 gHz band channels 1-4, ref: Etsi En 302 567
 	(57240 - 65880 @ 2160), (40), NO-OUTDOOR
-- 
1.8.4.rc3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:34141 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbbIPOWg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 10:22:36 -0400
Received: by iofb144 with SMTP id b144so232676046iof.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2015 07:22:35 -0700 (PDT)
From: Seth Forshee <seth.forshee@canonical.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Atul Joshi <atul.suresh.joshi@gmail.com>
Subject: [PATCH] wireless-regdb: Add ETSI as the DFS region for Hong Kong
Date: Wed, 16 Sep 2015 09:22:00 -0500
Message-Id: <1442413320-69656-1-git-send-email-seth.forshee@canonical.com> (sfid-20150916_162239_043572_0202EF3F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on [1], Hong Kong follows ETSI requirements for DFS.

[1] http://www.ofca.gov.hk/filemanager/ofca/en/content_401/hkta1039.pdf

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 db.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index 982db34..d57ea84 100644
--- a/db.txt
+++ b/db.txt
@@ -490,7 +490,7 @@ country GY:
 	(2402 - 2482 @ 40), (30)
 	(5735 - 5835 @ 80), (30)
 
-country HK:
+country HK: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (17), AUTO-BW
 	(5250 - 5330 @ 80), (24), DFS, AUTO-BW
-- 
1.9.1


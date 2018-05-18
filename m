Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:60072 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbeEROqo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 10:46:44 -0400
Received: from mail-io0-f199.google.com ([209.85.223.199])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1fJgeZ-0006SE-Im
        for linux-wireless@vger.kernel.org; Fri, 18 May 2018 14:46:43 +0000
Received: by mail-io0-f199.google.com with SMTP id r140-v6so5236374iod.16
        for <linux-wireless@vger.kernel.org>; Fri, 18 May 2018 07:46:43 -0700 (PDT)
From: Seth Forshee <seth.forshee@canonical.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Michael Chen <michaelchentejada@gmail.com>
Subject: [PATCH] wireless-regdb: Update rules for Panama (PA) and add 60 GHz rule
Date: Fri, 18 May 2018 09:46:41 -0500
Message-Id: <20180518144641.24995-1-seth.forshee@canonical.com> (sfid-20180518_164648_376937_09B97BA8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Updates are based on the information in
http://www.asep.gob.pa/images/telecomunicaciones/Anexos/PNAF-dic2015.pdf.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 db.txt | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index ed461a35b770..e3bbd374d096 100644
--- a/db.txt
+++ b/db.txt
@@ -963,11 +963,15 @@ country OM: DFS-ETSI
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
 	(5490 - 5710 @ 160), (27), DFS
 
+# Source:
+# http://www.asep.gob.pa/images/telecomunicaciones/Anexos/PNAF-dic2015.pdf
 country PA: DFS-FCC
-	(2402 - 2472 @ 40), (30)
-	(5170 - 5250 @ 80), (17), AUTO-BW
-	(5250 - 5330 @ 80), (23), DFS, AUTO-BW
-	(5735 - 5835 @ 80), (30)
+	(2400 - 2483.5 @ 40), (36)
+	(5150 - 5250 @ 80), (36), AUTO-BW
+	(5250 - 5350 @ 80), (30), AUTO-BW
+	(5470 - 5725 @ 160), (30)
+	(5725 - 5850 @ 80), (36)
+	(57000 - 64000 @ 2160), (43)
 
 country PE: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-- 
2.17.0

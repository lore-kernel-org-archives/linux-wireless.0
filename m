Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37284 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbbHKNaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2015 09:30:19 -0400
Received: by wibhh20 with SMTP id hh20so195910615wib.0
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2015 06:30:18 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: [PATCH] wireless-regdb: add 2.4GHz regulatory rules for Cuba (CU)
Date: Tue, 11 Aug 2015 15:29:55 +0200
Message-Id: <1439299795-17359-1-git-send-email-xose.vazquez@gmail.com> (sfid-20150811_153023_450592_90C933A9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Resolución 127, 2011 - Reglamento Banda 2,4 GHz.:
http://www.mincom.gob.cu/sites/default/files/marcoregulatorio/R%20127-11%20Reglamento%20banda%202,4%20GHz.pdf

Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 db.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/db.txt b/db.txt
index 982db34..2edbf90 100644
--- a/db.txt
+++ b/db.txt
@@ -275,6 +275,13 @@ country CR: DFS-FCC
 	(5490 - 5730 @ 20), (24), DFS
 	(5735 - 5835 @ 20), (30)
 
+# http://www.mincom.gob.cu/?q=marcoregulatorio
+# - Redes Informáticas
+# Resolución 127, 2011 - Reglamento Banda 2,4 GHz.
+country CU: DFS-FCC
+	(2400 - 2456 @ 40), (200 mW)
+	(2456 - 2483.5 @ 40), (200 mW)
+
 country CX: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (24), AUTO-BW
-- 
2.4.3

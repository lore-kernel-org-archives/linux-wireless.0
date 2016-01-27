Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36202 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbcA0J5O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 04:57:14 -0500
Received: by mail-wm0-f66.google.com with SMTP id l65so2292079wmf.3
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jan 2016 01:57:14 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: [PATCH v2] wireless-regdb: add 2.4GHz regulatory rules for Cuba (CU)
Date: Wed, 27 Jan 2016 10:56:33 +0100
Message-Id: <1453888593-7705-1-git-send-email-xose.vazquez@gmail.com> (sfid-20160127_105723_995323_E9A61A53)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
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
 db.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/db.txt b/db.txt
index 13cc7ad..e9ba21a 100644
--- a/db.txt
+++ b/db.txt
@@ -275,6 +275,12 @@ country CR: DFS-FCC
 	(5490 - 5730 @ 20), (24), DFS
 	(5735 - 5835 @ 20), (30)
 
+# http://www.mincom.gob.cu/?q=marcoregulatorio
+# - Redes Informáticas
+# Resolución 127, 2011 - Reglamento Banda 2,4 GHz.
+country CU: DFS-FCC
+	(2400 - 2483.5 @ 40), (200 mW)
+
 country CX: DFS-FCC
 	(2402 - 2482 @ 40), (20)
 	(5170 - 5250 @ 80), (24), AUTO-BW
-- 
2.5.0


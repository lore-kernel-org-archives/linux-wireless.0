Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:38238 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbdJONql (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 15 Oct 2017 09:46:41 -0400
Received: by mail-wm0-f65.google.com with SMTP id q124so5772841wmb.5
        for <linux-wireless@vger.kernel.org>; Sun, 15 Oct 2017 06:46:41 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: [PATCH] wireless-regdb: add Short Range Devices (SRD) (ETSI EN 300 440) for Spain
Date: Sun, 15 Oct 2017 15:46:37 +0200
Message-Id: <20171015134637.2760-1-xose.vazquez@gmail.com> (sfid-20171015_154827_706859_0050AC81)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

UN - 130 Dispositivos de corto alcance en 5 GHz :
https://www.boe.es/buscar/act.php?id=BOE-A-2013-4845&tn=1&p=20150410

Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

---
 db.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/db.txt b/db.txt
index e48f9a6..1509491 100644
--- a/db.txt
+++ b/db.txt
@@ -431,6 +431,8 @@ country ES: DFS-ETSI
 	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR, AUTO-BW
 	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW
 	(5470 - 5725 @ 160), (500 mW), DFS
+	# Short Range Devices (SRD) (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (25 mW)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
-- 
2.14.2

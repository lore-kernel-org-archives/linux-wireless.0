Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43030 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727623AbeIGVKZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Sep 2018 17:10:25 -0400
Received: by mail-wr1-f66.google.com with SMTP id k5-v6so15540834wre.10
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2018 09:28:44 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        WIRELESS ML <linux-wireless@vger.kernel.org>,
        REGDB ML <wireless-regdb@lists.infradead.org>
Subject: [PATCH] wireless-regdb: update source of info for CU and ES
Date: Fri,  7 Sep 2018 18:28:41 +0200
Message-Id: <20180907162841.11749-1-xose.vazquez@gmail.com> (sfid-20180907_182847_455452_0B23B0B0)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: WIRELESS ML <linux-wireless@vger.kernel.org>
Cc: REGDB ML <wireless-regdb@lists.infradead.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 db.txt | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/db.txt b/db.txt
index b168f59..54479fc 100644
--- a/db.txt
+++ b/db.txt
@@ -311,9 +311,10 @@ country CR: DFS-FCC
 	(5490 - 5730 @ 20), (24), DFS
 	(5735 - 5835 @ 20), (30)
 
+# Source:
 # http://www.mincom.gob.cu/?q=marcoregulatorio
 # - Redes Informáticas
-# Resolución 127, 2011 - Reglamento Banda 2,4 GHz.
+# Resolución 127- 2011 Reglamento de Banda de frecuencias de 2,4 GHz.
 country CU: DFS-FCC
 	(2400 - 2483.5 @ 40), (200 mW)
 
@@ -432,13 +433,9 @@ country EG: DFS-ETSI
 	(5170 - 5250 @ 40), (20)
 	(5250 - 5330 @ 40), (20), DFS
 
-# Orden IET/787/2013, de 25 de abril, por la que se aprueba
-# el cuadro nacional de atribución de frecuencias.
-# http://www.boe.es/diario_boe/txt.php?id=BOE-A-2013-4845
-#
-# more info at "Cuadro nacional de atribución de frecuencias (CNAF)":
-# http://www.minetur.gob.es/telecomunicaciones/espectro/paginas/cnaf.aspx
-
+# Source:
+# Cuadro nacional de atribución de frecuencias (CNAF)
+# http://www.mincotur.gob.es/telecomunicaciones/espectro/paginas/cnaf.aspx
 country ES: DFS-ETSI
 	(2400 - 2483.5 @ 40), (100 mW)
 	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR, AUTO-BW, wmmrule=ETSI
-- 
2.17.1

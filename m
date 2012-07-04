Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60732 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab2GDVFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 17:05:22 -0400
Received: by wibhm11 with SMTP id hm11so5913866wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jul 2012 14:05:21 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: mcgrof@frijolero.org, linville@tuxdriver.com,
	wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	xose.vazquez@gmail.com
Subject: [PATCH 3/3] wireless-regdb: Update regulatory rules for ES (Spain) on 5GHz and 2.4GHz
Date: Wed,  4 Jul 2012 23:05:07 +0200
Message-Id: <1341435907-3787-3-git-send-email-xose.vazquez@gmail.com> (sfid-20120704_230528_220504_BA2E473C)
In-Reply-To: <1341435907-3787-1-git-send-email-xose.vazquez@gmail.com>
References: <1341435907-3787-1-git-send-email-xose.vazquez@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- add NO-OUTDOOR to 5150-5250 and 5250-5350

Spanish law was based on CEPT/EU rules:
http://lists.infradead.org/pipermail/wireless-regdb/2012-June/000058.html
http://lists.infradead.org/pipermail/wireless-regdb/2012-June/000059.html

Orden ITC/332/2010, de 12 de febrero, por la que se aprueba el cuadro
nacional de atribución de frecuencias (CNAF):
https://www.boe.es/diario_boe/txt.php?id=BOE-A-2010-2719
https://www.boe.es/boe/dias/2010/02/19/pdfs/BOE-A-2010-2719.pdf

search for:
 UN - 85 RLANs y datos en 2400 a 2483,5 MHz (pag. 213)
 UN - 128 RLANs en 5 GHz (pag. 232)

more info at "Cuadro nacional de atribución de frecuencias (CNAF)":
http://www.minetur.gob.es/telecomunicaciones/espectro/paginas/cnaf.aspx

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 db.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index cea63bd..11409d6 100644
--- a/db.txt
+++ b/db.txt
@@ -240,8 +240,8 @@ country EG:
 
 country ES: DFS-ETSI
 	(2400 - 2483.5 @ 40), (N/A, 100 mW)
-	(5150 - 5250 @ 40), (N/A, 100 mW)
-	(5250 - 5350 @ 40), (N/A, 100 mW), DFS
+	(5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
+	(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
 	(5470 - 5725 @ 40), (N/A, 500 mW), DFS
 
 country FI: DFS-ETSI
-- 
1.7.10.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33516 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728372AbeIQNJG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Sep 2018 09:09:06 -0400
Received: by mail-qk1-f195.google.com with SMTP id z78-v6so8534475qka.0
        for <linux-wireless@vger.kernel.org>; Mon, 17 Sep 2018 00:42:55 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: seth.forshee@canonical.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
        Simon Wunderlich <simon.wunderlich@openmesh.com>,
        Shashidhar Lakkavalli <shashidhar.lakkavalli@openmesh.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 2/2] wireless-regdb: Sync DE with ETSI EN 301 893 V2.1.1 (2017-05)
Date: Mon, 17 Sep 2018 09:42:12 +0200
Message-Id: <20180917074212.6739-2-sven.eckelmann@openmesh.com> (sfid-20180917_094258_073436_3A2C2FB6)
In-Reply-To: <20180917074212.6739-1-sven.eckelmann@openmesh.com>
References: <20180917074212.6739-1-sven.eckelmann@openmesh.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The documents
https://www.etsi.org/deliver/etsi_en/301800_301899/301893/02.01.01_60/en_301893v020101p.pdf
and
https://www.bundesnetzagentur.de/SharedDocs/Downloads/DE/Sachgebiete/Telekommunikation/Unternehmen_Institutionen/Frequenzen/Allgemeinzuteilungen/2010_07_WLAN_5GHz_pdf.pdf
show that the limits for the 5GHz bands are out of date:

* 5150 - 5250 MHz only usage is allowed to use up to 23 dBm (200 mW) even
  without TPC

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 db.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index 7f978e1..f406ac0 100644
--- a/db.txt
+++ b/db.txt
@@ -379,7 +379,7 @@ country CZ: DFS-ETSI
 country DE: DFS-ETSI
 	(2400 - 2483.5 @ 40), (100 mW)
 	(5150 - 5250 @ 80), (100 mW), NO-OUTDOOR, AUTO-BW, wmmrule=ETSI
-	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=ETSI
+	(5250 - 5350 @ 80), (200 mW), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=ETSI
 	(5470 - 5725 @ 160), (500 mW), DFS, wmmrule=ETSI
 	# short range devices (ETSI EN 300 440-1)
 	(5725 - 5875 @ 80), (25 mW)
-- 
2.11.0

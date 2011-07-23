Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:38846 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab1GWIbd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 04:31:33 -0400
Received: by mail-fx0-f52.google.com with SMTP id 18so6327489fxd.11
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jul 2011 01:31:33 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] bcma: use boardflags define from ssb code
Date: Sat, 23 Jul 2011 11:10:12 +0200
Message-Id: <1311412213-3825-3-git-send-email-zajec5@gmail.com> (sfid-20110723_103136_244634_CD64E26F)
In-Reply-To: <1311412213-3825-1-git-send-email-zajec5@gmail.com>
References: <1311412213-3825-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index dc6f34a..bdf933b 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -172,7 +172,7 @@ static bool bcma_core_pci_is_in_hostmode(struct bcma_drv_pci *pc)
 	    chipid_top != 0x5300)
 		return false;
 
-	if (bus->sprom.boardflags_lo & SSB_PCICORE_BFL_NOPCI)
+	if (bus->sprom.boardflags_lo & SSB_BFL_NOPCI)
 		return false;
 
 #if 0
-- 
1.7.3.4


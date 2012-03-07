Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34795 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab2CGIII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 03:08:08 -0500
Received: by eekc41 with SMTP id c41so2196931eek.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Mar 2012 00:08:06 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: lina.lastname@gmail.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: silence PMU warning for BCM4331
Date: Wed,  7 Mar 2012 09:11:22 +0100
Message-Id: <1331107882-14824-1-git-send-email-zajec5@gmail.com> (sfid-20120307_090811_945464_404107DD)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_chipcommon_pmu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 800163c..a058842 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -80,6 +80,7 @@ static void bcma_pmu_resources_init(struct bcma_drv_cc *cc)
 		min_msk = 0x200D;
 		max_msk = 0xFFFF;
 		break;
+	case 0x4331:
 	case 43224:
 	case 43225:
 		break;
-- 
1.7.7


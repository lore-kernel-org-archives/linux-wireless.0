Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:34303 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751402AbdKZQGH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 26 Nov 2017 11:06:07 -0500
From: Ashish Kalra <eashishkalra@gmail.com>
To: zajec5@gmail.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        eashishkalra@gmail.com
Subject: [PATCH] Removed Warning shown in checkpatch.pl for comment and white space
Date: Sun, 26 Nov 2017 21:35:50 +0530
Message-Id: <20171126160550.3746-1-eashishkalra@gmail.com> (sfid-20171126_170622_812610_D4E6E58F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

checkpatch.pl was showing warnings due to incorrected space at the end
of line and also not using * at start of second comment line, Corrected
the same and now there is zero warning

Signed-off-by: Ashish Kalra <eashishkalra@gmail.com>
---
 drivers/bcma/driver_pcie2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bcma/driver_pcie2.c b/drivers/bcma/driver_pcie2.c
index b1a6e327cb23..cf889fc62ac7 100644
--- a/drivers/bcma/driver_pcie2.c
+++ b/drivers/bcma/driver_pcie2.c
@@ -83,7 +83,8 @@ static void bcma_core_pcie2_hw_ltr_war(struct bcma_drv_pcie2 *pcie2)
 		bcma_core_pcie2_set_ltr_vals(pcie2);
 
 		/* TODO:
-		si_core_wrapperreg(pcie2, 3, 0x60, 0x8080, 0); */
+		 *si_core_wrapperreg(pcie2, 3, 0x60, 0x8080, 0);
+		 */
 
 		/* enable the LTR */
 		devstsctr2 |= PCIE2_CAP_DEVSTSCTRL2_LTRENAB;
-- 
2.14.1

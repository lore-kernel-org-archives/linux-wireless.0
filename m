Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:39650 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751924AbdK1CMK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Nov 2017 21:12:10 -0500
From: Ashish Kalra <eashishkalra@gmail.com>
To: morganfreeman6991@gmail.com
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ashish Kalra <eashishkalra@gmail.com>
Subject: [PATCH v2] drivers: bcma: driver_pcie2.c: Comment format correction & moving trailing */ to a separate line  as per checkpatch
Date: Tue, 28 Nov 2017 07:41:42 +0530
Message-Id: <20171128021142.2793-1-eashishkalra@gmail.com> (sfid-20171128_031227_269466_72E85BD0)
In-Reply-To: <20171126172747.GA6512@himanshu-Vostro-3559>
References: <20171126172747.GA6512@himanshu-Vostro-3559>
In-Reply-To: <20171126172747.GA6512@himanshu-Vostro-3559>
References: <20171126172747.GA6512@himanshu-Vostro-3559>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the checkpatch.pl warning:

WARNING: Block comments use * on subsequent lines
+		/* TODO:
+		si_core_wrapperreg(pcie2, 3, 0x60, 0x8080, 0); */

WARNING: Block comments use a trailing */ on a separate line
+		si_core_wrapperreg(pcie2, 3, 0x60, 0x8080, 0); */

total: 0 errors, 2 warnings, 200 lines checked
Signed-off-by: Ashish Kalra <eashishkalra@gmail.com>
---
changes from v1 (https://lkml.org/lkml/2017/11/26/85)
v2: Improved commit message as per review from Morgan Freeman <morganfreeman6991@gmail.com>

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

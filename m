Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:40941 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753923AbdK1PzJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Nov 2017 10:55:09 -0500
From: Ashish Kalra <eashishkalra@gmail.com>
To: zajec5@gmail.com
Cc: himanshujha199640@gmail.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, eashishkalra@gmail.com
Subject: [PATCH v3] bcma:Adjust block comments
Date: Tue, 28 Nov 2017 21:24:58 +0530
Message-Id: <20171128155458.1036-1-eashishkalra@gmail.com> (sfid-20171128_165528_368685_1747FD3B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

use * for block comments in multiple lines according to kernel coding
style

Reported by: checkpatch.pl

Signed-off-by: Ashish Kalra <eashishkalra@gmail.com>
---
Change log:
        -v3: Improvement on  commit message as per review from Morgan Freeman <morganfreeman6991@gmail.com>
        -v2: Improvement on  commit message as per review from Morgan Freeman <morganfreeman6991@gmail.com>(https://lkml.org/lkml/2017/11/27/1259)
        -v1: https://lkml.org/lkml/2017/11/26/85

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

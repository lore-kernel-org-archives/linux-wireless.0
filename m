Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:59771 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751745AbdF3Kqo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Jun 2017 06:46:44 -0400
From: Colin King <colin.king@canonical.com>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: fix a typo: "incative" -> "inactive"
Date: Fri, 30 Jun 2017 11:46:40 +0100
Message-Id: <20170630104640.9985-1-colin.king@canonical.com> (sfid-20170630_124812_814514_43FDB511)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to typos in netdev_err error messages. I should have spotted
this in a previous round of spelling mistake checks on this driver but
this one slipped through.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f7c22d7b28d1..a3cdade02c93 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1963,7 +1963,7 @@ static s32 Handle_Get_InActiveTime(struct wilc_vif *vif,
 				      wilc_get_vif_idx(vif));
 
 	if (result) {
-		netdev_err(vif->ndev, "Failed to SET incative time\n");
+		netdev_err(vif->ndev, "Failed to SET inactive time\n");
 		return -EFAULT;
 	}
 
@@ -1976,7 +1976,7 @@ static s32 Handle_Get_InActiveTime(struct wilc_vif *vif,
 				      wilc_get_vif_idx(vif));
 
 	if (result) {
-		netdev_err(vif->ndev, "Failed to get incative time\n");
+		netdev_err(vif->ndev, "Failed to get inactive time\n");
 		return -EFAULT;
 	}
 
-- 
2.11.0

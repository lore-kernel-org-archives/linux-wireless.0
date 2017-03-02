Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34914 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753048AbdCBPqj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 10:46:39 -0500
From: Georgios Emmanouil <geo.emmnl@gmail.com>
To: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Staging:wilc1000:host_interface: Fixed alignment to match open parenthesis
Date: Thu,  2 Mar 2017 17:37:09 +0200
Message-Id: <1488469029-8918-1-git-send-email-geo.emmnl@gmail.com> (sfid-20170302_165323_577911_E6D9AB7F)
In-Reply-To: <1488468905-8686-1-git-send-email-geo.emmnl@gmail.com>
References: <1488468905-8686-1-git-send-email-geo.emmnl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed alignment to match open parenthesis.

Signed-off-by: Georgios Emmanouil <geo.emmnl@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 090fd43..bbe1a09 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1349,7 +1349,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,

 				if (u32RcvdAssocRespInfoLen != 0) {
 					s32Err = wilc_parse_assoc_resp_info(rcv_assoc_resp, u32RcvdAssocRespInfoLen,
-								    &pstrConnectRespInfo);
+									    &pstrConnectRespInfo);
 					if (s32Err) {
 						netdev_err(vif->ndev, "wilc_parse_assoc_resp_info() returned error %d\n", s32Err);
 					} else {
--
2.1.4

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:31999 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752419AbeEGIqa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 04:46:30 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 30/30] staging: wilc1000: rename s8idxarray to avoid datatype in variable name
Date: Mon, 7 May 2018 14:13:34 +0530
Message-ID: <1525682614-3824-31-git-send-email-ajay.kathat@microchip.com> (sfid-20180507_104901_668054_7EB7DA29)
In-Reply-To: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to have variable names as per linux coding style.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ad9270e..e27010c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1543,7 +1543,7 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 	struct wid wid;
 	struct wid wid_list[5];
 	u8 *key_buf;
-	s8 s8idxarray[1];
+	s8 idxarray[1];
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	switch (hif_key->type) {
@@ -1610,8 +1610,8 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 			wid.id = (u16)WID_REMOVE_WEP_KEY;
 			wid.type = WID_STR;
 
-			s8idxarray[0] = (s8)hif_key->attr.wep.index;
-			wid.val = s8idxarray;
+			idxarray[0] = (s8)hif_key->attr.wep.index;
+			wid.val = idxarray;
 			wid.size = 1;
 
 			result = wilc_send_config_pkt(vif, SET_CFG,
-- 
2.7.4

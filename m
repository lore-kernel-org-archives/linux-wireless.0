Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:30337 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752172AbeEGInx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 04:43:53 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 04/30] staging: wilc1000: fix line over 80 characters issue in handle_connect()
Date: Mon, 7 May 2018 14:13:08 +0530
Message-ID: <1525682614-3824-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180507_104356_576413_010E6B80)
In-Reply-To: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix line over 80 character issue found by checkpatch.pl script by
aligning the input argument in function call.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 29f9907..55a61d5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1117,10 +1117,8 @@ static s32 handle_connect(struct wilc_vif *vif,
 			}
 
 			conn_attr->result(CONN_DISCONN_EVENT_CONN_RESP,
-							       &conn_info,
-							       MAC_STATUS_DISCONNECTED,
-							       NULL,
-							       conn_attr->arg);
+					  &conn_info, MAC_STATUS_DISCONNECTED,
+					  NULL, conn_attr->arg);
 			hif_drv->hif_state = HOST_IF_IDLE;
 			kfree(conn_info.req_ies);
 			conn_info.req_ies = NULL;
-- 
2.7.4

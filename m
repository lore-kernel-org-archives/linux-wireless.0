Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:63357 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751100AbeEBHPl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 03:15:41 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 15/21] staging: wilc1000: remove unused macros in host_interface
Date: Wed, 2 May 2018 12:43:41 +0530
Message-ID: <1525245227-3924-16-git-send-email-ajay.kathat@microchip.com> (sfid-20180502_093237_508191_AC52E0C2)
In-Reply-To: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
References: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove the unused macro mentioned below. Also move
macro up along with other macro declaration.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6746e2f..52d3a2c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -58,6 +58,8 @@
 #define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
 #define DEFAULT_LINK_SPEED			72
 
+#define REAL_JOIN_REQ				0
+
 struct host_if_wpa_attr {
 	u8 *key;
 	const u8 *mac_addr;
@@ -248,10 +250,6 @@ static u8 get_ip[2][4];
 static u32 inactive_time;
 static u32 clients_count;
 
-#define REAL_JOIN_REQ 0
-#define FLUSHED_JOIN_REQ 1
-#define FLUSHED_BYTE_POS 79
-
 static void *host_int_parse_join_bss_param(struct network_info *info);
 static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
 static s32 handle_scan_done(struct wilc_vif *vif, enum scan_event evt);
-- 
2.7.4

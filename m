Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26873 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965235AbbJ2DDv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:03:51 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 36/64] staging: wilc1000: host_interface.h: move local define variables
Date: Thu, 29 Oct 2015 12:05:28 +0900
Message-ID: <1446087956-19054-3-git-send-email-glen.lee@atmel.com> (sfid-20151029_040354_673820_B6349408)
In-Reply-To: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
References: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch move local define variables to local define position.
 - ACTION
 - PROBE_REQ
 - PROBE_RESP
 - ACTION_FRM_IDX
 - PROBE_REQ_IDX

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.h | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 9595d48..2dfd7f0 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -10,8 +10,12 @@
 #define STATION_MODE	0x02
 #define GO_MODE		0x03
 #define CLIENT_MODE	0x04
+#define ACTION		0xD0
+#define PROBE_REQ	0x40
+#define PROBE_RESP	0x50
 
-
+#define ACTION_FRM_IDX				0
+#define PROBE_REQ_IDX				1
 #define MAX_NUM_STA				9
 #define ACTIVE_SCAN_TIME			10
 #define PASSIVE_SCAN_TIME			1200
@@ -249,14 +253,6 @@ struct reg_frame {
 	u8 reg_id;
 };
 
-
-#define ACTION			0xD0
-#define PROBE_REQ		0x40
-#define PROBE_RESP		0x50
-#define ACTION_FRM_IDX		0
-#define PROBE_REQ_IDX		1
-
-
 enum p2p_listen_state {
 	P2P_IDLE,
 	P2P_LISTEN,
-- 
1.9.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14010 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbbI3Js2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:48:28 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/32] staging: wilc1000: remove struct get_channel
Date: Wed, 30 Sep 2015 18:44:26 +0900
Message-ID: <1443606289-25407-9-git-send-email-tony.cho@atmel.com> (sfid-20150930_114830_907018_6991E90E)
In-Reply-To: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
References: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes struct get_channel from the driver because it is not
used anywhere.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 76e82e6..e715f54 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -232,20 +232,6 @@ struct set_channel {
 };
 
 /*!
- *  @struct             get_channel
- *  @brief		Get Channel  message body
- *  @details
- *  @todo
- *  @sa
- *  @author		Mai Daftedar
- *  @date		01 Jule 2012
- *  @version		1.0
- */
-struct get_channel {
-	u8 u8GetChan;
-};
-
-/*!
  *  @struct             tstrScanComplete
  *  @brief			hold received Async. Scan Complete message body
  *  @details
@@ -421,7 +407,6 @@ union message_body {
 	struct key_attr key_info;
 	struct cfg_param_attr cfg_info;
 	struct set_channel strHostIFSetChan;
-	struct get_channel strHostIFGetChan;
 	struct set_beacon strHostIFSetBeacon;
 	struct del_beacon strHostIFDelBeacon;
 	struct add_sta_param strAddStaParam;
-- 
1.9.1


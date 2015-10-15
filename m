Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:52939 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbbJOGrO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 02:47:14 -0400
Date: Thu, 15 Oct 2015 14:46:26 +0800
From: kbuild test robot <lkp@intel.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: kbuild-all@01.org, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, rachel.kim@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	austin.shin@atmel.com, adel.noureldin@atmel.com,
	adham.abozaeid@atmel.com, Nicolas.FERRE@atmel.com
Subject: [RFC PATCH] staging: wilc1000: scan_while_connected can be static
Message-ID: <20151015064626.GA25544@xian> (sfid-20151015_084716_769193_3CC6C2A0)
References: <201510151423.Em6KIJwk%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444883121-31757-19-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 host_interface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a09db2c..0e0d1db 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -251,7 +251,7 @@ u8 gau8MulticastMacAddrList[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 
 static u8 rcv_assoc_resp[MAX_ASSOC_RESP_FRAME_SIZE];
 
-bool scan_while_connected;
+static bool scan_while_connected;
 
 static s8 gs8Rssi;
 static s8 gs8lnkspd;

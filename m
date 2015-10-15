Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54755 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384AbbJOGdj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 02:33:39 -0400
Date: Thu, 15 Oct 2015 14:32:40 +0800
From: kbuild test robot <lkp@intel.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: kbuild-all@01.org, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, rachel.kim@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	austin.shin@atmel.com, adel.noureldin@atmel.com,
	adham.abozaeid@atmel.com, Nicolas.FERRE@atmel.com
Subject: [RFC PATCH] staging: wilc1000: periodic_rssi can be static
Message-ID: <20151015063240.GA19053@xian> (sfid-20151015_083342_605597_A70E139B)
References: <201510151441.f2r2iXEa%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444883121-31757-17-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 host_interface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3c1110c..b29d7b186 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -245,7 +245,7 @@ static struct semaphore hif_sema_thread;
 struct semaphore hif_sema_driver;
 static struct semaphore hif_sema_wait_response;
 struct semaphore hif_sema_deinit;
-struct timer_list periodic_rssi;
+static struct timer_list periodic_rssi;
 
 u8 gau8MulticastMacAddrList[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 

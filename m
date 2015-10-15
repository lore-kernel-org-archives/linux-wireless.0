Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:62104 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518AbbJOGXJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 02:23:09 -0400
Date: Thu, 15 Oct 2015 14:21:32 +0800
From: kbuild test robot <lkp@intel.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: kbuild-all@01.org, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, rachel.kim@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	austin.shin@atmel.com, adel.noureldin@atmel.com,
	adham.abozaeid@atmel.com, Nicolas.FERRE@atmel.com
Subject: [RFC PATCH] staging: wilc1000: hif_sema_deinit can be static
Message-ID: <20151015062132.GA90448@xian> (sfid-20151015_082313_779501_16261DF7)
References: <201510151431.u3oU2Yok%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444883121-31757-16-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 host_interface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index acb8379d..aa5c9d7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -244,7 +244,7 @@ static WILC_MsgQueueHandle hif_msg_q;
 static struct semaphore hif_sema_thread;
 struct semaphore hif_sema_driver;
 static struct semaphore hif_sema_wait_response;
-struct semaphore hif_sema_deinit;
+static struct semaphore hif_sema_deinit;
 struct timer_list g_hPeriodicRSSI;
 
 

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24007 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012AbbJOGIq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 02:08:46 -0400
Date: Thu, 15 Oct 2015 14:07:41 +0800
From: kbuild test robot <lkp@intel.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: kbuild-all@01.org, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: [RFC PATCH] staging: wilc1000: hif_sema_driver can be static
Message-ID: <20151015060741.GA126763@xian> (sfid-20151015_080852_319991_B31C3F5B)
References: <201510151403.R138Uuyp%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444883121-31757-14-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 host_interface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b4f8c3a..32c73b1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -242,7 +242,7 @@ u8 P2P_LISTEN_STATE;
 static struct task_struct *hif_thread_handler;
 static WILC_MsgQueueHandle hif_msg_q;
 static struct semaphore hif_sema_thread;
-struct semaphore hif_sema_driver;
+static struct semaphore hif_sema_driver;
 static struct semaphore hWaitResponse;
 struct semaphore hSemHostIntDeinit;
 struct timer_list g_hPeriodicRSSI;

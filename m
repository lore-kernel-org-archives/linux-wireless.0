Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:54830 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbbJOIAe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 04:00:34 -0400
Date: Thu, 15 Oct 2015 15:59:53 +0800
From: kbuild test robot <lkp@intel.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: kbuild-all@01.org, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: [RFC PATCH] staging: wilc1000: join_req_drv can be static
Message-ID: <20151015075953.GA108356@xian> (sfid-20151015_100037_548313_FC30B461)
References: <201510151529.AmFWEq5L%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444883121-31757-34-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 host_interface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 704419f..ca6f3983 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -267,7 +267,7 @@ u8 mode_11i;
 u8 auth_type;
 u32 join_req_size;
 u32 info_element_size;
-struct host_if_drv *join_req_drv;
+static struct host_if_drv *join_req_drv;
 #define REAL_JOIN_REQ 0
 #define FLUSHED_JOIN_REQ 1
 #define FLUSHED_BYTE_POS 79

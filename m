Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54755 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384AbbJOGdn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 02:33:43 -0400
Date: Thu, 15 Oct 2015 14:32:40 +0800
From: kbuild test robot <lkp@intel.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: kbuild-all@01.org, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, rachel.kim@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	austin.shin@atmel.com, adel.noureldin@atmel.com,
	adham.abozaeid@atmel.com, Nicolas.FERRE@atmel.com
Subject: Re: [PATCH 17/40] staging: wilc1000: rename variable g_hPeriodicRSSI
Message-ID: <201510151441.f2r2iXEa%fengguang.wu@intel.com> (sfid-20151015_083346_593026_347B0A12)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444883121-31757-17-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Leo,

[auto build test WARNING on staging/staging-next -- if it's inappropriate base, please suggest rules for selecting the more suitable base]

url:    https://github.com/0day-ci/linux/commits/Tony-Cho/staging-wilc1000-rename-ssidLen-of-struct-join_bss_param/20151015-123159
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/staging/wilc1000/host_interface.c:239:20: sparse: symbol 'terminated_handle' was not declared. Should it be static?
   drivers/staging/wilc1000/host_interface.c:241:4: sparse: symbol 'P2P_LISTEN_STATE' was not declared. Should it be static?
   drivers/staging/wilc1000/host_interface.c:245:18: sparse: symbol 'hif_sema_driver' was not declared. Should it be static?
   drivers/staging/wilc1000/host_interface.c:247:18: sparse: symbol 'hif_sema_deinit' was not declared. Should it be static?
>> drivers/staging/wilc1000/host_interface.c:248:19: sparse: symbol 'periodic_rssi' was not declared. Should it be static?
   drivers/staging/wilc1000/host_interface.c:254:6: sparse: symbol 'gbScanWhileConnected' was not declared. Should it be static?
   drivers/staging/wilc1000/host_interface.c:265:4: sparse: symbol 'gu8FlushedJoinReq' was not declared. Should it be static?
   drivers/staging/wilc1000/host_interface.c:266:4: sparse: symbol 'gu8FlushedInfoElemAsoc' was not declared. Should it be static?
   drivers/staging/wilc1000/host_interface.c:267:4: sparse: symbol 'gu8Flushed11iMode' was not declared. Should it be static?
   drivers/staging/wilc1000/host_interface.c:268:4: sparse: symbol 'gu8FlushedAuthType' was not declared. Should it be static?
   drivers/staging/wilc1000/host_interface.c:269:5: sparse: symbol 'gu32FlushedJoinReqSize' was not declared. Should it be static?
   drivers/staging/wilc1000/host_interface.c:270:5: sparse: symbol 'gu32FlushedInfoElemAsocSize' was not declared. Should it be static?
   drivers/staging/wilc1000/host_interface.c:408:5: sparse: symbol 'Handle_set_IPAddress' was not declared. Should it be static?
   drivers/staging/wilc1000/host_interface.c:443:5: sparse: symbol 'Handle_get_IPAddress' was not declared. Should it be static?
   drivers/staging/wilc1000/host_interface.c:2213:5: sparse: symbol 'Handle_GetStatistics' was not declared. Should it be static?
   drivers/staging/wilc1000/host_interface.c:2354:38: sparse: incompatible types for operation (>)
   drivers/staging/wilc1000/host_interface.c:2354:38:    left side has type unsigned char [usertype] *tail
   drivers/staging/wilc1000/host_interface.c:2354:38:    right side has type int

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

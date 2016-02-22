Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:29550 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbcBVEOp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Feb 2016 23:14:45 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V3 00/24] staging: wilc1000: Resend V3
Date: Mon, 22 Feb 2016 13:11:45 +0900
Message-ID: <1456114329-7036-1-git-send-email-leo.kim@atmel.com> (sfid-20160222_051449_176562_E0EC822D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Greg

This is the 3rd of the patch series about the other reason why V1 and V2.

V1 : first patch send.
After a little time has elapsed, received a error message from "kbuild test robot". 
===================================================
[auto build test WARNING on staging/staging-testing] [also build test WARNING on next-20160217] [cannot apply to v4.5-rc4] [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Leo-Kim/staging-wilc1000-wilc_wlan-c-removes-PRINT_ER/20160218-153737

coccinelle warnings: (new ones prefixed by >>)

>> drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:1153:6-35: alloc 
>> with no test, possible model on line 1158
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:1192:6-35: alloc with no test, possible model on line 1197
===================================================

I had think that this patch does not apply.
So, send V2 patch after fixed a error.

V2: fixed a build error from kbuild test robot
===================================================
staging: wilc1000: removes potential null dereference
===================================================

Please let me know if I mistake from a git patch process.
	     
Thank you and Best Regards.
Leo

Chris Park (19):
  staging: wilc1000: host_interface.c: removes unnecessary log message
  staging: wilc1000: linux_mon.c: removes unnecessary log message
  staging: wilc1000: linux_mon.c: removes comments
  staging: wilc1000: wilc_wfi_cfgoperations.c: removes unnecessary log
    messages
  staging: wilc1000: removes unused HOSTAPD_DBG tag
  staging: wilc1000: host_interface.c: removes unnecessary log messages
  staging: wilc1000: wilc_wfi_cfgoperations.c: removes unnecessary log
    messages
  staging: wilc1000: wilc_wfi_cfgoperations.c: removes unnecessary log
    messages
  staging: wilc1000: removes unused CFG80211_DBG tag
  staging: wilc1000: coreconfigurator.c: removes unnecessary log
    messages
  staging: wilc1000: host_interface.c: removes unnecessary log messages
  staging: wilc1000: host_interface.c: replace PRINT_ER with netdev_err
  staging: wilc1000: linux_wlan.c: removes unnecessary log messages
  staging: wilc1000: wilc_wfi_cfgoperations.c: removes unnecessary log
    messages
  staging: wilc1000: wilc_wlan.c: removes unnecessary log messages
  staging: wilc1000: removes unused region feature
  staging: wilc1000: removes usused PRINT_XX(region...)
  staging: wilc1000: moves to define values
  staging: wilc1000: moves LINUX_RX_SIZE, LINUX_TX_SIZE

Leo Kim (5):
  staging: wilc1000: wilc_wlan.c: removes PRINT_ER
  staging: wilc1000: linux_mon.c: removes debug logs
  staging: wilc1000: linux_mon.c: replaces PRINT_ER with netdev_err
  staging: wilc1000: linux_mon.c: add to check routine
  staging: wilc1000: removes potential null dereference

 drivers/staging/wilc1000/coreconfigurator.c       |   4 +-
 drivers/staging/wilc1000/host_interface.c         | 332 ++++++++++-----------
 drivers/staging/wilc1000/linux_mon.c              |  74 +----
 drivers/staging/wilc1000/linux_wlan.c             |   1 -
 drivers/staging/wilc1000/linux_wlan_common.h      |  99 -------
 drivers/staging/wilc1000/wilc_debugfs.c           |  47 +--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 341 ++--------------------
 drivers/staging/wilc1000/wilc_wlan.c              |   5 -
 drivers/staging/wilc1000/wilc_wlan.h              |   3 +
 9 files changed, 188 insertions(+), 718 deletions(-)

-- 
1.9.1


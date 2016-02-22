Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:19901 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbcBVKRH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 05:17:07 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V4 00/24] staging: wilc1000: Resend V4
Date: Mon, 22 Feb 2016 19:14:07 +0900
Message-ID: <1456136071-10502-1-git-send-email-leo.kim@atmel.com> (sfid-20160222_111711_684584_6DE718A5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Greg

This is the 4th fix patch about the mistake merging.
Mistake merging is revert the below commit when rebase V3 patches.
(already applied commit) - 6c2ab2398b88 ("staging: wilc1000: remove spaces around '->'")
(V3 mistake patch) - [PATCH V3 09/24] staging: wilc1000: wilc_wfi_cfgoperations.c: removes unnecessary log messages

I'll resend 4th patches after modified this mistake.
We apologize for the inconvenience.

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
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 339 ++--------------------
 drivers/staging/wilc1000/wilc_wlan.c              |   5 -
 drivers/staging/wilc1000/wilc_wlan.h              |   3 +
 9 files changed, 187 insertions(+), 717 deletions(-)

-- 
1.9.1


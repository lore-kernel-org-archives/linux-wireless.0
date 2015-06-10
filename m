Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:30009 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933410AbbFJIGu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 04:06:50 -0400
From: Johnny Kim <johnny.kim@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<Rachel.kim@atmel.com>, <dean.lee@atmel.com>, <tony.cho@atmel.com>
Subject: [PATCH 0/4] staging: wilc1000: fix compile warnings and clean other
Date: Wed, 10 Jun 2015 17:06:43 +0900
Message-ID: <1433923607-20927-1-git-send-email-johnny.kim@atmel.com> (sfid-20150610_100654_881477_46F7BD84)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Greg.

I have rebased on the lastest staging-testing and fixed compile warnings
This patches is prepared to fix the compatibilty issue for 64bit machine
and wrong casting.

I am aware that the others should be patched additonally.
However I need internally to discuss on the other patch. Then, the others
will be sent soon.

  Johnny.

Johnny Kim (4):
  staging: wilc1000: modify data type
  staging: wilc1000: add syntax for 64-bit machine
  staging: wilc1000: modify printk format
  staging: wilc1000: remove uninitialized warnings

 drivers/staging/wilc1000/coreconfigurator.c       |   4 +-
 drivers/staging/wilc1000/coreconfigurator.h       |   2 +-
 drivers/staging/wilc1000/host_interface.c         | 158 ++++++++++++----------
 drivers/staging/wilc1000/host_interface.h         |   6 +-
 drivers/staging/wilc1000/linux_wlan.c             |  14 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  18 +--
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   2 +-
 drivers/staging/wilc1000/wilc_wlan.c              |  27 ++--
 drivers/staging/wilc1000/wilc_wlan.h              |   6 +-
 drivers/staging/wilc1000/wilc_wlan_if.h           |   4 +-
 10 files changed, 136 insertions(+), 105 deletions(-)

-- 
1.9.1


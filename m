Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58988 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358Ab2I2Sd7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2012 14:33:59 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/5] bcma: some small improvements to the flash driver part.
Date: Sat, 29 Sep 2012 20:33:48 +0200
Message-Id: <1348943633-22800-1-git-send-email-hauke@hauke-m.de> (sfid-20120929_203402_697955_3EFD3D94)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was mostly done in preparation for an improvement for
arch/mips/bcm47xx/nvram.c

Hauke Mehrtens (5):
  bcma: mark pflash as present when available
  bcma: add and use constants for the flash windows
  bcma: mark nflash if it is the boot flash
  bcma: extract drv_cc in bcma_core_mips_flash_detect()
  bcma: add some more flash chips for serial flash

 drivers/bcma/driver_chipcommon_nflash.c     |    3 +++
 drivers/bcma/driver_chipcommon_sflash.c     |   35 ++++++++++++++++++++++++---
 drivers/bcma/driver_mips.c                  |   22 +++++++++--------
 include/linux/bcma/bcma_driver_chipcommon.h |    2 ++
 include/linux/bcma/bcma_regs.h              |    5 +++-
 5 files changed, 53 insertions(+), 14 deletions(-)

-- 
1.7.9.5


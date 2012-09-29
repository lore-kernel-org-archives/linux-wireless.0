Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59070 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757448Ab2I2SgY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2012 14:36:24 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com, m@bues.ch,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/2] ssb: some small improvements to the flash driver part.
Date: Sat, 29 Sep 2012 20:36:16 +0200
Message-Id: <1348943778-23079-1-git-send-email-hauke@hauke-m.de> (sfid-20120929_203627_670167_09E4EA79)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was mostly done in preparation for an improvement for
arch/mips/bcm47xx/nvram.c

Hauke Mehrtens (2):
  ssb: move parallel flash config into an own struct
  ssb: add attribute to indicate a parallel flash is available

 arch/mips/bcm47xx/nvram.c           |    4 ++--
 arch/mips/bcm47xx/wgt634u.c         |    8 ++++----
 drivers/ssb/driver_mipscore.c       |   16 +++++++++-------
 include/linux/ssb/ssb_driver_mips.h |   10 +++++++---
 4 files changed, 22 insertions(+), 16 deletions(-)

-- 
1.7.9.5


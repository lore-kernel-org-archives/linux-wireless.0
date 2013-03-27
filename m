Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37117 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669Ab3C0QXb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 12:23:31 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/4] bcma: preparation for brcmsmac using more bcma functions
Date: Wed, 27 Mar 2013 17:23:08 +0100
Message-Id: <1364401392-30360-1-git-send-email-hauke@hauke-m.de> (sfid-20130327_172336_105189_36A26027)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This mostly contains patches in preparation for brcmsmac using the pmu 
functions from bcma and not using its own functions.
The first patch just replaces some magic numbers with the constants.

Hauke Mehrtens (4):
  bcma: use BCMA_CC_PMU_CTL_* constants
  bcma: handle more devices in bcma_pmu_get_alp_clock()
  bcma: export bcma_chipco_get_alp_clock()
  bcma: export some gpio functions

 drivers/bcma/driver_chipcommon.c            |    5 +++-
 drivers/bcma/driver_chipcommon_pmu.c        |   34 ++++++++++++++++++++-------
 include/linux/bcma/bcma_driver_chipcommon.h |    3 +++
 3 files changed, 32 insertions(+), 10 deletions(-)

-- 
1.7.10.4


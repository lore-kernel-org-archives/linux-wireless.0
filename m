Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:38674 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745Ab3ACXvm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 18:51:42 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	nlhintz@hotmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/6] bcma: some fixes for mips IRQ assignment
Date: Fri,  4 Jan 2013 00:51:19 +0100
Message-Id: <1357257085-11822-1-git-send-email-hauke@hauke-m.de> (sfid-20130104_005148_663592_09E2D6B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This improves IRQ assignment to cores on a mips SoC.

Hauke Mehrtens (6):
  bcma: make bcma_find_core_unit() accessible
  bcma: mips: explicit assign IRQ numbers
  bcma: mips: make some info messages debug messages
  bcma: mips: show also disabled IRQs
  bcma: mips: remove assigned_irqs from structure
  bcma: mips: rename oldirqflag to irqinitmask

 drivers/bcma/bcma_private.h           |    2 +
 drivers/bcma/driver_mips.c            |  119 +++++++++++++++++++++------------
 drivers/bcma/main.c                   |    4 +-
 include/linux/bcma/bcma_driver_mips.h |    1 -
 4 files changed, 80 insertions(+), 46 deletions(-)

-- 
1.7.10.4


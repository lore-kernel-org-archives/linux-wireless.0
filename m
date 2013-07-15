Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55238 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299Ab3GOLPX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 07:15:23 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/5] bcma: first patches to add support for BCM4708
Date: Mon, 15 Jul 2013 13:15:03 +0200
Message-Id: <1373886908-4460-1-git-send-email-hauke@hauke-m.de> (sfid-20130715_131526_364906_FF39DD64)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches are just fixing minor problems seen while adding support 
for BCM4708 SoC and they add some constants for this SoC.

Hauke Mehrtens (5):
  bcma: add some more core names
  bcma: make it possible to select SoC support without mips
  bcma: add constants for new ARM based SoCs
  bcma: return correct error code when bus scan failed
  bcma: fix handling of big addrl

 drivers/bcma/Kconfig      |   10 ++++++++--
 drivers/bcma/main.c       |    2 +-
 drivers/bcma/scan.c       |   28 ++++++++++++++++++++--------
 include/linux/bcma/bcma.h |   17 +++++++++++++++++
 4 files changed, 46 insertions(+), 11 deletions(-)

-- 
1.7.10.4


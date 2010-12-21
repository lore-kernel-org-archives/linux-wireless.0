Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50621 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933150Ab0LUBCK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 20:02:10 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/7] Small patches from compat-wirelss for mainline
Date: Tue, 21 Dec 2010 02:01:49 +0100
Message-Id: <1292893316-26694-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches were in compat-wirelss and could go upstream, so we do not 
have to maintain them any more.

Hauke Mehrtens (7):
  wl1251: remove unnecessary import
  wl12xx: remove unnecessary import
  ssb: Use pci_is_pcie()
  rt2x00: Use pci_is_pcie()
  ath5k: Use pci_is_pcie()
  ath9k: Use pci_is_pcie()
  rtlwifi: Use pci_pcie_cap()

 drivers/net/wireless/ath/ath5k/attach.c |    2 +-
 drivers/net/wireless/ath/ath5k/reset.c  |    4 ++--
 drivers/net/wireless/ath/ath9k/pci.c    |    2 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c |    2 +-
 drivers/net/wireless/rtlwifi/pci.c      |    2 +-
 drivers/net/wireless/wl1251/boot.c      |    1 -
 drivers/net/wireless/wl12xx/boot.c      |    1 -
 drivers/ssb/scan.c                      |    4 ++--
 8 files changed, 8 insertions(+), 10 deletions(-)


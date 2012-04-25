Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s5.blu0.hotmail.com ([65.55.111.80]:37643 "EHLO
	blu0-omc2-s5.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758075Ab2DYGP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 02:15:29 -0400
Message-ID: <BLU0-SMTP8282BAB70BC6A84042BB4CAC270@phx.gbl> (sfid-20120425_081533_357541_A14083BD)
From: Nathan Hintz <nlhintz@hotmail.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, hauke@hauke-m.de,
	Nathan Hintz <nlhintz@hotmail.com>
Subject: [PATCH 0/6] BCMA Cumulative patches from OpenWRT
Date: Tue, 24 Apr 2012 23:15:13 -0700
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nathan Hintz (6):
  bcma: Find names of non BCM cores
  bcma: Move initialization of SPROM to prevent overwrite
  bcma: Account for variable PCI memory base/size
  bcma: reads/writes are always 4 bytes, so always map 4 bytes
  bcma: Add __devexit to bcma_host_pci_remove
  bcma: Add flush for BCMA_RESET_CTL write

 arch/mips/bcm47xx/setup.c      |    4 +++
 arch/mips/bcm47xx/sprom.c      |    2 -
 drivers/bcma/core.c            |    1 +
 drivers/bcma/driver_pci_host.c |   11 ++++---
 drivers/bcma/host_pci.c        |    4 +-
 drivers/bcma/scan.c            |   54 +++++++++++++++++++++++++++++----------
 6 files changed, 53 insertions(+), 23 deletions(-)

-- 
1.7.7.6


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s18.blu0.hotmail.com ([65.55.111.93]:23765 "EHLO
	blu0-omc2-s18.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789Ab2EEE5S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 May 2012 00:57:18 -0400
Message-ID: <BLU0-SMTP198B72D051A29761F548916AC2D0@phx.gbl> (sfid-20120505_065722_963308_86D01059)
From: Nathan Hintz <nlhintz@hotmail.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, hauke@hauke-m.de,
	Nathan Hintz <nlhintz@hotmail.com>
Subject: [PATCH v3 0/6] BCMA Cumulative patches from OpenWRT
Date: Fri, 4 May 2012 21:56:30 -0700
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Submit OpenWRT BCMA patches upstream

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
 drivers/bcma/driver_pci_host.c |   10 +++---
 drivers/bcma/host_pci.c        |    4 +-
 drivers/bcma/scan.c            |   54 +++++++++++++++++++++++++++++----------
 6 files changed, 52 insertions(+), 23 deletions(-)

-- 
1.7.7.6


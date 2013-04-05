Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:33536 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161564Ab3DEG0n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 02:26:43 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	users@rt2x00.serialmonkey.com, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 0/6] rt2x00: use rt2x00mmio prefix for rt2x00mmio module functions
Date: Fri,  5 Apr 2013 08:26:59 +0200
Message-Id: <1365143225-24532-1-git-send-email-juhosg@openwrt.org> (sfid-20130405_082651_695628_A009D22B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series replaces the rt2x00pci prefix to
rt2x00mmio of the functions provided by the
rt2x00mmio module. This is a supplement of the
'rt2x00: rt2x00pci: fix build error on Ralink
RT3x5x SoCs' patch.

The patch-set is based on the master branch of
wireless-testing.git.

Gabor Juhos (6):
  rt2x00: rt2x00mmio: use rt2x00mmio prefix in function names
  rt2x00: rt2400pci: use the rt2x00mmio_* routines
  rt2x00: rt2500pci: use the rt2x00mmio_* routines
  rt2x00: rt61pci: use the rt2x00mmio_* routines
  rt2x00: rt2800pci: use the rt2x00mmio_* routines
  rt2x00: rt2x00mmio: remove unused rt2x00pci_* defines

 drivers/net/wireless/rt2x00/rt2400pci.c  |  309 +++++++++---------
 drivers/net/wireless/rt2x00/rt2500pci.c  |  334 +++++++++----------
 drivers/net/wireless/rt2x00/rt2800pci.c  |  241 +++++++-------
 drivers/net/wireless/rt2x00/rt2x00mmio.c |   48 +--
 drivers/net/wireless/rt2x00/rt2x00mmio.h |   52 +--
 drivers/net/wireless/rt2x00/rt61pci.c    |  515 +++++++++++++++---------------
 6 files changed, 754 insertions(+), 745 deletions(-)

--
1.7.10


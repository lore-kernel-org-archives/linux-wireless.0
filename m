Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:36225 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761433Ab3EAPRd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 11:17:33 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 0/7] rt2x00: avoid a few superfluous pointer dereferences
Date: Wed,  1 May 2013 17:17:28 +0200
Message-Id: <1367421455-18463-1-git-send-email-juhosg@openwrt.org> (sfid-20130501_171827_897631_3802920F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos (7):
  rt2x00: rt2x00dev: use rt2x00dev->tx->limit
  rt2x00: rt61pci: use rt2x00dev->tx->limit
  rt2x00: rt2800pci: use rt2x00dev->tx->limit
  rt2x00: rt2800usb: use rt2x00dev->rx->limit
  rt2x00: rt2800lib: use rt2x00dev->bcn->winfo_size
  rt2x00: rt2x00dev: defer operational mode detection
  rt2x00: rt2x00dev: use rt2x00dev->bcn->limit

 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 drivers/net/wireless/rt2x00/rt2800pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c |   36 +++++++++++++++----------------
 drivers/net/wireless/rt2x00/rt61pci.c   |    2 +-
 5 files changed, 22 insertions(+), 22 deletions(-)

--
1.7.10


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:53081 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018Ab3HQR4S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Aug 2013 13:56:18 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 0/6] rt2x00: fix beaconing on RT3593
Date: Sat, 17 Aug 2013 19:56:01 +0200
Message-Id: <1376762167-24583-1-git-send-email-juhosg@openwrt.org> (sfid-20130817_195621_695275_A1F58F79)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos (6):
  rt2x00: rt2800lib: move rt2800_drv_data declaration into rt2800lib.h
  rt2x00: rt2800lib: introduce RT2800_HAS_HIGH_SHARED_MEM flag
  rt2x00: rt2800: serialize shared memory access
  rt2x00: rt2800lib: add rt2800_hw_beacon_base helper
  rt2x00: rt2800lib: don't hardcode beacon offsets
  rt2x00: rt2800lib: fix beacon generation on RT3593

 drivers/net/wireless/rt2x00/rt2800.h    |   18 ++--
 drivers/net/wireless/rt2x00/rt2800lib.c |  146 ++++++++++++++++++++++++++++---
 drivers/net/wireless/rt2x00/rt2800lib.h |   42 +++++++++
 drivers/net/wireless/rt2x00/rt2800pci.c |   10 +++
 drivers/net/wireless/rt2x00/rt2800usb.c |    5 ++
 5 files changed, 198 insertions(+), 23 deletions(-)

--
1.7.10

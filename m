Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46875 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab3FXVDd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 17:03:33 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v3 0/3] rt2x00: rt2800: prepare for three-chain device support
Date: Mon, 24 Jun 2013 23:03:21 +0200
Message-Id: <1372107804-19679-1-git-send-email-juhosg@openwrt.org> (sfid-20130624_230335_790997_D8CF759D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos (3):
  rt2x00: rt2800: increase EEPROM_SIZE to 512 bytes
  rt2x00: rt2800lib: turn on secondary PAs/LNAs for 3T/3R devices
  rt2x00: rt2800lib: turn on tertiary PAs/LNAs for 3T/3R devices

 drivers/net/wireless/rt2x00/rt2800.h    |    2 +-
 drivers/net/wireless/rt2x00/rt2800lib.c |   47 +++++++++++++++++++++++--------
 2 files changed, 36 insertions(+), 13 deletions(-)

--
1.7.10


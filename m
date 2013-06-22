Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:59816 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab3FVPmZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Jun 2013 11:42:25 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 0/3] rt2x00: rt2800: prepare for three-chain device support
Date: Sat, 22 Jun 2013 17:42:11 +0200
Message-Id: <1371915734-13966-1-git-send-email-juhosg@openwrt.org> (sfid-20130622_174240_126924_8490317F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos (3):
  rt2x00: rt2800: increase EEPROM_SIZE to 512 bytes
  rt2x00: rt2800lib: turn on secondary PAs/LNAs for 3T/3R devices
  rt2x00: rt2800lib: turn on tertiary PAs/LNAs for 3T/3R devices

 drivers/net/wireless/rt2x00/rt2800.h    |    2 +-
 drivers/net/wireless/rt2x00/rt2800lib.c |   22 ++++++++++++++++++----
 2 files changed, 19 insertions(+), 5 deletions(-)

--
1.7.10


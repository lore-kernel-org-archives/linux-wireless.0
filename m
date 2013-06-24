Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:39068 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab3FXUc4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 16:32:56 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 0/3] rt2x00: rt2800: prepare for three-chain device support
Date: Mon, 24 Jun 2013 22:32:49 +0200
Message-Id: <1372105972-3022-1-git-send-email-juhosg@openwrt.org> (sfid-20130624_223300_313141_669D5798)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos (3):
  rt2x00: rt2800: increase EEPROM_SIZE to 512 bytes
  rt2x00: rt2800lib: turn on secondary PAs/LNAs for 3T/3R devices
  rt2x00: rt2800lib: turn on tertiary PAs/LNAs for 3T/3R devices

 drivers/net/wireless/rt2x00/rt2800.h    |    2 +-
 drivers/net/wireless/rt2x00/rt2800lib.c |   44 +++++++++++++++++++++++--------
 2 files changed, 34 insertions(+), 12 deletions(-)

--
1.7.10


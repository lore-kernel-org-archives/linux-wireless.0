Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48655 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab3GHJ0A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 05:26:00 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 0/5] rt2800lib: add support for extended EEPROM of three-cain devices
Date: Mon,  8 Jul 2013 11:25:51 +0200
Message-Id: <1373275556-6482-1-git-send-email-juhosg@openwrt.org> (sfid-20130708_112604_519522_238B3597)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos (5):
  rt2x00: rt2800lib: introduce rt2800_eeprom_word enum
  rt2x00: rt2800lib: introduce local EEPROM access functions
  rt2x00: rt2800lib: introduce rt2800_eeprom_read_from_array helper
  rt2x00: rt2800lib: introduce rt2800_eeprom_word_index helper
  rt2x00: rt2800lib: add EEPROM map for the RT3593 chipset

 drivers/net/wireless/rt2x00/rt2800.h    |   87 +++++----
 drivers/net/wireless/rt2x00/rt2800lib.c |  305 +++++++++++++++++++++++--------
 2 files changed, 279 insertions(+), 113 deletions(-)

--
1.7.10


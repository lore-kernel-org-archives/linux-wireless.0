Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46414 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943Ab3HQMJj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Aug 2013 08:09:39 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 0/6] rt2x00: rt2800lib: frequency offset adjustment fixes
Date: Sat, 17 Aug 2013 14:09:27 +0200
Message-Id: <1376741373-10032-1-git-send-email-juhosg@openwrt.org> (sfid-20130817_140943_249124_E9F34DCA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch-set contain small fixes for the frequency adjustment
code of the rt2800 driver.

Gabor Juhos (6):
  rt2x00: rt2800lib: fix frequency offset boundary calculation
  rt2x00: rt2800lib: optimize frequency offset adjustment
  rt2x00: rt2800lib: use a MCU command for frequency adjustment on USB
    devices
  rt2x00: rt2800lib: use step-by-step frequency offset adjustment on
    MMIO devices
  rt2x00: rt2800lib: move rt2800_adjust_freq_offset function
  rt2x00: rt2800lib: adjust frequency offset for RF3053

 drivers/net/wireless/rt2x00/rt2800.h    |    1 +
 drivers/net/wireless/rt2x00/rt2800lib.c |   52 ++++++++++++++++++++++---------
 2 files changed, 39 insertions(+), 14 deletions(-)

--
1.7.10

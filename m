Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:55338 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919Ab3HPWeD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 18:34:03 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 0/5] rt2x00: rt2800lib: frequency offset adjustment fixes
Date: Fri, 16 Aug 2013 22:38:13 +0200
Message-Id: <1376685498-5167-1-git-send-email-juhosg@openwrt.org> (sfid-20130817_003419_598412_080A743D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch-set contain small fixes for the frequency adjustment 
code of the rt2800 driver.

Gabor Juhos (5):
  rt2x00: rt2800lib: fix frequency offset boundary calculation
  rt2x00: rt2800lib: optimize frequency offset adjustment
  rt2x00: rt2800lib: use a MCU command for frequency adjustment on USB
    devices
  rt2x00: rt2800lib: move rt2800_adjust_freq_offset function
  rt2x00: rt2800lib: adjust frequency offset for RF3053

 drivers/net/wireless/rt2x00/rt2800lib.c |   38 +++++++++++++++++++------------
 1 file changed, 24 insertions(+), 14 deletions(-)

-- 
1.7.10

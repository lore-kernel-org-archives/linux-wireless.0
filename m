Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38642 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143Ab3C3Nwi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Mar 2013 09:52:38 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	users@rt2x00.serialmonkey.com, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 0/3] rt2x00: probe RT chipset before EEPROM validation
Date: Sat, 30 Mar 2013 14:53:07 +0100
Message-Id: <1364651590-29710-1-git-send-email-juhosg@openwrt.org> (sfid-20130330_145249_833666_78CF1AAA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch-set ensures that the RT chipset is probed before
validating the EEPROM content.

Gabor Juhos (3):
  rt2x00: introduce rt2x00_set_{rt,rf} helpers
  rt2x00: rt2800lib: separate RT and RF chipset detection
  rt2x00: rt2800lib: probe RT chipset earlier

 drivers/net/wireless/rt2x00/rt2800lib.c |   92 ++++++++++++++++++-------------
 drivers/net/wireless/rt2x00/rt2x00.h    |   17 ++++++
 2 files changed, 72 insertions(+), 37 deletions(-)

-- 
1.7.10


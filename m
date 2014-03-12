Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0202.hostedemail.com ([216.40.44.202]:57120 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752668AbaCLRWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2014 13:22:47 -0400
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
	linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH net-next 0/9] drivers/net: Convert uses of __constant_<foo> to <foo>
Date: Wed, 12 Mar 2014 10:22:29 -0700
Message-Id: <cover.1394644825.git.joe@perches.com> (sfid-20140312_182740_189160_41E2AB46)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches (9):
  brocade: Convert uses of __constant_<foo> to <foo>
  e100: Convert uses of __constant_<foo> to <foo>
  igb: Convert uses of __constant_<foo> to <foo>
  igbvf: Convert uses of __constant_<foo> to <foo>
  ixgbe: Convert uses of __constant_<foo> to <foo>
  ixgbevf: Convert uses of __constant_<foo> to <foo>
  xilinx: Convert uses of __constant_<foo> to <foo>
  lg-vl600: Convert uses of __constant_<foo> to <foo>
  ath9k: Convert uses of __constant_<foo> to <foo>

 drivers/net/ethernet/brocade/bna/bnad.c           | 16 +++++-------
 drivers/net/ethernet/intel/e100.c                 |  4 +--
 drivers/net/ethernet/intel/igb/igb_main.c         | 12 ++++-----
 drivers/net/ethernet/intel/igbvf/netdev.c         |  4 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c     |  8 +++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     | 30 +++++++++++------------
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |  4 +--
 drivers/net/ethernet/xilinx/ll_temac_main.c       |  4 +--
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |  2 +-
 drivers/net/usb/lg-vl600.c                        |  2 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c    |  4 +--
 11 files changed, 43 insertions(+), 47 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty


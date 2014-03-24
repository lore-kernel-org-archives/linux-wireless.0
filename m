Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0212.hostedemail.com ([216.40.44.212]:48842 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753671AbaCXUPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 16:15:49 -0400
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: nios2-dev@lists.rocketboards.org, linux-kernel@vger.kernel.org,
	e1000-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: [PATCH net-next 0/7] drivers/net: Remove pointer casts to same type
Date: Mon, 24 Mar 2014 13:15:33 -0700
Message-Id: <cover.1395692043.git.joe@perches.com> (sfid-20140324_211911_595554_DDCABAA4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All of these are pointless...

Joe Perches (7):
  altera: Remove casts of pointer to same type
  alx: Remove casts of pointer to same type
  intel: Remove casts of pointer to same type
  qlcnic: Remove casts of pointer to same type
  carl9170: Remove casts of pointer to same type
  mwifiex: Remove casts of pointer to same type
  rtlwifi: Remove casts of pointer to same type

 drivers/net/ethernet/altera/altera_tse_main.c      |  4 +-
 drivers/net/ethernet/atheros/alx/main.c            |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  4 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |  2 +-
 drivers/net/wireless/ath/carl9170/rx.c             |  2 +-
 drivers/net/wireless/mwifiex/pcie.c                |  6 +--
 drivers/net/wireless/mwifiex/scan.c                |  2 +-
 drivers/net/wireless/mwifiex/tdls.c                |  6 +--
 drivers/net/wireless/rtlwifi/core.c                |  2 +-
 drivers/net/wireless/rtlwifi/ps.c                  | 19 ++++---
 drivers/net/wireless/rtlwifi/rtl8188ee/dm.c        |  5 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/fw.c        |  4 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c        | 57 ++++++++++----------
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c       |  4 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c        | 14 ++---
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c        | 14 +++--
 drivers/net/wireless/rtlwifi/rtl8723ae/dm.c        |  5 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c        | 60 ++++++++++------------
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c       |  4 +-
 drivers/net/wireless/rtlwifi/rtl8723be/dm.c        |  2 +-
 drivers/net/wireless/rtlwifi/rtl8723be/hw.c        | 57 ++++++++++----------
 drivers/net/wireless/rtlwifi/rtl8723be/trx.c       |  4 +-
 .../net/wireless/rtlwifi/rtl8723com/fw_common.c    |  4 +-
 23 files changed, 132 insertions(+), 151 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty


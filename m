Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4244 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab2FLOrK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 10:47:10 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 0/8] ath9k_hw: BTCOEX MCI cleanup
Date: Tue, 12 Jun 2012 20:18:15 +0530
Message-ID: <1339512503-26670-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120612_164720_109112_FE30B2FF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This series cleans up the BTCOEX MCI states and
introduces utility functions for MCI GPM offset.

Rajkumar Manoharan (8):
  ath9k_hw: cleanup MCI gpm offset state
  ath9k_hw: add utility function to set BT version
  ath9k_hw: remove MCI_STATE_SEND_WLAN_CHANNELS
  ath9k_hw: remove MCI_STATE_NEED_FLUSH_BT_INFO
  ath9k_hw: remove p_data argument from ar9003_mci_state
  ath9k_hw: remove MCI_STATE_BT
  ath9k_hw: remove MCI_STATE_CONT_* state
  ath9k_hw: remove MCI_STATE_SET_BT_SLEEP

 drivers/net/wireless/ath/ath9k/ar9003_mci.c |  286 ++++++++++++---------------
 drivers/net/wireless/ath/ath9k/ar9003_mci.h |   21 +-
 drivers/net/wireless/ath/ath9k/gpio.c       |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c         |    2 +-
 drivers/net/wireless/ath/ath9k/mci.c        |   85 ++++----
 drivers/net/wireless/ath/ath9k/reg.h        |    4 +-
 6 files changed, 170 insertions(+), 230 deletions(-)

-- 
1.7.10.4


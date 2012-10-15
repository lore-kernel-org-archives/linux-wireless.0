Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47056 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2JOKAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 06:00:45 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 00/11] BTCOEX fixes for AR9565
Date: Mon, 15 Oct 2012 15:29:44 +0530
Message-ID: <1350295195-23410-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121015_120048_358866_4E13C77B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here is the set of fixes for AR9565 BTCoex issues

-Rajkumar

Bala Shanmugam (2):
  ath9k: Set appropriate bit for AR9565 in btc control register
  ath9k: turn off RXIQ calibration while re-calibrating radio

Rajkumar Manoharan (9):
  ath9k_hw: Enable OSLA hw fix for AR9565
  ath9k_hw: Fix selfgen chainmask for 9565
  ath9k_hw: Disable MCI stat counter by default for AR9565
  ath9k_hw: Fix frequent BT rx recovery
  ath9k_hw: Fix max rx rate drop for AR9565
  ath9k_hw: Configure new switch table for AR9565 BTCOEX
  ath9k_hw: Set default MCI config for AR9565
  ath9k: adjust duty cycle for FTP profile for AR9565
  ath9k: Add new BT profile info A2DP_Voice

 drivers/net/wireless/ath/ath9k/ar9003_calib.c  |  5 ++++
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |  2 +-
 drivers/net/wireless/ath/ath9k/ar9003_mci.c    | 37 +++++++++++++++++++++++---
 drivers/net/wireless/ath/ath9k/ar9003_mci.h    |  2 ++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |  1 +
 drivers/net/wireless/ath/ath9k/btcoex.c        |  2 +-
 drivers/net/wireless/ath/ath9k/btcoex.h        |  1 +
 drivers/net/wireless/ath/ath9k/mci.c           |  2 +-
 drivers/net/wireless/ath/ath9k/mci.h           |  2 ++
 drivers/net/wireless/ath/ath9k/reg.h           | 11 +++++---
 drivers/net/wireless/ath/ath9k/wow.c           |  2 +-
 11 files changed, 55 insertions(+), 12 deletions(-)

-- 
1.7.12.2


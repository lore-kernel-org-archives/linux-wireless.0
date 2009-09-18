Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44843 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbZIRJdD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 05:33:03 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 02:33:07 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19123.21462.191695.91617@gargle.gargle.HOWL>
Date: Fri, 18 Sep 2009 15:03:10 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH/REVIEW 0/9] ath9k update
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

A bunch of fixes/cleanups.

These patches apply over the pending ath9k patches:
  - The inital series of bug fixes.
  - Luis' series.

Please apply.

Thanks,
Sujith

Senthil Balasubramanian (5):
  ath9k: Allow PSPOLL only when the interface is configured in AP mode.
  ath9k: Handle ATH9K_BEACON_RESET_TSF properly
  ath9k: Reduce PLL Settle time and eliminate redundant PLL calls.
  ath9k: Advertise midband for AR5416 devices
  ath9k: Fix bugs in handling TX power

Sujith (2):
  ath9k: Update INI release for AR9287
  ath9k: Fix RTC reset for AR5416

Vasanthakumar Thiagarajan (1):
  ath9k: Update initvals

Vivek Natarajan (1):
  ath9k: Add Calibration checks

 drivers/net/wireless/ath/ath9k/calib.c      |   82 ++++++++++++++--------
 drivers/net/wireless/ath/ath9k/eeprom.h     |    6 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c  |    4 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c |  102 +++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/hw.c         |   36 +++++++--
 drivers/net/wireless/ath/ath9k/hw.h         |    4 +-
 drivers/net/wireless/ath/ath9k/initvals.h   |   72 +++++++++++--------
 drivers/net/wireless/ath/ath9k/phy.c        |   25 +++++--
 drivers/net/wireless/ath/ath9k/recv.c       |    5 +-
 9 files changed, 253 insertions(+), 83 deletions(-)


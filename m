Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54129 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbZDMQ2o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 12:28:44 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2009 09:28:44 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18915.26414.269933.599629@gargle.gargle.HOWL> (sfid-20090413_182906_088019_FE68A537)
Date: Mon, 13 Apr 2009 21:54:14 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 00/11] ath9k fixes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

A bunch of driver fixes, a few are stable candidates (2.6.29) too.
Applies over the pending ath5k/ath9k/ar9170 merge patches and two ath9k patches.
Please apply.

Sujith

Sujith (11):
  ath9k: Handle ASPM properly for RFKILL
  ath9k: Fix memleak on TX DMA failure
  ath9k: Fix bug in scan termination
  ath9k: Remove unused channel flags
  ath9k: Fix bug in checking HT flag
  ath9k: Fix bug in determining calibration support
  ath9k: Initialize ANI timers
  ath9k: Cleanup calibration interface
  ath9k: Use a consistent naming convention
  ath9k: Fix bug in calibration initialization
  ath9k: Remove CHANNEL_CW_INT handling in ath9k_hw_calibrate

 drivers/net/wireless/ath/ath9k/calib.c |  123 +++++++++++++-------------------
 drivers/net/wireless/ath/ath9k/calib.h |   33 ++++-----
 drivers/net/wireless/ath/ath9k/hw.h    |   28 ++-----
 drivers/net/wireless/ath/ath9k/main.c  |   62 ++++++++---------
 drivers/net/wireless/ath/ath9k/xmit.c  |    5 +-
 5 files changed, 107 insertions(+), 144 deletions(-)


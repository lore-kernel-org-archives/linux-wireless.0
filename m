Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21382 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbZFXN0n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2009 09:26:43 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2009 06:26:47 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 0/7] *** SUBJECT HERE ***
Date: Wed, 24 Jun 2009 18:56:35 +0530
Message-ID: <1245850002-26351-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

I have updated the commit logs as requested by you and also
rebased & reorganized my earlier series on the TIP of wireless-testing.

It would be great if the following patches can make it for 2.6.31.

  ath9k: Manipulate and report the correct RSSI
  ath9k: RX stucks during heavy traffic in HT40 mode.
  ath9k: Fix TX hang issue with Atheros chipsets

Senthil

Senthil Balasubramanian (7):
  ath9k: Manipulate and report the correct RSSI
  ath9k: RX stucks during heavy traffic in HT40 mode.
  ath9k: Fix TX hang issue with Atheros chipsets
  ath9k: remove unnecessary STATION mode check.
  ath9k: stop ani when the STA gets disconnected.
  ath9k: race condition in SCANNING state check during ANI calibration
  ath9k: Handle different TX and RX streams properly.

 drivers/net/wireless/ath/ath9k/ath9k.h    |   21 +++++++++
 drivers/net/wireless/ath/ath9k/calib.c    |   13 ++++-
 drivers/net/wireless/ath/ath9k/calib.h    |    4 +-
 drivers/net/wireless/ath/ath9k/eeprom.c   |   20 ++++++++-
 drivers/net/wireless/ath/ath9k/initvals.h |   47 +++++++++++----------
 drivers/net/wireless/ath/ath9k/mac.c      |   30 ++++++++++---
 drivers/net/wireless/ath/ath9k/main.c     |   66 ++++++++++++++++------------
 drivers/net/wireless/ath/ath9k/recv.c     |   25 ++++++++++-
 drivers/net/wireless/ath/ath9k/xmit.c     |   57 +++++++++++++++++++------
 9 files changed, 206 insertions(+), 77 deletions(-)


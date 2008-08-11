Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42604 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbYHKIn6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 04:43:58 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2008 01:43:58 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18591.63772.263393.659838@localhost.localdomain> (sfid-20080811_104403_749139_6124AA5F)
Date: Mon, 11 Aug 2008 14:02:28 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 00/10] More cleanup
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Another round of cleanups.

Sujith

Sujith Manoharan (10):
  ath9k: Merge reset functions
  ath9k: RX Filter cleanup
  ath9k: Use bitfields for buffer type
  ath9k: Remove a few unnecessary macros
  ath9k: Remove ar5416hal and assign default values directly
  ath9k: Unused macros, variables
  ath9k: Use a single opmode variable
  ath9k: Use bitfields for sc operations
  ath9k: Use ah_curchan and remove sc_curchan which is redundant
  ath9k: Trim struct ath_softc

 drivers/net/wireless/ath9k/ath9k.h  |   20 ++--
 drivers/net/wireless/ath9k/beacon.c |   32 +++---
 drivers/net/wireless/ath9k/core.c   |  216 ++++++++++------------------------
 drivers/net/wireless/ath9k/core.h   |  176 ++++++++++++-----------------
 drivers/net/wireless/ath9k/hw.c     |   36 +-----
 drivers/net/wireless/ath9k/hw.h     |  116 +++++++------------
 drivers/net/wireless/ath9k/main.c   |   36 +++---
 drivers/net/wireless/ath9k/rc.c     |    6 +-
 drivers/net/wireless/ath9k/recv.c   |   39 ++++---
 drivers/net/wireless/ath9k/xmit.c   |  137 ++++++++++++----------
 10 files changed, 326 insertions(+), 488 deletions(-)


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:35186 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbYHNIHp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 04:07:45 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 14 Aug 2008 01:07:45 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18595.58652.840027.998584@localhost.localdomain> (sfid-20080814_100752_143304_F61A601B)
Date: Thu, 14 Aug 2008 13:26:12 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 0/6] Another cleanup series
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

More cleanup.
This applies on top of Jouni's AP series which are
on top of the 10 patch series I sent earlier.

Sujith

Sujith Manoharan (6):
  ath9k: Remove remaining occurences of ath_skb_map functions
  ath9k: Random cleanup
  ath9k: Miscellaneous fixes
  mac80211: Add an 802.11n definition
  ath9k: Use definition from ieee80211.h
  ath9k: Add IEEE80211_HW_RX_INCLUDES_FCS to hw flags

 drivers/net/wireless/ath9k/ath9k.h  |   13 ---
 drivers/net/wireless/ath9k/beacon.c |   57 ++++++-------
 drivers/net/wireless/ath9k/core.c   |  106 ++++-------------------
 drivers/net/wireless/ath9k/core.h   |   26 ++----
 drivers/net/wireless/ath9k/hw.c     |   81 ++++++++----------
 drivers/net/wireless/ath9k/main.c   |   40 ++-------
 drivers/net/wireless/ath9k/phy.h    |   12 ++--
 drivers/net/wireless/ath9k/rc.c     |  159 ++++++++++++++++++-----------------
 drivers/net/wireless/ath9k/recv.c   |   42 ++-------
 drivers/net/wireless/ath9k/xmit.c   |   37 ++++-----
 include/linux/ieee80211.h           |    1 +
 11 files changed, 207 insertions(+), 367 deletions(-)


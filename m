Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54258 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbYHGFd1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 01:33:27 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 22:33:27 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18586.34419.33602.930102@localhost.localdomain> (sfid-20080807_073339_074409_F5BA5E91)
Date: Thu, 7 Aug 2008 10:51:55 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 0/6] ath9k: Cleanup series
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

A bunch of cleanups, removal of duplicate data structures and
unused macros.

Sujith

Sujith Manoharan (6):
  ath9k: Cleanup data structures related to HW capabilities
  ath9k: Remove redundant data structure ath9k_txq_info
  ath9k: Use mac80211's band macros and remove enum hal_freq_band
  ath9k: Remove a few unused macros and fix indentation
  ath9k: More unused macros
  ath9k: Revamp wireless mode usage

 drivers/net/wireless/ath9k/ath9k.h       |  275 ++++++---------
 drivers/net/wireless/ath9k/beacon.c      |   20 +-
 drivers/net/wireless/ath9k/core.c        |  208 +++++-------
 drivers/net/wireless/ath9k/core.h        |  479 ++++++++++++--------------
 drivers/net/wireless/ath9k/hw.c          |  558 +++++++++++++++---------------
 drivers/net/wireless/ath9k/main.c        |   85 +----
 drivers/net/wireless/ath9k/rc.c          |   32 +-
 drivers/net/wireless/ath9k/rc.h          |    2 +-
 drivers/net/wireless/ath9k/recv.c        |    4 +-
 drivers/net/wireless/ath9k/regd.c        |  117 +++----
 drivers/net/wireless/ath9k/regd.h        |   10 +-
 drivers/net/wireless/ath9k/regd_common.h |   18 +-
 drivers/net/wireless/ath9k/xmit.c        |   35 +-
 13 files changed, 837 insertions(+), 1006 deletions(-)


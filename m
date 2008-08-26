Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39649 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577AbYHZClx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 22:41:53 -0400
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18611.27912.349296.322058@localhost.localdomain> (sfid-20080826_044155_900793_F3B720C5)
Date: Tue, 26 Aug 2008 08:10:08 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 0/4] Trivial cleanups
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Smallish, trivial cleanups that were festering in my tree for a long time.

Sujith

Sujith Manoharan (4):
  ath9k: Remove more dead code
  ath9k: Do not update frame's duration field
  ath9k: Remove sc_lastrx as we don't use it anywhere
  ath9k: rc.h cleanup

 drivers/net/wireless/ath9k/ath9k.h  |    5 -
 drivers/net/wireless/ath9k/beacon.c |   25 ----
 drivers/net/wireless/ath9k/core.h   |    2 -
 drivers/net/wireless/ath9k/hw.h     |    4 -
 drivers/net/wireless/ath9k/main.c   |    5 -
 drivers/net/wireless/ath9k/rc.c     |   18 ++--
 drivers/net/wireless/ath9k/rc.h     |  222 ++++++++++++++++++-----------------
 drivers/net/wireless/ath9k/xmit.c   |   63 ++--------
 8 files changed, 138 insertions(+), 206 deletions(-)


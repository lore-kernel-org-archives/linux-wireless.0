Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3087 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbZGDRAw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 13:00:52 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 0/5] ath5k updates
Date: Sat,  4 Jul 2009 12:59:50 -0400
Message-Id: <1246726795-3934-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been sitting on these patches for much too long.  But anyway,
here are some updates for ath5k.  1-2 fix beacon issues, 3 is just
minor cleanup that I had sitting around forever, 4 is a reported
suspend/resume issue from Alan Jenkins, and 5 is a reported
initialization issue from Forrest Zhang.

Bob Copeland (5):
  ath5k: send buffered frames after the beacon
  ath5k: rework beacon configuration
  ath: remove unnecessary return in ath_regd_get_band_ctl
  ath5k: do not release irq across suspend/resume
  ath5k: write PCU registers on initial reset

 drivers/net/wireless/ath/ath5k/base.c |  107 +++++++++++++++-----------------
 drivers/net/wireless/ath/ath5k/base.h |   10 ++--
 drivers/net/wireless/ath/ath5k/qcu.c  |    1 -
 drivers/net/wireless/ath/regd.c       |    2 -
 4 files changed, 55 insertions(+), 65 deletions(-)



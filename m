Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4851 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab0DHEAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 00:00:16 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	br1@einfach.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 0/4] ath5k: misc fixes
Date: Wed,  7 Apr 2010 23:55:55 -0400
Message-Id: <1270698959-7844-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here are a few bug fixes for ath5k.  They are primarily minor
and/or theoretical so I didn't include stable CCs.

They should not conflict with Bruno's ANI patch.

Bob Copeland (4):
  ath5k: correct channel setting for 2.5 mhz spacing
  ath5k: clean up queue manipulation
  ath5k: fix race condition in tx desc processing
  ath5k: add bounds check to pdadc table

 drivers/net/wireless/ath/ath5k/base.c |   14 ++++++++++++--
 drivers/net/wireless/ath/ath5k/phy.c  |   10 +++++-----
 2 files changed, 17 insertions(+), 7 deletions(-)



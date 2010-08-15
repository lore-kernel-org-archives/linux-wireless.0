Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2185 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301Ab0HORNR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Aug 2010 13:13:17 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 0/6] ath5k cleanups and fixes
Date: Sun, 15 Aug 2010 13:03:09 -0400
Message-Id: <1281891795-14718-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Here are a few cleanups from myself and Nick, and a couple of
minor filter fixes, for 2.6.37.

Bob Copeland (4):
  ath5k: clean up some comments
  ath5k: remove monitor check in receive_frame_ok filter
  ath5k: remove all mention of monitor iftype
  ath5k: don't enable probe request rx for STAs

Nick Kossifidis (2):
  ath5k: rename ath5k_hw_set_associd to _set_bssid
  ath5k: remove own (wrong) IEEE80211_MAX_LEN

 drivers/net/wireless/ath/ath5k/ani.c      |    6 +-
 drivers/net/wireless/ath/ath5k/ath5k.h    |    7 +--
 drivers/net/wireless/ath/ath5k/attach.c   |    8 ++--
 drivers/net/wireless/ath/ath5k/base.c     |   81 +++++++++++++----------------
 drivers/net/wireless/ath/ath5k/dma.c      |    4 +-
 drivers/net/wireless/ath/ath5k/eeprom.c   |    4 +-
 drivers/net/wireless/ath/ath5k/pcu.c      |   13 ++---
 drivers/net/wireless/ath/ath5k/phy.c      |   15 ++---
 drivers/net/wireless/ath/ath5k/reg.h      |    2 +-
 drivers/net/wireless/ath/ath5k/reset.c    |   24 ++++----
 drivers/net/wireless/ath/ath5k/rfbuffer.h |    4 +-
 11 files changed, 77 insertions(+), 91 deletions(-)



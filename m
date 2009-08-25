Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3180 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbZHYDBg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 23:01:36 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 0/4] ath5k: misc updates
Date: Mon, 24 Aug 2009 23:00:29 -0400
Message-Id: <1251169233-24169-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here are a few patches that have been sitting around in my tree
for a while.  A cleanup or two, rxs conversion, and CCMP support.

Bob Copeland (4):
  ath5k: clean up filter flags setting
  ath5k: add led pin configuration for compaq c700 laptop
  ath5k: use the skb->cb directly for RX status
  ath5k: add hardware CCMP encyption support

 drivers/net/wireless/ath/ath5k/ath5k.h  |    1 +
 drivers/net/wireless/ath/ath5k/attach.c |   10 ++++
 drivers/net/wireless/ath/ath5k/base.c   |   83 +++++++++++++++++-------------
 drivers/net/wireless/ath/ath5k/led.c    |    2 +
 4 files changed, 60 insertions(+), 36 deletions(-)



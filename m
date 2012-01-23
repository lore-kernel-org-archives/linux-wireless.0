Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:60925 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab2AWOk1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 09:40:27 -0500
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [PATCH 0/2] Add STBC flag decoding for radiotap
Date: Mon, 23 Jan 2012 15:27:39 +0100
Message-Id: <1327328861-7223-1-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20120123_154034_977571_02F2E35B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches have been originally posted on radiotap.org on 3 Nov 2011
and followed radiotap standardisation process.

Wireshark counterpart is on:
https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=6720


Wojciech Dubowik (2):
  mac80211: Add STBC RX flag to radiotap.     Signed-off-by: Wojciech
    Dubowik <Wojciech.Dubowik@neratec.com>
  ath9k: Add STBC flag to rx status     Signed-off-by: Wojciech Dubowik
    <Wojciech.Dubowik@neratec.com>

 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    1 +
 drivers/net/wireless/ath/ath9k/mac.c        |    2 ++
 drivers/net/wireless/ath/ath9k/mac.h        |    4 +++-
 drivers/net/wireless/ath/ath9k/recv.c       |    2 ++
 include/net/ieee80211_radiotap.h            |    3 ++-
 include/net/mac80211.h                      |    1 +
 net/mac80211/rx.c                           |    5 ++++-
 7 files changed, 15 insertions(+), 3 deletions(-)

-- 
1.7.4.1


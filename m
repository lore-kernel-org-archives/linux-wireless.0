Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:49195 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760000Ab3EXKSj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 06:18:39 -0400
Received: from mailout-de.gmx.net ([10.1.76.16]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0M94oF-1Ul08O1iIf-00CRPi for
 <linux-wireless@vger.kernel.org>; Fri, 24 May 2013 12:18:37 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 0/2] ath9k: STBC Rx monitoring
Date: Fri, 24 May 2013 12:18:29 +0200
Message-Id: <1369390711-992-1-git-send-email-linux@rempel-privat.de> (sfid-20130524_121842_137911_9B67EBC3)
In-Reply-To: <1368949136-6079-1-git-send-email-linux@rempel-privat.de>
References: <1368949136-6079-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

this are two remaining patches to allow STBC Rx monitoring
on ath9k devices.
This patches depend on currently applied:
[PATCH v4 1/3] mac80211: add STBC flag for radiotap

Oleksij Rempel (2):
  ath9k: remove useless flag conversation.
  ath9k: check for Rx-STBC flag and pass it to ieee80211

 drivers/net/wireless/ath/ath9k/ar9003_mac.c |  5 +++--
 drivers/net/wireless/ath/ath9k/init.c       |  9 +++++++--
 drivers/net/wireless/ath/ath9k/mac.c        | 16 ++++++++++++----
 drivers/net/wireless/ath/ath9k/mac.h        |  4 +++-
 drivers/net/wireless/ath/ath9k/recv.c       |  5 +----
 5 files changed, 26 insertions(+), 13 deletions(-)

-- 
1.8.1.2


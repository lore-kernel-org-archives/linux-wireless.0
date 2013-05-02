Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:53684 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab3EBILz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 04:11:55 -0400
Received: from mailout-de.gmx.net ([10.1.76.28]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MDSWR-1UoaoR1HnZ-00GqoV for
 <linux-wireless@vger.kernel.org>; Thu, 02 May 2013 10:11:54 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 0/2] work sync
Date: Thu,  2 May 2013 10:11:46 +0200
Message-Id: <1367482308-9882-1-git-send-email-linux@rempel-privat.de> (sfid-20130502_101200_805540_386C9DE9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

this patches currently pending for review or ack. Can please some one
do it untill i forgt them :)

Oleksij Rempel (2):
  ath9k_htc: add STBC TX support
  ath9k: remove useless flag conversation.

 drivers/net/wireless/ath/ath9k/ar9003_mac.c   |  5 +++--
 drivers/net/wireless/ath/ath9k/htc.h          |  2 ++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |  3 +++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |  4 ++++
 drivers/net/wireless/ath/ath9k/mac.c          | 11 +++++++----
 drivers/net/wireless/ath/ath9k/mac.h          |  1 +
 drivers/net/wireless/ath/ath9k/recv.c         |  5 +----
 7 files changed, 21 insertions(+), 10 deletions(-)

-- 
1.8.1.2


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:56984 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbaBZJED (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 04:04:03 -0500
Received: from ultralex.lan ([93.218.100.117]) by mail.gmx.com (mrgmx102) with
 ESMTPSA (Nemesis) id 0MbaS9-1WYsNA0nQr-00J3a1 for
 <linux-wireless@vger.kernel.org>; Wed, 26 Feb 2014 10:04:01 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linville@tuxdriver.com, sujith@msujith.org,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 0/3] ath9k|ath9k_htc cleanups
Date: Wed, 26 Feb 2014 10:03:42 +0100
Message-Id: <1393405425-16371-1-git-send-email-linux@rempel-privat.de> (sfid-20140226_100414_781730_9DBEBF9A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

so trivial fixups.
listen_interval was remove in ath9k_htc for long time,
so it is ok to remove it in ath9k too.
sleepduration directly depends on listen_interval - remove it too.

Oleksij Rempel (3):
  ath9k: remove unused listen_interval and sleepduration.
  ath9k_htc: remove unused variable sleepduration
  ath9k_htc: add function ath9k_regwrite_multi

 drivers/net/wireless/ath/ath9k/ath9k.h          |  1 -
 drivers/net/wireless/ath/ath9k/beacon.c         | 21 ++++------
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c | 22 ++++------
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   | 53 +++++++++++--------------
 4 files changed, 37 insertions(+), 60 deletions(-)

-- 
1.9.0


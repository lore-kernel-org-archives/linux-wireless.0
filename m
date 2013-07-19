Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62211 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab3GSSQ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jul 2013 14:16:27 -0400
Received: from zwerg.Speedport_W_723V_1_28_000 ([93.218.114.45]) by
 mail.gmx.com (mrgmx103) with ESMTPSA (Nemesis) id 0Ma2Lr-1Uhtvb17Lb-00Ln2a
 for <linux-wireless@vger.kernel.org>; Fri, 19 Jul 2013 20:16:25 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 0/2] ath9k_htc fixes, resend
Date: Fri, 19 Jul 2013 20:16:16 +0200
Message-Id: <1374257778-9758-1-git-send-email-linux@rempel-privat.de> (sfid-20130719_201630_212085_34D44187)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,
this patches needed to fix firmare/adapter hang issue on
reboot or module reload.

Oleksij Rempel (2):
  ath9k_htc: do some initial hardware configuration
  ath9k_htc: reboot firmware if it was loaded

 drivers/net/wireless/ath/ath9k/hif_usb.c      | 4 +++-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

-- 
1.8.1.2


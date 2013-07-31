Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:42466 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab3GaIsH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 04:48:07 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/2] ath10k: implement checksum offloading
Date: Wed, 31 Jul 2013 10:47:55 +0200
Message-ID: <1375260477-17030-1-git-send-email-michal.kazior@tieto.com> (sfid-20130731_104813_272019_4DB705FD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset adds tx and rx checksum offloading
to ath10k driver.

I don't have any hard numbers but I did observe a
consistently sligthly better performance on AP135
+ ath10k. Nothing ground breaking though.


Michal Kazior (2):
  ath10k: implement rx checksum offloading
  ath10k: implement tx checksum offloading

 drivers/net/wireless/ath/ath10k/htt_rx.c |   40 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/htt_tx.c |    2 ++
 drivers/net/wireless/ath/ath10k/mac.c    |    2 ++
 3 files changed, 44 insertions(+)

-- 
1.7.9.5


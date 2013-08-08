Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:63511 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933958Ab3HHIQ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 04:16:58 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/4] ath10k: fixes
Date: Thu, 8 Aug 2013 10:16:49 +0200
Message-ID: <1375949813-10969-1-git-send-email-michal.kazior@tieto.com> (sfid-20130808_101703_530643_BCF3BC96)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset contains some bugfixes and
improvements.

Michal Kazior (4):
  ath10k: fix HTT service setup
  ath10k: fix HTC endpoint worker starvation
  ath10k: implement 802.3 SNAP rx decap type A-MSDU handling
  ath10k: plug possible memory leak in WMI

 drivers/net/wireless/ath/ath10k/htc.c    |   25 +++++++++++++------------
 drivers/net/wireless/ath/ath10k/htc.h    |    3 ++-
 drivers/net/wireless/ath/ath10k/htt_rx.c |   12 ++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.c    |    1 +
 4 files changed, 26 insertions(+), 15 deletions(-)

-- 
1.7.9.5


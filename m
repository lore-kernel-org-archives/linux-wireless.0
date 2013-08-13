Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:65255 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab3HMF7o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 01:59:44 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/4] ath10k: fixes
Date: Tue, 13 Aug 2013 07:59:34 +0200
Message-ID: <1376373578-2180-1-git-send-email-michal.kazior@tieto.com> (sfid-20130813_075948_620568_7810F19F)
In-Reply-To: <1375949813-10969-1-git-send-email-michal.kazior@tieto.com>
References: <1375949813-10969-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset contains some bugfixes and
improvements.

v2:
 * fix indentation
 * use a comment instead of a no-op if clause


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


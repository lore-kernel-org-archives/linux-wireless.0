Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:44718 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734Ab3I0Oic (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Sep 2013 10:38:32 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/4] ath10k: clean ups
Date: Fri, 27 Sep 2013 16:38:22 +0200
Message-ID: <1380292706-3609-1-git-send-email-michal.kazior@tieto.com> (sfid-20130927_163835_740528_49AF62A7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

First two patches are non-functional changes.

The latter two should remove some overhead from TX
path and CE processing. Nothing extraordinary.


Michal Kazior (4):
  ath10k: split tid calculation from tx function
  ath10k: split vdev_id calculation from tx function
  ath10k: remove ce_sendlist_send
  ath10k: remove num_sends_allowed

 drivers/net/wireless/ath/ath10k/ce.c  |   35 ++++++------------------
 drivers/net/wireless/ath/ath10k/ce.h  |   16 +----------
 drivers/net/wireless/ath/ath10k/mac.c |   48 ++++++++++++++++++++-------------
 drivers/net/wireless/ath/ath10k/pci.c |   25 +++--------------
 drivers/net/wireless/ath/ath10k/pci.h |    3 ---
 5 files changed, 42 insertions(+), 85 deletions(-)

-- 
1.7.9.5


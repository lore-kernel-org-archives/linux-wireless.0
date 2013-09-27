Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:57016 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab3I0OgP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Sep 2013 10:36:15 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/2] ath10k: fixes
Date: Fri, 27 Sep 2013 16:36:05 +0200
Message-ID: <1380292567-2363-1-git-send-email-michal.kazior@tieto.com> (sfid-20130927_163621_063265_F763991F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

One throughput fix and one bug fix.

The bug fix addresses my oversight when reworking
HTC/WMI. I haven't seen the error yet but I'm
quite certain this should be fixed.


Michal Kazior (1):
  ath10k: fix scheduling while atomic bug

Sujith Manoharan (1):
  ath10k: Fix bug in max. VHT A-MPDU size

 drivers/net/wireless/ath/ath10k/core.h |    4 ++-
 drivers/net/wireless/ath/ath10k/mac.c  |   60 ++++++++++++++++++++++----------
 2 files changed, 45 insertions(+), 19 deletions(-)

-- 
1.7.9.5


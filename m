Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:54448 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933982Ab3HHIOQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 04:14:16 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/4] ath10k: cleanups
Date: Thu, 8 Aug 2013 10:14:06 +0200
Message-ID: <1375949650-9699-1-git-send-email-michal.kazior@tieto.com> (sfid-20130808_101422_425830_5CF999F7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset contains a few non-functional clean
ups.

Michal Kazior (4):
  ath10k: clean up monitor start code
  ath10k: use sizeof(*var) in kmalloc
  ath10k: clean up PCI completion states
  ath10k: print errcode when CE ring setup fails

 drivers/net/wireless/ath/ath10k/ce.c  |   15 +++++++++------
 drivers/net/wireless/ath/ath10k/mac.c |    3 ---
 drivers/net/wireless/ath/ath10k/pci.c |   24 ++++++++++++++++--------
 drivers/net/wireless/ath/ath10k/pci.h |   13 +++++++------
 4 files changed, 32 insertions(+), 23 deletions(-)

-- 
1.7.9.5


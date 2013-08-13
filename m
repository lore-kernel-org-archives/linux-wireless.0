Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:46116 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434Ab3HMFzF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 01:55:05 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/4] ath10k: cleanups
Date: Tue, 13 Aug 2013 07:54:53 +0200
Message-ID: <1376373297-32369-1-git-send-email-michal.kazior@tieto.com> (sfid-20130813_075511_402057_55F2A14F)
In-Reply-To: <1375949650-9699-1-git-send-email-michal.kazior@tieto.com>
References: <1375949650-9699-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset contains a few non-functional clean
ups.

v2:
 * fix line over 80 chars


Michal Kazior (4):
  ath10k: clean up monitor start code
  ath10k: use sizeof(*var) in kmalloc
  ath10k: clean up PCI completion states
  ath10k: print errcode when CE ring setup fails

 drivers/net/wireless/ath/ath10k/ce.c  |   15 +++++++++------
 drivers/net/wireless/ath/ath10k/mac.c |    3 ---
 drivers/net/wireless/ath/ath10k/pci.c |   25 +++++++++++++++++--------
 drivers/net/wireless/ath/ath10k/pci.h |   13 +++++++------
 4 files changed, 33 insertions(+), 23 deletions(-)

-- 
1.7.9.5


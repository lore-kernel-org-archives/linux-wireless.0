Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:63470 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab3HUGeW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 02:34:22 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/3] ath10k: fixes
Date: Wed, 21 Aug 2013 08:34:11 +0200
Message-ID: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com> (sfid-20130821_083425_791234_1CB46C9E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset addresses some throughput issues.


Pozdrawiam / Best regards,
Michal Kazior.


Michal Kazior (3):
  ath10k: make the workqueue multithreaded
  ath10k: move htt rx processing to worker
  ath10k: fix issues on non-preemptible systems

 drivers/net/wireless/ath/ath10k/core.c   |    4 ++-
 drivers/net/wireless/ath/ath10k/core.h   |    7 ++++
 drivers/net/wireless/ath/ath10k/htc.c    |    4 +++
 drivers/net/wireless/ath/ath10k/htt.h    |    3 ++
 drivers/net/wireless/ath/ath10k/htt_rx.c |   58 ++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/wmi.c    |    4 +++
 6 files changed, 72 insertions(+), 8 deletions(-)

-- 
1.7.9.5


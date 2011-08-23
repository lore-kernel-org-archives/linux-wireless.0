Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30435 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab1HWIQ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 04:16:58 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/7] ath6kl: patches upto 2011-08-23
Date: Tue, 23 Aug 2011 11:16:39 +0300
Message-ID: <1314087406-29188-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110823_101709_604566_43667AD3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

here are few patches I have applied to ath6kl tree. I will send
a merge request later, maybe next week or so.

>From now on we will send patches first to the mailing list for review
and only then I will apply them to the tree.

Kalle

Kalle Valo (1):
  ath6kl: implement suspend support

Vasanthakumar Thiagarajan (6):
  ath6kl: Release ar->lock right afer updating net_stats in ath6kl_rx()
  ath6kl: Minor cleanup in min_hdr_len computation
  ath6kl: Cleanup ath6kl_wmi_data_hdr_remove()
  ath6kl: Fix bug in computing AMSU subframe padding
  ath6kl: Fix buffer alignment for scatter-gather I/O
  ath6kl: Fix system freeze under heavy data load

 drivers/net/wireless/ath/ath6kl/cfg80211.c |   14 ++++++++++
 drivers/net/wireless/ath/ath6kl/core.h     |    4 +++
 drivers/net/wireless/ath/ath6kl/hif-ops.h  |    5 ++++
 drivers/net/wireless/ath/ath6kl/hif.h      |    1 +
 drivers/net/wireless/ath/ath6kl/htc.c      |   14 ++++++++++
 drivers/net/wireless/ath/ath6kl/init.c     |    2 +-
 drivers/net/wireless/ath/ath6kl/main.c     |   37 +++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath6kl/sdio.c     |   36 +++++++++++++++++++-------
 drivers/net/wireless/ath/ath6kl/txrx.c     |   18 +++++++------
 drivers/net/wireless/ath/ath6kl/wmi.c      |   10 -------
 drivers/net/wireless/ath/ath6kl/wmi.h      |    1 -
 11 files changed, 111 insertions(+), 31 deletions(-)


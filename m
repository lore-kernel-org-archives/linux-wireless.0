Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:47820 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbbFGN4g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2015 09:56:36 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 0/6] wil6210 patches
Date: Sun,  7 Jun 2015 16:56:25 +0300
Message-Id: <1433685391-9026-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150607_155646_382375_E4332061)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Small fixes here and there; save for hidden SSID

Hamad Kadmany (1):
  wil6210: Support hidden SSID

Vladimir Kondratiev (5):
  wil6210: modparam for bcast ring size
  wil6210: add NIC memory region mac_rgf_ext
  wil6210: add per-MCS Rx stats
  wil6210: platform hooks for modile init/exit
  wil6210: reorder init sequence

 drivers/net/wireless/ath/wil6210/cfg80211.c     | 46 +++++++++++-
 drivers/net/wireless/ath/wil6210/debugfs.c      |  8 +-
 drivers/net/wireless/ath/wil6210/main.c         |  2 +
 drivers/net/wireless/ath/wil6210/netdev.c       |  3 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c     | 99 ++++++++++++++++---------
 drivers/net/wireless/ath/wil6210/txrx.c         |  2 +
 drivers/net/wireless/ath/wil6210/wil6210.h      |  9 ++-
 drivers/net/wireless/ath/wil6210/wil_platform.c | 14 +++-
 drivers/net/wireless/ath/wil6210/wil_platform.h |  3 +
 drivers/net/wireless/ath/wil6210/wmi.c          |  5 +-
 drivers/net/wireless/ath/wil6210/wmi.h          | 10 ++-
 11 files changed, 153 insertions(+), 48 deletions(-)

-- 
2.1.4


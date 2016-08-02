Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24102 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932497AbcHBLp0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 07:45:26 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 0/8] wil6210 pathches
Date: Tue,  2 Aug 2016 14:42:04 +0300
Message-Id: <1470138132-18071-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160802_134542_604103_3D079927)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following set of patches include wil6210 bug fixes

Lazar Alexei (1):
  wil6210: Fix driver down flow

Lior David (2):
  wil6210: change HALP logging category to IRQ
  wil6210: fix wiphy registration sequence

Maya Erez (5):
  wil6210: align to latest auto generated wmi.h
  wil6210: fix HALP handling in case of HALP vote time-out
  wil6210: support rx key setting for all TIDs
  wil6210: fix stop p2p device handling
  wil6210: prevent usage of incorrect TX hwtail

 drivers/net/wireless/ath/wil6210/cfg80211.c  | 148 ++++---
 drivers/net/wireless/ath/wil6210/interrupt.c |  15 +-
 drivers/net/wireless/ath/wil6210/main.c      |  54 +--
 drivers/net/wireless/ath/wil6210/netdev.c    |  32 +-
 drivers/net/wireless/ath/wil6210/p2p.c       |  46 ++
 drivers/net/wireless/ath/wil6210/pcie_bus.c  |   5 +-
 drivers/net/wireless/ath/wil6210/txrx.c      |   9 +-
 drivers/net/wireless/ath/wil6210/wil6210.h   |   2 +
 drivers/net/wireless/ath/wil6210/wmi.h       | 640 +++++++++++++++++++++++----
 9 files changed, 768 insertions(+), 183 deletions(-)

-- 
1.9.1


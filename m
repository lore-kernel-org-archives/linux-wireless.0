Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27539 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757732AbcDELYN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 07:24:13 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 0/7] wil6210 patches
Date: Tue,  5 Apr 2016 14:24:00 +0300
Message-Id: <1459855447-17413-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160405_132433_803454_5303A545)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Various of wil6210 fixes

Lior David (1):
  wil6210: support regular scan on P2P_DEVICE interface

Maya Erez (6):
  wil6210: add function name to wil log macros
  wil6210: change RX_HTRSH interrupt print level to debug
  wil6210: print debug message when transmitting while disconnected
  wil6210: unmask RX_HTRSH interrupt only when connected
  wil6210: prevent deep sleep of 60G device in critical paths
  wil6210: add support for device led configuration

 drivers/net/wireless/ath/wil6210/cfg80211.c  |   5 +-
 drivers/net/wireless/ath/wil6210/debug.c     |  23 ++++-
 drivers/net/wireless/ath/wil6210/debugfs.c   | 137 +++++++++++++++++++++++++--
 drivers/net/wireless/ath/wil6210/interrupt.c |  93 ++++++++++++++----
 drivers/net/wireless/ath/wil6210/main.c      |  95 ++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/p2p.c       |   6 ++
 drivers/net/wireless/ath/wil6210/txrx.c      |   2 +-
 drivers/net/wireless/ath/wil6210/wil6210.h   |  84 ++++++++++++++--
 drivers/net/wireless/ath/wil6210/wmi.c       |  97 ++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/wmi.h       |  61 ++++++++++++
 10 files changed, 551 insertions(+), 52 deletions(-)

-- 
1.8.5.2


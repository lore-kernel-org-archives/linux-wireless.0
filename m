Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:34195 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbbLLNWt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2015 08:22:49 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 0/2] wil6210 patches
Date: Sat, 12 Dec 2015 15:22:43 +0200
Message-Id: <1449926565-888-1-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20151212_142258_212292_F48AA6AA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Those patches fix wil6210 issue and add support for platform specific recovery after FW crash

Hamad Kadmany (1):
  wil6210: fix kernel OOPS when stopping interface during Rx traffic

Maya Erez (1):
  wil6210: support for platform specific crash recovery

 drivers/net/wireless/ath/wil6210/interrupt.c      |  8 +++--
 drivers/net/wireless/ath/wil6210/pcie_bus.c       | 30 ++++++++++++++++--
 drivers/net/wireless/ath/wil6210/rx_reorder.c     | 12 ++++++-
 drivers/net/wireless/ath/wil6210/wil6210.h        |  1 +
 drivers/net/wireless/ath/wil6210/wil_crash_dump.c |  3 +-
 drivers/net/wireless/ath/wil6210/wil_platform.c   |  3 +-
 drivers/net/wireless/ath/wil6210/wil_platform.h   | 38 +++++++++++++++++++++--
 7 files changed, 84 insertions(+), 11 deletions(-)

-- 
1.8.5.2


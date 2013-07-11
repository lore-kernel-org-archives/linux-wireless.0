Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21465 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab3GKPDx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 11:03:53 -0400
Cc: Kirshenbaum Erez <erezk@wilocity.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 0/5] wil6210 updates - modified
Date: Thu, 11 Jul 2013 18:03:36 +0300
Message-ID: <1373555021-11763-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130711_170429_375981_EE97EFDD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Please ignore previous submission titled "[PATCH 0/3] wil6210 updates"
I found better solution for one of patches there. To avoid mis-interpretation,
resending all relevant patches. It is:

- Sync with latest firmware updates
- simple bug fixes and some optimization, all for data path
- prepare for various offloads - WIP by Erez

Vladimir Kondratiev (5):
  wil6210: Align WMI header with latest FW
  wil6210: fix wrong index in wil_vring_free
  wil6210: Optimize Tx completion
  wil6210: Introduce struct for sw context
  wil6210: fix subtle race in wil_tx_vring

 drivers/net/wireless/ath/wil6210/debugfs.c |  4 +-
 drivers/net/wireless/ath/wil6210/trace.h   | 22 +++++----
 drivers/net/wireless/ath/wil6210/txrx.c    | 79 +++++++++++++++++-------------
 drivers/net/wireless/ath/wil6210/wil6210.h | 27 ++++++++--
 drivers/net/wireless/ath/wil6210/wmi.c     | 14 ++++--
 5 files changed, 92 insertions(+), 54 deletions(-)

-- 
1.8.1.2


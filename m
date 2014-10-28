Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:33251 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaJ1Oux (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 10:50:53 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 0/5] wil6210 updates
Date: Tue, 28 Oct 2014 16:50:05 +0200
Message-ID: <1414507810-23141-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141028_155055_997392_BB2D5369)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

minor fixes, except for the last patch that adds support
for the maximum MTU up to 7920, as by the 802.11ad spec

Vladimir Kondratiev (5):
  wil6210: do not attempt FW recovery if interface is down
  wil6210: reset flow updates
  wil6210: prevent double disconnect command issuing
  wil6210: improve dmesg for fw error handling
  wil6210: Add support for large packets

 drivers/net/wireless/ath/wil6210/cfg80211.c |  2 +-
 drivers/net/wireless/ath/wil6210/main.c     | 95 ++++++++++++++++++++++++-----
 drivers/net/wireless/ath/wil6210/netdev.c   |  2 +-
 drivers/net/wireless/ath/wil6210/txrx.c     |  7 ++-
 drivers/net/wireless/ath/wil6210/txrx.h     |  4 +-
 drivers/net/wireless/ath/wil6210/wil6210.h  | 10 ++-
 drivers/net/wireless/ath/wil6210/wmi.c      |  4 +-
 7 files changed, 99 insertions(+), 25 deletions(-)

-- 
2.1.0


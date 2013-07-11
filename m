Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15046 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab3GKHMV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 03:12:21 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 0/3] wil6210 updates
Date: Thu, 11 Jul 2013 10:12:06 +0300
Message-ID: <1373526729-10908-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130711_091229_356004_207AEC1C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sync with latest firmware updates;
couple of simple bug fixes

Vladimir Kondratiev (3):
  wil6210: Align WMI header with latest FW
  wil6210: fix wrong index in wil_vring_free
  wil6210: write modified HW descriptor back

 drivers/net/wireless/ath/wil6210/trace.h   | 22 +++++++++++++---------
 drivers/net/wireless/ath/wil6210/txrx.c    |  3 ++-
 drivers/net/wireless/ath/wil6210/wil6210.h | 17 ++++++++++++++---
 drivers/net/wireless/ath/wil6210/wmi.c     | 14 +++++++++-----
 4 files changed, 38 insertions(+), 18 deletions(-)

-- 
1.8.1.2


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:56179 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab3FIGNJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jun 2013 02:13:09 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 0/6] wil6210 patches
Date: Sun, 9 Jun 2013 09:12:49 +0300
Message-ID: <1370758375-16867-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130609_081313_771326_9B526785)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Next collection of patches. Fixed secure AP, in "Derive IE's for AP" and
"fix timeout for start_pcp"; kernel warnings in secure AP flow taken care in
"Send EAPOL frames using normal Tx queue"
Crash in recent firmwares fixed by "Init Rx vring right after reset"

Vladimir Kondratiev (6):
  wil6210: fix timeout for start_pcp
  wil6210: map more FW memory
  wil6210: improve frame type reporting
  wil6210: Derive IE's for AP
  wil6210: Send EAPOL frames using normal Tx queue
  wil6210: Init Rx vring right after reset

 drivers/net/wireless/ath/wil6210/cfg80211.c | 34 +++++++++++++++++++--
 drivers/net/wireless/ath/wil6210/main.c     |  8 +++--
 drivers/net/wireless/ath/wil6210/txrx.c     | 20 ++++++------
 drivers/net/wireless/ath/wil6210/wil6210.h  |  1 -
 drivers/net/wireless/ath/wil6210/wmi.c      | 47 ++++++-----------------------
 5 files changed, 55 insertions(+), 55 deletions(-)

-- 
1.8.1.2


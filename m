Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52504 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933730Ab3E1MSG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 08:18:06 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 0/2] wil6210: fix for wdev->sme_state
Date: Tue, 28 May 2013 15:17:51 +0300
Message-ID: <1369743473-7243-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130528_141810_449300_CB490EF4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here goes patch that Johannes asked for, where wil6210 stop using
wdev->sme_state. Also, included is small patch fixing wrong channel
when starting AP

Vladimir Kondratiev (2):
  wil6210: channel off by 1
  wil6210: Don't use wdev->sme_state

 drivers/net/wireless/ath/wil6210/cfg80211.c |  4 ++++
 drivers/net/wireless/ath/wil6210/main.c     | 17 ++++++-----------
 drivers/net/wireless/ath/wil6210/wil6210.h  |  1 +
 drivers/net/wireless/ath/wil6210/wmi.c      |  5 +++--
 4 files changed, 14 insertions(+), 13 deletions(-)

-- 
1.8.1.2


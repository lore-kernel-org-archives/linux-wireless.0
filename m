Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27085 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab3FWKAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jun 2013 06:00:37 -0400
Cc: Kirshenbaum Erez <erezk@wilocity.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 0/2] wil6210: Tx path improvements
Date: Sun, 23 Jun 2013 12:59:33 +0300
Message-ID: <1371981575-14395-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130623_120042_251510_E758BCDC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Couple of patches from Erez, addressing Tx path

Kirshenbaum Erez (2):
  wil6210: set vring index for all descriptors
  wil6210: add HW write-back option in TX descriptor

 drivers/net/wireless/ath/wil6210/txrx.c | 12 ++++++------
 drivers/net/wireless/ath/wil6210/txrx.h |  4 ++++
 2 files changed, 10 insertions(+), 6 deletions(-)

-- 
1.8.1.2


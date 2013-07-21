Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:35221 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab3GUIf7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jul 2013 04:35:59 -0400
Cc: Kirshenbaum Erez <erezk@wilocity.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	<wil6210@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 0/2] wil6210 checksum offload
Date: Sun, 21 Jul 2013 11:34:35 +0300
Message-ID: <1374395677-16751-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130721_103605_432193_732F18A9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Next ready for integration patches. This time, introduce checksum offload
by Erez. Other patch is pre-requisite for checksum patch, and for more
offload patches that are coming.

Kirshenbaum Erez (1):
  wil6210: Enable TCP/UDP checksum HW offload

Vladimir Kondratiev (1):
  wil6210: fix error path in wil_tx_vring

 drivers/net/wireless/ath/wil6210/netdev.c |  2 +
 drivers/net/wireless/ath/wil6210/txrx.c   | 83 +++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/wil6210/txrx.h   | 20 +++++++-
 drivers/net/wireless/ath/wil6210/wmi.c    |  6 +++
 4 files changed, 105 insertions(+), 6 deletions(-)

-- 
1.8.1.2


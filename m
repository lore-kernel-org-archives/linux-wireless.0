Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45389 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaGNGvG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 02:51:06 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 0/7] wil6210 assorted patches
Date: Mon, 14 Jul 2014 09:49:36 +0300
Message-ID: <1405320583-5775-1-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140714_085111_046093_9DCD70B6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Collection of misc patches

Vladimir Kondratiev (7):
  wil6210: support for "sparrow" hardware
  wil6210: export FW/HW versions through debugfs
  wil6210: fix double definition of 'ctx'
  wil6210: fix memory leak on error path in wil_write_file_rxon()
  wil6210: use same mapping table for FW addr translation and debugfs
  wil6210: map RGF_USER_USAGE_1 on the debugfs
  wil6210: add new register region for AGC table

 drivers/net/wireless/ath/wil6210/debugfs.c  |   58 +++++++++++++-------------
 drivers/net/wireless/ath/wil6210/main.c     |   42 ++++++++++++++++----
 drivers/net/wireless/ath/wil6210/pcie_bus.c |   22 +++++++++-
 drivers/net/wireless/ath/wil6210/txrx.c     |    6 ++-
 drivers/net/wireless/ath/wil6210/wil6210.h  |   26 +++++++++---
 drivers/net/wireless/ath/wil6210/wmi.c      |   21 +++++-----
 6 files changed, 116 insertions(+), 59 deletions(-)

-- 
1.7.6


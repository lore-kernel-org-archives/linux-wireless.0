Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4659 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaJAMFt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 08:05:49 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 0/2] wil6210 patches
Date: Wed, 1 Oct 2014 15:05:23 +0300
Message-ID: <1412165125-30435-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141001_140554_036058_838C2A6C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2 new features:
- IOCTL API for the card memory access,
- manual FW recovery, to allow FW dump and other debug

Vladimir Kondratiev (2):
  wil6210: manual FW error recovery mode
  wil6210: atomic I/O for the card memory

 MAINTAINERS                                 |   1 +
 drivers/net/wireless/ath/wil6210/Makefile   |   1 +
 drivers/net/wireless/ath/wil6210/cfg80211.c |   4 +
 drivers/net/wireless/ath/wil6210/debugfs.c  |  67 +++++++++++
 drivers/net/wireless/ath/wil6210/ioctl.c    | 173 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/main.c     |  46 ++++++--
 drivers/net/wireless/ath/wil6210/netdev.c   |  12 ++
 drivers/net/wireless/ath/wil6210/wil6210.h  |  14 ++-
 drivers/net/wireless/ath/wil6210/wmi.c      |   1 +
 include/uapi/linux/wil6210_uapi.h           |  88 ++++++++++++++
 10 files changed, 398 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/ioctl.c
 create mode 100644 include/uapi/linux/wil6210_uapi.h

-- 
1.9.1


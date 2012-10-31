Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:4308 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933109Ab2JaQhI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 12:37:08 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v5 0/2] driver for 60g Wilocity chip wil6210
Date: Wed, 31 Oct 2012 18:36:55 +0200
Message-ID: <1351701417-3140-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20121031_173712_855322_DB6BDAE2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please, disregard [PATCH v4]. Use v5 instead.

Fixed stupid mistake: interrupt clear code was swapped between #ifdef branches.

Vladimir Kondratiev (2):
  wireless: Driver for 60GHz card wil6210
  wireless: integrate wil6210 driver into build structure

 drivers/net/wireless/ath/Kconfig             |    8 +-
 drivers/net/wireless/ath/Makefile            |    1 +
 drivers/net/wireless/ath/ar5523/Kconfig      |    1 +
 drivers/net/wireless/ath/ath5k/Kconfig       |    1 +
 drivers/net/wireless/ath/ath6kl/Kconfig      |    1 +
 drivers/net/wireless/ath/ath9k/Kconfig       |    1 +
 drivers/net/wireless/ath/carl9170/Kconfig    |    1 +
 drivers/net/wireless/ath/wil6210/Kconfig     |   30 +
 drivers/net/wireless/ath/wil6210/Makefile    |   15 +
 drivers/net/wireless/ath/wil6210/cfg80211.c  |  821 ++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/debugfs.c   |  506 ++++++++++++++
 drivers/net/wireless/ath/wil6210/interrupt.c |  342 +++++++++
 drivers/net/wireless/ath/wil6210/main.c      |  400 +++++++++++
 drivers/net/wireless/ath/wil6210/netdev.c    |  159 +++++
 drivers/net/wireless/ath/wil6210/pcie_bus.c  |  239 +++++++
 drivers/net/wireless/ath/wil6210/sysfs.c     |  134 ++++
 drivers/net/wireless/ath/wil6210/txrx.c      |  821 ++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx.h      |  352 ++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h   |  370 ++++++++++
 drivers/net/wireless/ath/wil6210/wmi.c       |  964 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/wmi.h       |  928 +++++++++++++++++++++++++
 21 files changed, 6093 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/Kconfig
 create mode 100644 drivers/net/wireless/ath/wil6210/Makefile
 create mode 100644 drivers/net/wireless/ath/wil6210/cfg80211.c
 create mode 100644 drivers/net/wireless/ath/wil6210/debugfs.c
 create mode 100644 drivers/net/wireless/ath/wil6210/interrupt.c
 create mode 100644 drivers/net/wireless/ath/wil6210/main.c
 create mode 100644 drivers/net/wireless/ath/wil6210/netdev.c
 create mode 100644 drivers/net/wireless/ath/wil6210/pcie_bus.c
 create mode 100644 drivers/net/wireless/ath/wil6210/sysfs.c
 create mode 100644 drivers/net/wireless/ath/wil6210/txrx.c
 create mode 100644 drivers/net/wireless/ath/wil6210/txrx.h
 create mode 100644 drivers/net/wireless/ath/wil6210/wil6210.h
 create mode 100644 drivers/net/wireless/ath/wil6210/wmi.c
 create mode 100644 drivers/net/wireless/ath/wil6210/wmi.h

-- 
1.7.10.4


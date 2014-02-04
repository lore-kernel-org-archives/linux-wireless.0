Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:36036 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbaBDDIc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 22:08:32 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 0/3] ath9k patches
Date: Tue,  4 Feb 2014 08:37:51 +0530
Message-Id: <1391483274-20331-1-git-send-email-sujith@msujith.org> (sfid-20140204_040835_875780_FEEFA924)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Hi,

Pending patches for ath9k, rebased over 3.14.0-rc1.

Sujith

Sujith Manoharan (3):
  ath9k: Fix build error on ARM
  ath9k: Do not support PowerSave by default
  ath9k: Fix TX power calculation

 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 4 ++++
 drivers/net/wireless/ath/ath9k/hw.c            | 5 ++---
 drivers/net/wireless/ath/ath9k/init.c          | 8 +++++++-
 3 files changed, 13 insertions(+), 4 deletions(-)

-- 
1.8.5.3


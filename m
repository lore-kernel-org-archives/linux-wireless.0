Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51450 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759026Ab2FUSad (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 14:30:33 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 0/3] ath9k: Fix smatch warnings
Date: Fri, 22 Jun 2012 00:01:29 +0530
Message-ID: <1340303492-30947-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120621_203035_809858_EADBCB0A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here is the another set of smatch warning fixes.
Now ath9k is smatch warning free code :)

Rajkumar Manoharan (3):
  ath9k_hw: fix buffer overflow smatch warning
  ath9k_hw: fix smatch warnings in spur_mitigate
  ath9k: fix 'side effect in macro' smatch warning

 drivers/net/wireless/ath/ath9k/ar5008_phy.c   | 7 ++++---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c   | 9 +++------
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 2 +-
 drivers/net/wireless/ath/ath9k/btcoex.c       | 2 +-
 drivers/net/wireless/ath/ath9k/main.c         | 9 +++++----
 5 files changed, 14 insertions(+), 15 deletions(-)

-- 
1.7.11


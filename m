Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:59715 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab3HGHDJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 03:03:09 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 0/2] Antenna diversity fixes
Date: Wed,  7 Aug 2013 12:29:26 +0530
Message-Id: <1375858768-24655-1-git-send-email-sujith@msujith.org> (sfid-20130807_090315_736673_D9D15C81)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Hi,

Antenna diversity support for WLAN/BT combo cards WB195 and WB225
is fairly complete. WB335, which is based on AR9565 requires more
fixes.

More information is here:
http://wireless.kernel.org/en/users/Drivers/ath9k/antennadiversity

Sujith

Sujith Manoharan (2):
  ath9k: Fix BTCOEX usage for RX diversity
  ath9k: Run the LNA combining algorithm properly

 drivers/net/wireless/ath/ath9k/init.c |  4 +--
 drivers/net/wireless/ath/ath9k/recv.c | 46 ++++++++++++++++++++++-------------
 2 files changed, 31 insertions(+), 19 deletions(-)

-- 
1.8.3.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:41713 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbbCIIq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 04:46:26 -0400
Received: from [117.207.78.0] (port=10150 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YUtKT-0033Ry-5U
	for linux-wireless@vger.kernel.org; Mon, 09 Mar 2015 04:46:25 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] ath9k patches
Date: Mon,  9 Mar 2015 14:20:05 +0530
Message-Id: <1425891010-21522-1-git-send-email-sujith@msujith.org> (sfid-20150309_094637_578959_6136FFF0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

For -next.

Sujith Manoharan (5):
  ath9k: Add PCIE powersave macros
  ath9k: Fix PLL powersave for AR9485
  ath9k: Initialize pll_pwrsave for AR9462/AR9565
  ath9k: Check allowed PCIE powersave configuration
  ath9k: Fix RTT chainmask usage

 drivers/net/wireless/ath/ath9k/ar9003_hw.c  | 83 +++++++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/ar9003_rtt.c |  6 +--
 drivers/net/wireless/ath/ath9k/hw.c         |  3 ++
 drivers/net/wireless/ath/ath9k/hw.h         |  8 ++-
 drivers/net/wireless/ath/ath9k/init.c       |  9 +++-
 5 files changed, 83 insertions(+), 26 deletions(-)

-- 
2.3.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:47030 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbaIEEUi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 00:20:38 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 0/3] ath9k patches
Date: Fri,  5 Sep 2014 09:50:54 +0530
Message-Id: <1409890857-6276-1-git-send-email-sujith@msujith.org> (sfid-20140905_062043_999453_FE32F5F6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

A few more MCC fixes for 3.18.

Sujith Manoharan (3):
  ath9k: Use a subroutine to assign HW queues
  ath9k: Fix offchannel operation
  ath9k: Fix MCC scanning

 drivers/net/wireless/ath/ath9k/ath9k.h   |  1 +
 drivers/net/wireless/ath/ath9k/channel.c |  8 +++++++-
 drivers/net/wireless/ath/ath9k/init.c    |  2 +-
 drivers/net/wireless/ath/ath9k/main.c    | 33 ++++++++++++++++----------------
 4 files changed, 26 insertions(+), 18 deletions(-)

-- 
2.1.0


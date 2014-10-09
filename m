Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:38567 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaJIIME (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 04:12:04 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 0/5] ath9k patches
Date: Thu,  9 Oct 2014 13:42:47 +0530
Message-Id: <1412842372-17628-1-git-send-email-sujith@msujith.org> (sfid-20141009_101215_379487_95690D4B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

MCC fixes for -next.

Sujith Manoharan (5):
  ath9k: Clear NoA schedule properly
  ath9k: Use configurable timeout for flush
  ath9k: Fix MCC flush timeout
  ath9k: Fix offchannel flush timeout
  ath9k: Check for pending frames properly

 drivers/net/wireless/ath/ath9k/ath9k.h   |  4 ++-
 drivers/net/wireless/ath/ath9k/channel.c | 57 ++++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/main.c    | 30 ++++++++++++-----
 3 files changed, 79 insertions(+), 12 deletions(-)

-- 
2.1.2


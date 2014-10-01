Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:41150 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaJADEg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 23:04:36 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 0/5] ath9k patches
Date: Wed,  1 Oct 2014 08:34:51 +0530
Message-Id: <1412132696-22836-1-git-send-email-sujith@msujith.org> (sfid-20141001_050442_166631_F06461D2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

For -next.

Sujith Manoharan (5):
  ath: Add support for tracing
  ath9k: Print RoC expiration
  ath9k: Check pending frames properly
  ath9k: Fix pending frame check
  ath9k: Remove duplicate code

 drivers/net/wireless/ath/Kconfig         |  8 ++++
 drivers/net/wireless/ath/Makefile        |  4 ++
 drivers/net/wireless/ath/ath.h           |  1 +
 drivers/net/wireless/ath/ath9k/channel.c |  7 ++++
 drivers/net/wireless/ath/ath9k/main.c    | 18 +++-----
 drivers/net/wireless/ath/main.c          |  3 ++
 drivers/net/wireless/ath/trace.c         | 20 +++++++++
 drivers/net/wireless/ath/trace.h         | 71 ++++++++++++++++++++++++++++++++
 8 files changed, 119 insertions(+), 13 deletions(-)
 create mode 100644 drivers/net/wireless/ath/trace.c
 create mode 100644 drivers/net/wireless/ath/trace.h

-- 
2.1.1


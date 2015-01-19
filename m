Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:37564 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbbASCKq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2015 21:10:46 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@qca.qualcomm.com
Subject: [PATCH 0/6] ath9k patches
Date: Mon, 19 Jan 2015 07:43:12 +0530
Message-Id: <1421633598-4488-1-git-send-email-sujith@msujith.org> (sfid-20150119_031111_608106_7D249238)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

ath9k patches for -next.

Sujith Manoharan (6):
  ath9k: Update QCA953x initvals
  ath9k: Update AR955x initvals
  ath9k: Add a macro to identify PCOEM chips
  ath9k: Fix manual peak calibration initialization
  ath9k: Set correct peak detect threshold
  ath9k: Enable manual peak detect calibration

 drivers/net/wireless/ath/ath9k/ar9003_calib.c      | 61 +++++++++++++++++-----
 drivers/net/wireless/ath/ath9k/ar953x_initvals.h   |  4 +-
 .../net/wireless/ath/ath9k/ar955x_1p0_initvals.h   |  4 +-
 drivers/net/wireless/ath/ath9k/reg.h               |  3 ++
 4 files changed, 55 insertions(+), 17 deletions(-)

-- 
2.2.2


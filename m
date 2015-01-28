Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:56491 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbbA2Bsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2015 20:48:45 -0500
Received: from [117.199.141.188] (port=12173 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YGRcf-001zZ7-CR
	for linux-wireless@vger.kernel.org; Wed, 28 Jan 2015 07:21:30 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/6] ath9k patches
Date: Wed, 28 Jan 2015 17:54:20 +0530
Message-Id: <1422447866-19967-1-git-send-email-sujith@msujith.org> (sfid-20150129_032642_060014_60C05348)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

ath9k patches for -next.

v2 - Fix typo in patch "ath9k: Add a macro to identify PCOEM chips".

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


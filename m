Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:60237 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaJVGue (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 02:50:34 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 0/2] ath9k patches
Date: Wed, 22 Oct 2014 12:21:43 +0530
Message-Id: <1413960705-24211-1-git-send-email-sujith@msujith.org> (sfid-20141022_085038_025195_0CB327C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Initval updates for AR9580 and AR955x.

$ ./verify_checksums.sh 
ar955x-1p0     b98d3c01075feed8b7154f5bfa8f122268cbe3c7 pass
ar9580-1p0     c7c799f2a30aff70b2125ea06cef23d1529c38fa fail
+03f9364192c676aa398e7da84e31f9db33ae2da4        ar9580_1p0_baseband_postamble

An update in the baseband postamble is part of a larger
Noise Calibration fix.

Sujith

Sujith Manoharan (2):
  ath9k: Update AR9580 initvals
  ath9k: Update AR955x initvals

 .../net/wireless/ath/ath9k/ar955x_1p0_initvals.h   |   8 +-
 .../net/wireless/ath/ath9k/ar9580_1p0_initvals.h   | 144 ++++++++++++++++++++-
 2 files changed, 147 insertions(+), 5 deletions(-)

-- 
2.1.2


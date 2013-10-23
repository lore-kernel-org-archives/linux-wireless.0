Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:42092 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab3JWLFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Oct 2013 07:05:22 -0400
Received: by mail-ea0-f169.google.com with SMTP id k11so339905eaj.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Oct 2013 04:05:20 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/3] ath10k: tx power fixes
Date: Wed, 23 Oct 2013 04:02:12 -0700
Message-Id: <1382526135-3215-1-git-send-email-michal.kazior@tieto.com> (sfid-20131023_130526_447913_31542760)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset fixes power units used in ath10k and
also make it respect (user) configurable tx power.


Michal Kazior (3):
  ath10k: setup min channel power to a reasonable value
  ath10k: use proper tx power unit
  ath10k: respect power_level values

 drivers/net/wireless/ath/ath10k/mac.c | 44 +++++++++++++++++++++++++----------
 drivers/net/wireless/ath/ath10k/wmi.h |  3 ++-
 2 files changed, 34 insertions(+), 13 deletions(-)

-- 
1.8.4.rc3


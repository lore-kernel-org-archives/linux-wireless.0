Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:37022 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbaIYKod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2014 06:44:33 -0400
Received: by mail-we0-f180.google.com with SMTP id q59so595425wes.11
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2014 03:44:32 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/4] ath10k: fix/cleanup fw stats
Date: Thu, 25 Sep 2014 12:33:46 +0200
Message-Id: <1411641230-18785-1-git-send-email-michal.kazior@tieto.com> (sfid-20140925_124438_229807_1063D7FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This cleans up and fixes fw stats aggregation.


Michal Kazior (4):
  ath10k: split wmi stats parsing
  ath10k: rename fw_stats related stuff
  ath10k: request fw_stats once on open
  ath10k: fix fw stats processing

 drivers/net/wireless/ath/ath10k/core.h  |  26 +-
 drivers/net/wireless/ath/ath10k/debug.c | 476 ++++++++++++++++++--------------
 drivers/net/wireless/ath/ath10k/debug.h |   7 +-
 drivers/net/wireless/ath/ath10k/wmi.c   | 190 ++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h   |  24 +-
 5 files changed, 483 insertions(+), 240 deletions(-)

-- 
1.8.5.3


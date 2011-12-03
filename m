Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:63297 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab1LCDjj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 22:39:39 -0500
Received: by qadb15 with SMTP id b15so1643606qad.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Dec 2011 19:39:38 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH v4 0/4] Fix the way ANI is being handled for ar9100 and ar9340
Date: Fri,  2 Dec 2011 22:39:13 -0500
Message-Id: <1322883557-14120-1-git-send-email-mar.kolya@gmail.com> (sfid-20111203_043952_695262_B3F16602)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Resending patches after fixing compilation problem noted by Felix.

Nikolay Martynov (4):
  ath9k: trivial: cosmetic fix in calibration debug log
  ath9k: change calibration debug log to output all calibration types
  ath9k: use config.enable_ani to check if ani should be performed
  ath9k: enable ANI for ar9100 chips

 drivers/net/wireless/ath/ath9k/ar9002_calib.c |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    5 +++--
 drivers/net/wireless/ath/ath9k/hw.c           |    6 +++++-
 drivers/net/wireless/ath/ath9k/main.c         |   13 ++++++++-----
 5 files changed, 18 insertions(+), 10 deletions(-)

-- 
1.7.4.1


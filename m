Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:33057 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbaDIKHl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 06:07:41 -0400
Received: by mail-ee0-f54.google.com with SMTP id d49so1658705eek.41
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 03:07:39 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/4] ath10k: AP-related fixes
Date: Wed,  9 Apr 2014 12:01:21 +0200
Message-Id: <1397037685-7485-1-git-send-email-michal.kazior@tieto.com> (sfid-20140409_120751_716981_53E0B58B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is a bunch of fixes I've found while
investigating tx credit issues.

I've only experienced problem fixed by 4/4
firsthand. Other patches are preemptive fixes :-)


Michal Kazior (4):
  ath10k: make sure to not leak beacon dma mapping
  ath10k: make sure to not use invalid beacon pointer
  ath10k: prevent beacon memory leak
  ath10k: fix firmware recovery with ap interface

 drivers/net/wireless/ath/ath10k/mac.c | 16 ++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c |  3 +++
 2 files changed, 19 insertions(+)

-- 
1.8.5.3


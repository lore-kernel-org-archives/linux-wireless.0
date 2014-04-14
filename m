Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:62090 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaDNH0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 03:26:35 -0400
Received: by mail-ee0-f54.google.com with SMTP id d49so6219432eek.13
        for <linux-wireless@vger.kernel.org>; Mon, 14 Apr 2014 00:26:34 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 0/4] ath10k: AP-related fixes
Date: Mon, 14 Apr 2014 09:20:06 +0200
Message-Id: <1397460010-19153-1-git-send-email-michal.kazior@tieto.com> (sfid-20140414_092639_248695_90E3E44C)
In-Reply-To: <1397037685-7485-1-git-send-email-michal.kazior@tieto.com>
References: <1397037685-7485-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is a bunch of fixes I've found while
investigating tx credit issues.

I've only experienced problem fixed by 4/4
firsthand. Other patches are preemptive fixes :-)

v2:
 * minor tweaks

Michal Kazior (4):
  ath10k: make sure to not leak beacon dma mapping
  ath10k: make sure to not use invalid beacon pointer
  ath10k: prevent beacon memory leak
  ath10k: fix firmware recovery with ap interface

 drivers/net/wireless/ath/ath10k/mac.c | 16 ++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c |  2 ++
 2 files changed, 18 insertions(+)

-- 
1.8.5.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:34288 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbcCQJtA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 05:49:00 -0400
Received: by mail-lf0-f45.google.com with SMTP id e138so37058749lfe.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 02:48:59 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/2] ath10k: fix tx hangs
Date: Thu, 17 Mar 2016 10:51:03 +0100
Message-Id: <1458208265-16715-1-git-send-email-michal.kazior@tieto.com> (sfid-20160317_104904_570074_6D8A1C14)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

My recent wake-tx-queue/pull-push related patches
introduced a regression that can cause tx to hang
under certain circumstances.


Michal Kazior (2):
  ath10k: fix tx hang
  ath10k: fix pull-push tx threshold handling

 drivers/net/wireless/ath/ath10k/mac.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

-- 
2.1.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:45047 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbaEGNHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 09:07:12 -0400
Received: by mail-ee0-f44.google.com with SMTP id c41so740167eek.3
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 06:07:10 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, apenwarr@gmail.com,
	greearb@candelatech.com, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/2] ath10k: 2014-05-07 fixes
Date: Wed,  7 May 2014 14:33:24 +0200
Message-Id: <1399466006-5556-1-git-send-email-michal.kazior@tieto.com> (sfid-20140507_150717_252316_DCBFCD54)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

These 2 patches address kernel panics reported by
Avery recently. One of them was most likely
reported by Ben some time ago already.

I've never seen these panics myself. It'd be great
if you guys could give it a try and (assuming
you're capable of reproducing) see if it actually
helps.


Michal Kazior (2):
  ath10k: fix htt rx ring clean up
  ath10k: fix handling of wierd MSDU chaining cases

 drivers/net/wireless/ath/ath10k/htt_rx.c | 56 +++++++++++++++++++++++---------
 1 file changed, 40 insertions(+), 16 deletions(-)

-- 
1.8.5.3


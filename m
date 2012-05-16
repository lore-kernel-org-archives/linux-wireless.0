Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:41155 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966317Ab2EPDAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 23:00:10 -0400
Received: by lbgc1 with SMTP id c1so201147lbg.29
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 20:00:07 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] wlcore: a few sparse and compiler warning fixes
Date: Wed, 16 May 2012 05:59:58 +0300
Message-Id: <1337137200-32538-1-git-send-email-coelho@ti.com> (sfid-20120516_050015_987326_A146F9C7)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

These two patches fix the warning you reported to me and a few sparse
warnings that I just found.  Please take them directly into your tree
(ie. I won't send a separate pull for this).

Thanks and sorry for the trouble!

Cheers,
Luca.

Luciano Coelho (2):
  wlcore: fix pointer print out in wl1271_acx_set_rx_filter()
  wlcore: fix some sparse warnings due to missing static declaration

 drivers/net/wireless/ti/wlcore/acx.c  |    5 +++--
 drivers/net/wireless/ti/wlcore/main.c |    7 ++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

-- 
1.7.10


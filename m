Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:38659 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab1C2F0K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 01:26:10 -0400
Received: from mail.lockie.ca (dyn-dsl-lh-98-124-36-5.nexicom.net [98.124.36.5])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p2T5Q8rl025418
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 01:26:09 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 945971E037F
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 01:26:07 -0400 (EDT)
Message-ID: <4D916D55.3030008@lockie.ca>
Date: Tue, 29 Mar 2011 01:25:41 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: trace == bug?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


WARNING: at drivers/net/wireless/ath/ath9k/recv.c:534
ath_stoprecv+0xf3/0x100 [ath9k]()
Call Trace:
 [<ffffffff810353db>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffffa0b8b043>] ? ath_stoprecv+0xf3/0x100 [ath9k]
 [<ffffffffa0b879b3>] ? ath_set_channel+0xe3/0x280 [ath9k]
 [<ffffffffa0b87f9e>] ? ath9k_config+0x44e/0x6d0 [ath9k]
 [<ffffffffa009c320>] ? ieee80211_scan_work+0x0/0x580 [mac80211]
 [<ffffffffa009bd75>] ? __ieee80211_scan_completed_finish+0x15/0x90
[mac80211]
 [<ffffffffa009c320>] ? ieee80211_scan_work+0x0/0x580 [mac80211]
 [<ffffffff8104ae3b>] ? process_one_work+0xfb/0x3b0
 [<ffffffff8104b514>] ? worker_thread+0x144/0x3d0
 [<ffffffff81029050>] ? __wake_up_common+0x50/0x80
 [<ffffffff8104b3d0>] ? worker_thread+0x0/0x3d0
 [<ffffffff8104b3d0>] ? worker_thread+0x0/0x3d0
 [<ffffffff8104ecc6>] ? kthread+0x96/0xa0
 [<ffffffff81003014>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff8104ec30>] ? kthread+0x0/0xa0
 [<ffffffff81003010>] ? kernel_thread_helper+0x0/0x10
---[ end trace a8977d8ac5dc8425 ]---


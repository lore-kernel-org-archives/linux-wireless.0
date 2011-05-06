Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dell.nexicom.net ([216.168.96.13]:59872 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247Ab1EFVFY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 17:05:24 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-66-79-239-161.nexicom.net [66.79.239.161])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p46L5MSU001145
	for <linux-wireless@vger.kernel.org>; Fri, 6 May 2011 17:05:23 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id 1E4991E0183
	for <linux-wireless@vger.kernel.org>; Fri,  6 May 2011 17:05:22 -0400 (EDT)
Message-ID: <4DC462B1.9000305@lockie.ca> (sfid-20110506_230528_785993_457F8D01)
Date: Fri, 06 May 2011 17:05:53 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: kernel trace
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Does this mean anything to someone?
I'm not sure I can reproduce it.

-----------[ cut here ]------------
WARNING: at drivers/net/wireless/ath/ath9k/recv.c:534
ath_stoprecv+0xcf/0xef [ath9k]()
Hardware name: To Be Filled By O.E.M.
Modules linked in: ath9k mac80211 ath9k_common nvidia(P) ath9k_hw ath
cfg80211 [last unloaded: ath9k]
Pid: 12, comm: kworker/u:1 Tainted: P        W   2.6.38.5 #6
Call Trace:
 [<ffffffff8102bb86>] ? warn_slowpath_common+0x78/0x8c
 [<ffffffffa0aa109e>] ? ath_stoprecv+0xcf/0xef [ath9k]
 [<ffffffffa0a9e761>] ? ath_set_channel+0xaf/0x20d [ath9k]
 [<ffffffffa0a9ec98>] ? ath9k_config+0x3d9/0x4de [ath9k]
 [<ffffffffa0bb06e6>] ? ieee80211_scan_work+0x2eb/0x47f [mac80211]
 [<ffffffffa0bb03fb>] ? ieee80211_scan_work+0x0/0x47f [mac80211]
 [<ffffffff8103d30a>] ? process_one_work+0x20e/0x34e
 [<ffffffff8103d849>] ? worker_thread+0x1c9/0x340
 [<ffffffff810218c6>] ? __wake_up_common+0x41/0x78
 [<ffffffff8103d680>] ? worker_thread+0x0/0x340
 [<ffffffff8103d680>] ? worker_thread+0x0/0x340
 [<ffffffff810403cb>] ? kthread+0x7a/0x82
 [<ffffffff81002b54>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81040351>] ? kthread+0x0/0x82
 [<ffffffff81002b50>] ? kernel_thread_helper+0x0/0x10
---[ end trace 8afb370f7261c121 ]---


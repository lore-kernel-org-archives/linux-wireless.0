Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:60242 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186Ab1CTWGH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Mar 2011 18:06:07 -0400
Received: from mail.lockie.ca (dyn-dsl-lh-98-124-36-5.nexicom.net [98.124.36.5])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p2KM5t5Q018354
	for <linux-wireless@vger.kernel.org>; Sun, 20 Mar 2011 18:06:01 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id AB0B71E0426
	for <linux-wireless@vger.kernel.org>; Sun, 20 Mar 2011 18:05:54 -0400 (EDT)
Message-ID: <4D867A43.9020205@lockie.ca>
Date: Sun, 20 Mar 2011 18:05:55 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: kernel-2.6.38
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 17
ath9k 0000:02:09.0: PCI INT A -> Link[LNKB] -> GSI 17 (level, low) -> IRQ 17
nvidia: module license 'NVIDIA' taints kernel.
Disabling lock debugging due to kernel taint
irq 17: nobody cared (try booting with the "irqpoll" option)
Pid: 1138, comm: modprobe Tainted: P            2.6.38 #1
Call Trace:
 <IRQ>  [<ffffffff81054e0d>] ? __report_bad_irq+0x30/0x7d
 [<ffffffff81054f5f>] ? note_interrupt+0x105/0x172
 [<ffffffff8105587b>] ? handle_fasteoi_irq+0x98/0xbc
 [<ffffffff81004442>] ? handle_irq+0x17/0x1d
 [<ffffffff81003b2c>] ? do_IRQ+0x45/0xaa
 [<ffffffff8134d453>] ? ret_from_intr+0x0/0xe
 <EOI>  [<ffffffff811456e2>] ? __bitmap_weight+0x1d/0x61
 [<ffffffff810522ca>] ? load_module+0x1065/0x10ac
 [<ffffffff81052353>] ? sys_init_module+0x42/0x1d3
 [<ffffffff81001dfb>] ? system_call_fastpath+0x16/0x1b
handlers:
[<ffffffffa00c2d7f>] (ath_isr+0x0/0x1e1 [ath9k])
Disabling IRQ #17

ath: Failed to stop TX DMA in 100 msec after killing last frame
ath: Failed to stop TX DMA!
ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020
ath: Could not stop RX, we could be confusing the DMA engine when we
start RX up
------------[ cut here ]------------
WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536
ath_stoprecv+0xc5/0xd6 [ath9k]()
Hardware name: To Be Filled By O.E.M.
Modules linked in: nvidia(P) ath9k mac80211 ath9k_common ath9k_hw ath
cfg80211
Pid: 12, comm: kworker/u:1 Tainted: P            2.6.38 #1
Call Trace:
 [<ffffffff8102bb86>] ? warn_slowpath_common+0x78/0x8c
 [<ffffffffa00c5074>] ? ath_stoprecv+0xc5/0xd6 [ath9k]
 [<ffffffffa00c2743>] ? ath_set_channel+0xaf/0x20d [ath9k]
 [<ffffffffa00c2c7a>] ? ath9k_config+0x3d9/0x4de [ath9k]
 [<ffffffffa00906da>] ? ieee80211_scan_work+0x2eb/0x47f [mac80211]
 [<ffffffffa00903ef>] ? ieee80211_scan_work+0x0/0x47f [mac80211]
 [<ffffffff8103d25e>] ? process_one_work+0x20e/0x34e
 [<ffffffff8103d79d>] ? worker_thread+0x1c9/0x340
 [<ffffffff810218c6>] ? __wake_up_common+0x41/0x78
 [<ffffffff8103d5d4>] ? worker_thread+0x0/0x340
 [<ffffffff8103d5d4>] ? worker_thread+0x0/0x340
 [<ffffffff8104031b>] ? kthread+0x7a/0x82
 [<ffffffff81002b54>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff810402a1>] ? kthread+0x0/0x82
 [<ffffffff81002b50>] ? kernel_thread_helper+0x0/0x10
---[ end trace 2b4fd6ac45e0da09 ]---
ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020


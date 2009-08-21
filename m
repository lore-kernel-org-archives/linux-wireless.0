Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netsys.kaist.ac.kr ([143.248.239.50]:59709 "EHLO
	netsys.kaist.ac.kr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbZHUI0C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 04:26:02 -0400
Received: from JinsungLeePC (netsys30.kaist.ac.kr [143.248.239.70])
	by netsys.kaist.ac.kr (8.13.1/8.13.1) with ESMTP id n7L8OFX7022358
	for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2009 17:24:15 +0900
From: "Jinsung Lee" <ljs@netsys.kaist.ac.kr>
To: <linux-wireless@vger.kernel.org>
Subject: Implementing wireless testbed on Linux
Date: Fri, 21 Aug 2009 17:26:12 +0900
Message-ID: <029301ca2239$0ac9ad70$205d0850$@kaist.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, everyone.

I'm a Ph.D. student and I'm going to implement wireless testebed consisting
of more than 20 nodes using WLAN device on Linux.
Actually, there are a lot of devices and drivers in the world. I can't
follow all information as you know, which is very difficult job. 
So, I expect to borrow very valuable knowledge and experience from you.
Specifically, what I want to do is to set 802.11 MAC parameters such as
AIFS, CW, TxOp in per-packet basis in user-space.
In the case of using 802.11n chipset, which card and device driver should I
choose? At the same time, which version of Linux kernel should be
appropriate?
Is there any difference between pci and usb interfaces?
Definitely, all device and software should be stable and up-to-date.
Please let me know anything you know related to this issue.
I'm looking forward to your comments.
Thanks.

----
Jinsung Lee



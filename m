Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout6.freenet.de ([195.4.92.96]:42371 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576Ab1HWJHg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 05:07:36 -0400
Received: from [195.4.92.23] (helo=13.mx.freenet.de)
	by mout6.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #5)
	id 1QvmxK-0008Hc-N5
	for linux-wireless@vger.kernel.org; Tue, 23 Aug 2011 11:07:34 +0200
Received: from p4fde08c7.dip0.t-ipconnect.de ([79.222.8.199]:45436 helo=mail.maya.org)
	by 13.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #5)
	id 1QvmxK-0003Ie-FH
	for linux-wireless@vger.kernel.org; Tue, 23 Aug 2011 11:07:34 +0200
Received: from [192.168.1.6] (dualc.maya.org [192.168.1.6])
	by mail.maya.org (8.14.4/8.13.8) with ESMTP id p7N97VKV003197
	for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 11:07:31 +0200
Message-ID: <4E536DD8.6030308@01019freenet.de> (sfid-20110823_110740_240764_9C1D2E21)
Date: Tue, 23 Aug 2011 11:07:36 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [compat-wireless-3.1-rc1-1] rt2800usb crashes the machine
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

using rt2800usb with a Linksys WUSB600N v2 (rt3572) crashes the complete
machine (SMP, Core i5, linux 3.0) on unloading the module after using it
for a short period of time:
- 2 times netperf -t TCP_MAERTS -H host
- 2 times netperf -t TCP_STREAM -H host

The error message in /var/log/messages is:

phy0 -> rt2800_wait_wpdma_ready: Error - WPDMA TX/RX busy, aborting

After the crash, you have to hard reset the machine.


BTW:
The throughput to STA is about 4 MB/s.
The throughput from STA is about 1 _k_B/s


Kind regards,
Andreas

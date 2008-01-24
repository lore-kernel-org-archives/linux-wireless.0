Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from csmail.cs.nctu.edu.tw ([140.113.235.106]:59090 "EHLO
	csmail.cs.nctu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbYAXMEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 07:04:42 -0500
Received: from jacklu (r71906.cs.nctu.edu.tw [140.113.210.86])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by csmail.cs.nctu.edu.tw (Postfix) with ESMTP id E0DF545026
	for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2008 19:59:31 +0800 (CST)
From: "Jack" <kflu@cs.nctu.edu.tw>
To: <linux-wireless@vger.kernel.org>
Subject: Is it possible to receive packets without MAC address filtering?
Date: Thu, 24 Jan 2008 19:57:20 +0800
Message-ID: <000001c85e80$46d1ab70$d4750250$@nctu.edu.tw> (sfid-20080124_120447_565245_8D546CAB)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm planning to do a SoftMAC project such as the one based on Madwifi. My
platform is based on bcm43xx (Buffalo WLI2-PCI-G54S). I traced the b43
device driver for several days. I found that B43_MACCTL_KEEP_CTL and
B43_MACCTL_BEACPROMISC was set in monitor mode. So, I manually set these two
bits in the driver. However, it doesn't work like iwconfig the device into
monitor mode. I use Wireshark to verify it. I also tried to set
B43_MACCTL_PROMISC bit. It doesn't work either.

How can I receive the packets in station (managed) mode but behave like in
monitor mode? Or can I read the packets through PHY directly? Since I'm not
familiar with hardware and firmware, I'm afraid that I'm wasting time on an
impossible idea. If it is possible, would you please tell me which part of
code I should trace? Thank you!


Jack


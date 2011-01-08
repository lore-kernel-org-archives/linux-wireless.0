Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39680 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1AHAiU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 19:38:20 -0500
Received: by iyi12 with SMTP id 12so16244438iyi.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 16:38:19 -0800 (PST)
MIME-Version: 1.0
From: Jamie Kitson <jamie@kitten-x.com>
Date: Sat, 8 Jan 2011 00:37:59 +0000
Message-ID: <AANLkTikam0zcxe00UCT4BDQMmrJcPKf1Hbt6=PBokpga@mail.gmail.com>
Subject: Kernel Panic wlc_mac80211.c Line 6093
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I've received the following kernel panic twice in two days since I
started using the brcm80211 driver:

http://farm6.static.flickr.com/5202/5334637544_a0dacd5edd_b.jpg

I have a Dell M101z with:

03:00.0 Network controller: Broadcom Corporation BCM4313 802.11b/g/n
Wireless LAN Controller (rev 01)

I am running:

Linux jamie-laptop 2.6.36-ARCH #1 SMP PREEMPT Fri Dec 10 20:32:37 CET
2010 x86_64 AMD Athlon(tm) II Neo K325 Dual-Core Processor
AuthenticAMD GNU/Linux

Cheers, Jamie

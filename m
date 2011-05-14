Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from defaultvalue.org ([70.85.129.156]:44375 "EHLO defaultvalue.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab1ENRLk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 13:11:40 -0400
Received: from omen.defaultvalue.org (localhost [127.0.0.1])
	by defaultvalue.org (Postfix) with ESMTP id 85EE890D35
	for <linux-wireless@vger.kernel.org>; Sat, 14 May 2011 12:03:55 -0500 (CDT)
Received: from raven.defaultvalue.org (raven.defaultvalue.org [192.168.1.7])
	by omen.defaultvalue.org (Postfix) with ESMTP id 4A0CC5056B
	for <linux-wireless@vger.kernel.org>; Sat, 14 May 2011 12:01:50 -0500 (CDT)
From: Rob Browning <rlb@defaultvalue.org>
To: linux-wireless@vger.kernel.org
Subject: Slow receive with rtl8192cu (usb ew-7811Un)
Date: Sat, 14 May 2011 12:01:50 -0500
Message-ID: <87pqnl5i81.fsf@raven.defaultvalue.org> (sfid-20110514_191143_810479_6B3A2BAE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I'm seeing very slow receive rates (~63kb/s) with an EW-7811Un USB
adapter which appears to load the rtl8192cu driver.  Is that a known
problem?

I'm currently running the Debian 2.6.39-rc7-amd64 kernel from unstable;
I believe rc7 may be the first Debian kernel to work with this adapter.

I also needed to patch Debian's firmware-realtek package to include the
relevant firmware as detailed here:

  http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=625614.

With respect to the connection quality I see:

  Channel:1
  Frequency:2.412 GHz (Channel 1)
  Quality=65/70  Signal level=-45 dBm  

And during transfers "iw event -t" shows nothing other than the
occasional scan started/finished pair.

Thanks
-- 
Rob Browning
rlb @defaultvalue.org and @debian.org
GPG as of 2002-11-03 14DD 432F AE39 534D B592 F9A0 25C8 D377 8C7E 73A4

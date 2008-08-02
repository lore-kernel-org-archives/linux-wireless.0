Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:22454 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbYHBJnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 05:43:24 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1185689fkq.5
        for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 02:43:21 -0700 (PDT)
Message-ID: <48942C35.6020400@gmail.com> (sfid-20080802_114347_292858_03EB1EE3)
Date: Sat, 02 Aug 2008 12:43:17 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: [BUG] IWL3945: Led doesn't blink in monitor mode
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After fixing super annoying bug about garbage scan results,
I noticed smaller bug:

My wireless leds stop blinking if I enable monitor mode
(Note that this time this doesn't happen if I enable promisc mode)

Only module reload or recreation of wlan0 using iw  helps.
This is due to the fact that once card is put in monitor mode it stays 
there always.
(I will fix this bug when I have time)

But leds should work even in monitor mode.

Btw, do leds indicate RX activity or TX or both?

Best regards,
	Maxim Levitsky


PS:

I will soon buy a standalone wireless card (pci express)
Are iwlwifi based cards aviable?



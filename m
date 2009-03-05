Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:56410 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbZCEUcx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 15:32:53 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LfKFP-0004fF-FT
	for linux-wireless@vger.kernel.org; Thu, 05 Mar 2009 20:32:51 +0000
Received: from dslb-092-076-255-001.pools.arcor-ip.net ([92.76.255.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 20:32:51 +0000
Received: from feldmann_markus by dslb-092-076-255-001.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 20:32:51 +0000
To: linux-wireless@vger.kernel.org
From: Markus Feldmann <feldmann_markus@gmx.de>
Subject: Re: BCM4303 on HP zv5265ea
Date: Thu, 05 Mar 2009 21:32:43 +0100
Message-ID: <gopctb$rn2$1@ger.gmane.org> (sfid-20090305_213257_063893_4A7EDF7C)
References: <gohr71$48f$1@ger.gmane.org> <49AC742D.9030309@lwfinger.net> <gom4ke$vle$1@ger.gmane.org> <49AE9BDD.7070603@lwfinger.net> <gomq5f$n64$1@ger.gmane.org> <49AEF58E.30302@lwfinger.net> <gon99n$b1t$1@ger.gmane.org> <49B00306.8050000@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
In-Reply-To: <49B00306.8050000@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger schrieb:
> I can add a little more information. It turns out that I have one PCIe module
> that will work with b43legacy as it uses ucode5 firmware. I modified my system
> to load b43legacy, rather than b43, for this device. After I did that, the
> RFKILL switch works correctly, just as it does in b43.
> 
> From the above experiment, I conclude that the rfkill implementation in
> b43legacy is correct. Any problems that you are having are the result of some
> quirk in your hardware, therefore, none of us can debug it as we will not be
> able to reproduce the problem.
> 
> Does your RFKILL switch generate a keycode? You can test that by switching to
> console 1 (CTRL/ALT/F1), log in, run the command 'showkey', and operate the
> radio switch. On my system, I get a keycode of 238. BTW, use CTRL/ALT/F7 to get
> back to the X console.
Thank you for your help.

With the kernel version 2.6.28.X it doesn't produce
any keycode. I will try out the current developement
version in the next days and wrote the results here.
Ont this Laptop are 2 Operating Systems. Win XP and Debian Lenny.
On WIn Xp the wlan card works fine. So i think the hardware
is ok.

So please watch here again next week. I think i could fit up
the newest kernel version until next weekend.

Regards Markus


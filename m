Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:35736 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149AbZCGLl7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2009 06:41:59 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Lfuuh-0001f2-EE
	for linux-wireless@vger.kernel.org; Sat, 07 Mar 2009 11:41:55 +0000
Received: from 77-21-174-176-dynip.superkabel.de ([77.21.174.176])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 07 Mar 2009 11:41:55 +0000
Received: from feldmann_markus by 77-21-174-176-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 07 Mar 2009 11:41:55 +0000
To: linux-wireless@vger.kernel.org
From: feldmaus <feldmann_markus@gmx.de>
Subject: Re: BCM4303 on HP zv5265ea
Date: Sat, 07 Mar 2009 12:41:59 +0100
Message-ID: <gotmhr$d6v$1@ger.gmane.org> (sfid-20090307_124247_915999_0A3F97AD)
References: <gohr71$48f$1@ger.gmane.org> <49AC742D.9030309@lwfinger.net> <gom4ke$vle$1@ger.gmane.org> <49AE9BDD.7070603@lwfinger.net> <gomq5f$n64$1@ger.gmane.org> <49AEF58E.30302@lwfinger.net> <gon99n$b1t$1@ger.gmane.org> <49B00306.8050000@lwfinger.net> <gopctb$rn2$1@ger.gmane.org> <49B03A17.1070001@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
In-Reply-To: <49B03A17.1070001@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger schrieb:
> Markus Feldmann wrote:
>> With the kernel version 2.6.28.X it doesn't produce
>> any keycode. I will try out the current developement
>> version in the next days and wrote the results here.
>> Ont this Laptop are 2 Operating Systems. Win XP and Debian Lenny.
>> On WIn Xp the wlan card works fine. So i think the hardware
>> is ok.
> 
> The keycode is a function of the hardware, not the kernel. If you don't get one
> now, you will _NEVER_ get one. Your only hope is the hp_wmi driver. I cannot
> help you there.
Thanks for your endevours,

Yesterday i tried out the kernel 2.6.29.7 without
success. <showkey> doesn't show any keycode by pressing
my wlan button.

i will try to contact M a t t h e w_G a r r e t. :-)
Do you know where to get more information about developing
the <hp-wmi> driver ?
Is there anotherone developing this(hp-wmi) driver ?

Regards Markus


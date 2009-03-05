Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:47587 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbZCEBTA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2009 20:19:00 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Lf2Ej-0003B5-Aa
	for linux-wireless@vger.kernel.org; Thu, 05 Mar 2009 01:18:57 +0000
Received: from dslb-092-076-245-153.pools.arcor-ip.net ([92.76.245.153])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 01:18:57 +0000
Received: from feldmann_markus by dslb-092-076-245-153.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 01:18:57 +0000
To: linux-wireless@vger.kernel.org
From: Markus Feldmann <feldmann_markus@gmx.de>
Subject: Re: BCM4303 on HP zv5265ea
Date: Thu, 05 Mar 2009 02:18:47 +0100
Message-ID: <gon99n$b1t$1@ger.gmane.org> (sfid-20090305_021910_899053_91C8F904)
References: <gohr71$48f$1@ger.gmane.org> <49AC742D.9030309@lwfinger.net> <gom4ke$vle$1@ger.gmane.org> <49AE9BDD.7070603@lwfinger.net> <gomq5f$n64$1@ger.gmane.org> <49AEF58E.30302@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
In-Reply-To: <49AEF58E.30302@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger schrieb:
> Markus Feldmann wrote:
>> But thats all i know.
> 
> My system has an empty /sys/bus/pci/slots.
Ok, but thats what Matthew Garret told me.

> Did you do that?
Yes i built-in the modul.
> 
>> I have some printk statements activated.
>> But i don't get more Debug messages than these in my
>> old threads, or do you know some special debug kernel
>> Options for wireless or general debug options ?
>>
> I meant new printk statements that are used to see if hitting your switch causes
> any action with RFKILL. I don't know where to put them, nor do I want to take
> much time. I have an old BCM4306 and a BCM4301 - both work with b43legacy.
That listens interesting. So if there is a possibility to get more debug
messages for the RFKILL Button, that would be nice. :-)

Regards Markus


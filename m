Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:33080 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142AbYILXBS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 19:01:18 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KeHdZ-0002ib-9k
	for linux-wireless@vger.kernel.org; Fri, 12 Sep 2008 23:01:13 +0000
Received: from 77.21.167.158 ([77.21.167.158])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 12 Sep 2008 23:01:13 +0000
Received: from feldmann_markus by 77.21.167.158 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 12 Sep 2008 23:01:13 +0000
To: linux-wireless@vger.kernel.org
From: feldmaus <feldmann_markus@gmx.de>
Subject: Re: Do not get BCM4303 to work
Date: Sat, 13 Sep 2008 01:02:58 +0200
Message-ID: <gaesbd$nv8$1@ger.gmane.org> (sfid-20080913_010123_311855_05295261)
References: <ga2fra$9q$1@ger.gmane.org> <48C5777B.9070106@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
In-Reply-To: <48C5777B.9070106@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger schrieb:
> feldmaus wrote:
>> Hi All,
>>
>> i do not get my Wlan Card with BCM4303 Chip to work.
>>
>> I am not sure whether this Card is active, because <dmesg> show me,
>> [  409.752921] b43legacy-phy0: Radio hardware status changed to DISABLED
> 
> Your card can receive, but not transmit due to a problem with the rfkill 
> switch handling in b43legacy. I'm working on this problem with a Ubuntu 
> user, and will post patches as soon as the problem is fixed.
> 
> Larry
Thanks for your Support.

I installed the Kernel 2.6.26-1 as Maximilian said.
I hope i can try to get my Card to work.
If you need some Messages then let me know.

Regards Markus


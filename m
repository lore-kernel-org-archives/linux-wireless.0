Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mxin.vub.ac.be ([134.184.129.112]:28524 "EHLO mxin.vub.ac.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301Ab3KASJZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 14:09:25 -0400
Message-ID: <5273EE53.50705@telenet.be> (sfid-20131101_190934_750559_52CB2910)
Date: Fri, 01 Nov 2013 19:09:23 +0100
From: Ruben De Smet <ruben.de.smet@telenet.be>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	b43-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com
Subject: Re: BCM43228
References: <52737A9C.3020404@telenet.be> <5273C948.9060409@lwfinger.net> <5273D018.7080607@telenet.be> <5273DFC6.8000305@lwfinger.net>
In-Reply-To: <5273DFC6.8000305@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/01/2013 06:07 PM, Larry Finger wrote:
> On 11/01/2013 11:00 AM, Ruben De Smet wrote:
>> AFAIK, broadcom only offers it's drivers for intel x86 and
>> x64_86; I guess by MIPS, you mean the architecture? (why wouldn't
>> the intel driver work? Pretty unknown on the subject ;) )
>> 
>> I read the WIP mail about the 227 chip, I could possibly wait for
>> that one to be released and test it out on mine?
>> 
>> For the record: the issue I'm having is as follows: when
>> connecting via the bluetooth part of the chip to my phone and
>> using DUN to connect to the internet, everything works fine until
>> I shut down the connection. Then my kernel panics. (Another issue
>> of course is the fact that wl is the only closed source thing in
>> my kernel running atm on my notebook...)
>> 
>> On brcmsmac: is linux-wireless the right mailinglist to post to
>> then? I see that the range of supported devices is more close to
>> my chip than b43 is ;) I added brcm80211-dev-list@broadcom.com to
>> this mail too, which looks like the more appropriate mailinglist
>> to post the issue to.
>> 
>> R
>> 
>> PS. snippet of the output of 'lspci -nn':
>> 
>> 03:00.0 Network controller [0280]: Broadcom Corporation BCM43228 
>> 802.11a/b/g/n [14e4:4359]
>> 
>> Other information on request, will try to answer asap.
> 
> The MIPS drivers are part of the codes used in various SoC 
> implementations used in wireless routers. Disassembling an x86
> code stream is much harder than for a machine like MIPS where all 
> instructions are the same size.
> 
> Larry
> 
> 

AFAIK this chip won't be incorporated in routers nor access points.
As Arend van Spriel stated in a followup mail, I'll keep
brcm80211-dev-list@broadcom.com in the To field.

Any chance that the brcm80211 team knows something on this topic? For
what I feel here, they are the people who will be closest to the issue.

Thank you for your time.

R
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSc+5SAAoJEPgmWogSE9wQau4IALRlKUQ3VpSjaX6/wgr2pY7X
d0pyHGCXVQAdKsvJoyIXqGAfpqRNM7jMsaZlP0ZEAwy0klq4Muh288UrF4SJGeHo
ZJx4j3AZhvu4bZrlWUc0tede0V1pe2Cughy6QIpgUwZdNli+FHpYsLXl+ktk2wR4
KQvUYzhB+09/YRSUgaGhbF+uR0XfW6uqK32NE8+hWjZF1VgGj7mZJd7ApYjbGTq/
91sOUM92F6JSFRGx9skCUwf0M/XhzCG+1w/vcw8eN7rbLqIh+GNYFhzhMC35xfjW
cENvCZ9hi0UyQQ+scPwbmQRHhwqsavN6Wk0irJdst6JxMML2jDjHsVAJR/vGTFk=
=drMC
-----END PGP SIGNATURE-----

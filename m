Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:41219 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543AbZANSfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 13:35:38 -0500
Received: from c213-89-101-100.bredband.comhem.se ([213.89.101.100]:62079 helo=[192.168.0.142])
	by ch-smtp01.sth.basefarm.net with esmtp (Exim 4.68)
	(envelope-from <tsr.offentlig@tsr.se>)
	id 1LNAaW-0006Ta-3H
	for linux-wireless@vger.kernel.org; Wed, 14 Jan 2009 19:35:36 +0100
Message-ID: <496E3075.6090901@tsr.se> (sfid-20090114_193542_634019_BE4F18C0)
Date: Wed, 14 Jan 2009 19:35:33 +0100
From: tsr <tsr.offentlig@tsr.se>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: Marvell 88w8385 Support
References: <496C8468.4060101@tsr.se>  <20090113145213.GA3623@tuxdriver.com> <1231951654.14909.22.camel@localhost.localdomain> <496E1D6A.10505@gmail.com>
In-Reply-To: <496E1D6A.10505@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John Daiker wrote:
> On 01/14/2009 08:47 AM, Dan Williams wrote:
>> On Tue, 2009-01-13 at 09:52 -0500, John W. Linville wrote:
>>   
>>> On Tue, Jan 13, 2009 at 01:09:12PM +0100, tsr wrote:
>>>     
>>>> Hi,
>>>>
>>>> I have a FSG-3 that includes a Marvell 88w8385 card. I wonder if there
>>>> is support for it in recent kernels. According to
>>>> http://marc.info/?l=linux-wireless&m=123178916308198&w=2 (search for
>>>> 8385) there seems to be support but I don't want to start messing 
>>>> around
>>>> with kernels and stuff without being sure.
>>>>        
>>> That driver is for SDIO hardware.  It looks like your FSG-3 has
>>> mini-PCI?  Either way, we don't have a driver merged yet that would
>>> cover your hardware.
>>>      
>>
>> Looks like it's a CB35, which is actually an 88w8335 MiniPCI card.
>> Would be supported by the mwl8k driver ideally.  I've started on trying
>> to add support to mwl8k for the 8335 parts, but we'll need to split the
>> driver so that we can create IO hooks for the different parts.  It'll be
>> a bit, but we'll get there.
>>
>> Dan
>>    
> Very interested in the progress of 8335 support at some point.  My 
> Netgear wg311v3 is sitting on my desk... waiting for some Linux bits to 
> get it running!
> 
> I can assist in testing whenever bits become available ( officially or 
> unofficially, hint, hint! :-P )
> 
> Thanks for the hard work, and keep them bits a comin'
> 
> JD
> 

Thanks for the info, I've found something that is said to be a working 
drivers for 'my' card in this package: 
http://www.seagate.com/staticfiles/maxtor/en_us/downloads/MSSII_3.1.2.src.tgz

The kernel source says it's some kind of 2.6 kernel, grepping for it I 
found the highest number to be 2.6.14 so maybe it is possible to use 
something from it.

AFAIK it's also GPL.

/tsr


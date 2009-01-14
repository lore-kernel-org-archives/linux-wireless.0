Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:52695 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054AbZANROa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2009 12:14:30 -0500
Received: by rv-out-0506.google.com with SMTP id k40so614521rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2009 09:14:29 -0800 (PST)
Message-ID: <496E1D6A.10505@gmail.com> (sfid-20090114_181434_329102_773E378A)
Date: Wed, 14 Jan 2009 09:14:18 -0800
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	tsr <tsr.offentlig@tsr.se>, linux-wireless@vger.kernel.org
Subject: Re: Marvell 88w8385 Support
References: <496C8468.4060101@tsr.se>  <20090113145213.GA3623@tuxdriver.com> <1231951654.14909.22.camel@localhost.localdomain>
In-Reply-To: <1231951654.14909.22.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/14/2009 08:47 AM, Dan Williams wrote:
> On Tue, 2009-01-13 at 09:52 -0500, John W. Linville wrote:
>    
>> On Tue, Jan 13, 2009 at 01:09:12PM +0100, tsr wrote:
>>      
>>> Hi,
>>>
>>> I have a FSG-3 that includes a Marvell 88w8385 card. I wonder if there
>>> is support for it in recent kernels. According to
>>> http://marc.info/?l=linux-wireless&m=123178916308198&w=2 (search for
>>> 8385) there seems to be support but I don't want to start messing around
>>> with kernels and stuff without being sure.
>>>        
>> That driver is for SDIO hardware.  It looks like your FSG-3 has
>> mini-PCI?  Either way, we don't have a driver merged yet that would
>> cover your hardware.
>>      
>
> Looks like it's a CB35, which is actually an 88w8335 MiniPCI card.
> Would be supported by the mwl8k driver ideally.  I've started on trying
> to add support to mwl8k for the 8335 parts, but we'll need to split the
> driver so that we can create IO hooks for the different parts.  It'll be
> a bit, but we'll get there.
>
> Dan
>    
Very interested in the progress of 8335 support at some point.  My 
Netgear wg311v3 is sitting on my desk... waiting for some Linux bits to 
get it running!

I can assist in testing whenever bits become available ( officially or 
unofficially, hint, hint! :-P )

Thanks for the hard work, and keep them bits a comin'

JD

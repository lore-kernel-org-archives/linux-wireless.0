Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2497 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933426Ab3GDI2T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jul 2013 04:28:19 -0400
Message-ID: <51D531E8.5030709@broadcom.com> (sfid-20130704_102825_959049_CE5E5A23)
Date: Thu, 4 Jul 2013 10:27:20 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Kamal Mostafa" <kamal@canonical.com>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"Greg KH" <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] brcmfmac: Turn off ARP offloading when configured
 for AP.
References: <1370508957-12709-1-git-send-email-arend@broadcom.com>
 <51C15D4D.6040009@broadcom.com> <20130619141920.GB7395@kroah.com>
 <51C1D392.8060705@broadcom.com> <20130619165217.GC5419@kroah.com>
 <51D33EC2.1090108@broadcom.com>
 <CACna6rzqjh0uC=qNThA=fsNmbLz+b0NUfkvFSLZ7GhRdGqOYug@mail.gmail.com>
 <1372892769.12249.259.camel@fourier>
In-Reply-To: <1372892769.12249.259.camel@fourier>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/04/2013 01:06 AM, Kamal Mostafa wrote:
> On Wed, 2013-07-03 at 06:54 +0200, Rafał Miłecki wrote:
>> 2013/7/2 Arend van Spriel <arend@broadcom.com>:
>>> Hi Greg,
>>>
>>> Forgot to ask, but it seems like Canonical is maintaining additional stable
>>> kernel branches. I guess I should contact them for those kernel versions (if
>>> I care), right?
>>
>> They track Greg's stables to pick up the patches. Know from my own
>> experience, I didn't have to ping anyone :)
>>
>
> Yes, we're picking up cc: stable patches automatically when they apply
> to the 3.8.y.z and 3.5.y.z "extended stable" branches[0], but we
> certainly appreciate specific backports for those versions when they
> don't apply cleanly.

Thanks, Kamal

I send a backport for 3.9 and tried it on 3.8, but it does not apply so 
I would have to backport it. I will have a look and find out where to 
send them. Probably that info is on the referred wiki.

Regards,
Arend

>   -Kamal
>
> [0] https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable
>
>



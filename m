Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43351 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932268AbZKBUQd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 15:16:33 -0500
Message-ID: <4AEF3E1B.9060106@gmx.net>
Date: Mon, 02 Nov 2009 21:16:27 +0100
From: Frank Schaefer <schaefer.frank@gmx.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB
 N devices in cdrom mode
References: <200910171606.02961.oliver@neukum.org> <20091101183553.GB24436@one-eyed-alien.net> <4AEDEE7C.4010406@gmx.net> <200911012149.57966.chunkeey@googlemail.com>
In-Reply-To: <200911012149.57966.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter schrieb:
> On Sunday 01 November 2009 21:24:28 Frank Schaefer wrote:
>   
>> Matthew Dharm schrieb:
>>     
>>> On Sun, Nov 01, 2009 at 07:29:20PM +0100, Josua Dietze wrote:
>>>       
>>>> Frank Schaefer schrieb:   
>>>>         
>>>>> I really think the mode-switching should be done in the kernel and not
>>>>> in user-space for reasons of usability.
>>>>>           
>>>> What is wrong with an udev rule entry? By the way, did the "eject" 
>>>> command line tool work as well?
>>>>         
>>> And I think it should be done in userspace for issues of maintainability
>>> and useability.  It is much easier for users to upgrade their udev then
>>> their kernel.
>>>       
>> Maintainability for whom ? The kernel-devs or the distro-people and the
>> users ? ;)
>>
>> Please think about the users. They don't know that they have to create
>> udev-rules or have to install additional packages like usb_modeswitch
>> (which is nevertheless a great tool !).
>> And even if they know, they don't want to do that. So it's up to the
>> distros to do this automatically, which will in reality never come true
>> for all devices and distros.
>>     
> yes, please think about the users!
>
> All not-so-trival-changes have to go through wireless-testing / wireless-next,
> net-next, linux-next until it hits finally the mainline... And then only users
> which are able to update their kernels will benefit, *everyone else* has
> to wait until their distros to pick up the new kernel... this could be easily more
> than a year before the device will work right out of the box for *everyone else*.
>   
Which potential not-so-trivial-changes do you think of in this case ?
And userspace-software + packages have a quality-assurance-procedure,
too, right ? ;)
> Therefore udev should be the way to go...
Maybe it should be, but it's a solution which will never work
satisfyingly. At least as long as the needed udev-rules are not shipped
with the kernel...
>  and as a bonus: a userspace/udev solution 
> does work with older kernels right away!
>
> Regards,
> 	Chr
Frank


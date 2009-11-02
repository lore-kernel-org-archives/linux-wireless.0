Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33717 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932231AbZKBUHO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 15:07:14 -0500
Message-ID: <4AEF3BF8.1080701@gmx.net>
Date: Mon, 02 Nov 2009 21:07:20 +0100
From: Frank Schaefer <schaefer.frank@gmx.net>
MIME-Version: 1.0
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB
 N devices in cdrom mode
References: <200910171606.02961.oliver@neukum.org> <Pine.LNX.4.44L0.0910171130550.25594-100000@netrider.rowland.org> <20091017220313.GH24502@one-eyed-alien.net> <4ADC3657.6080906@gmx.net> <4AEDCCA0.8050709@gmx.net> <4AEDD380.40408@draisberghof.de> <20091101183553.GB24436@one-eyed-alien.net> <4AEDEE7C.4010406@gmx.net> <20091102004756.GC24436@one-eyed-alien.net>
In-Reply-To: <20091102004756.GC24436@one-eyed-alien.net>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthew Dharm schrieb:
> On Sun, Nov 01, 2009 at 09:24:28PM +0100, Frank Schaefer wrote:
>   
>> Matthew Dharm schrieb:
>>     
>>> On Sun, Nov 01, 2009 at 07:29:20PM +0100, Josua Dietze wrote:
>>>       
>>>> Frank Schaefer schrieb:        
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
>
> Both.
>   
>> Please think about the users. They don't know that they have to create
>> udev-rules or have to install additional packages like usb_modeswitch
>> (which is nevertheless a great tool !).
>> And even if they know, they don't want to do that. So it's up to the
>> distros to do this automatically, which will in reality never come true
>> for all devices and distros.    
>
> I am thinking about the users.  Do you really think someone who has
> difficulty installing a new udev rule (probably a line or two of text
> copied from a google search) or installing a new version of usb_modeswitch
> (probably one or two commands to the distro package manager) will have an
> easier time doing a custom kernel-compile and update?
>   
I think users should not need to do ANY of these things ! That's called
usability.
Which users do you think know how to create udev-rules and how to
compile a kernel ?
Of course you and me and likely all others on this mailing-list and
maybe you think Linux should be for them, only.

I think we should do as much as possible to improve Linux-usability for
"normal" and even "less experienced" users.
And in this case, it would be really easy.
> Updates in userspace are universally easier; on users, on kernel deves, and
> on distro devs.
>
> Matt
>   
Why ? Of course, the benfit for kernel-developers is that the work is
done by others...
But for the distros it makes life much more difficult in many respects.
And users are in the somehow insane situation that they have to keep the
driver (kernel) AND the "key to be able to use it" up-to-date.
That's not only a problem because they both things from different
sources/directions !

Frank

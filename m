Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48789 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754604AbZKCUpu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 15:45:50 -0500
Message-ID: <4AF093AA.1080300@gmx.net>
Date: Tue, 03 Nov 2009 21:33:46 +0100
From: Frank Schaefer <schaefer.frank@gmx.net>
MIME-Version: 1.0
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB
 N devices in cdrom mode
References: <200910171606.02961.oliver@neukum.org> <Pine.LNX.4.44L0.0910171130550.25594-100000@netrider.rowland.org> <20091017220313.GH24502@one-eyed-alien.net> <4ADC3657.6080906@gmx.net> <4AEDCCA0.8050709@gmx.net> <4AEDD380.40408@draisberghof.de> <20091101183553.GB24436@one-eyed-alien.net> <4AEDEE7C.4010406@gmx.net> <20091102004756.GC24436@one-eyed-alien.net> <4AEF3BF8.1080701@gmx.net> <20091102211001.GH24436@one-eyed-alien.net>
In-Reply-To: <20091102211001.GH24436@one-eyed-alien.net>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthew Dharm schrieb:
> On Mon, Nov 02, 2009 at 09:07:20PM +0100, Frank Schaefer wrote:
>   
>> Matthew Dharm schrieb:
>>     
>>> I am thinking about the users.  Do you really think someone who has
>>> difficulty installing a new udev rule (probably a line or two of text
>>> copied from a google search) or installing a new version of usb_modeswitch
>>> (probably one or two commands to the distro package manager) will have an
>>> easier time doing a custom kernel-compile and update?
>>>       
>> I think users should not need to do ANY of these things ! That's called
>> usability.
>>     
>
> So, new hardware should "magically" work?  When you can write software to
> support hardware that doesn't exist yet, let me know.
>   
I can make nothing of that.
It really doesn't make sense to discuss about mode-switches for devices
for which we not even have a driver.
>> Which users do you think know how to create udev-rules and how to
>> compile a kernel ?
>> Of course you and me and likely all others on this mailing-list and
>> maybe you think Linux should be for them, only.
>>
>> I think we should do as much as possible to improve Linux-usability for
>> "normal" and even "less experienced" users.
>>     
>
> Okay, let's talk about "less experienced" users.  Suppose you are one of
> these users.  You get a new device, and you want to use it.  You do some
> web searching, and discover either:
>
> (a) you need to download and recompile your kernel
> (b) you need to cut-and-paste some text from a web page into a file
>
> Which do you think is easier?
>   
It's easier to let the driver/kernel do the mode-switch automatically if
it makes sense !
That's perfect Plug'N Play and (a) and (b) are dispensable.

Apart from that, I think that "just cut-and-paste some text from a web
page into a file" is an illusion.
Starts with the right key-words you need for the search and continues
with the quality of the documentation.
It's not that easy to create universal and especially complete manuals
(we all love documentation-work right !? ;) ).
For example: what's udev ? Of course, WE know, but ...
> And, the situation above pre-supposes that the requisite changes (kernel or
> userspace) haven't already been picked up by a distro maintainer.
>
>   
>> And in this case, it would be really easy.
>>     
>>> Updates in userspace are universally easier; on users, on kernel deves, and
>>> on distro devs.
>>>
>>>       
>> Why ? Of course, the benfit for kernel-developers is that the work is
>> done by others...
>> But for the distros it makes life much more difficult in many respects.
>>     
>
> I highly doubt this.  Distros must very carefully test all the kernel
> changes they decide to pull in.  Each and every change in a kernel-layer is
> a high-risk change for them.  Changing userspace packages is much
> lower-risk, and thus consumes correspondingly fewer resources.
>
>   
And they don't have to test userspace-software carefully, too ???
Especially sysconfig-software ?
I can't see a significant difference here.
>> And users are in the somehow insane situation that they have to keep the
>> driver (kernel) AND the "key to be able to use it" up-to-date.
>> That's not only a problem because they both things from different
>> sources/directions !
>>     
>
> I think you may have missed part of an earlier discussion, wherein we
> discussed such devices which would NOT need ANY kernel changes.  The idea
> was that udev could "eject" the fake-USB device, then add the device IDs to
> the serial/cdc_amc/whatever driver dynamically, at runtime.  Thus, no need
> to make any kernel updates at all.
>
> And, that system works *today* with the existing kernel code.
>
> Matt
>   
You didn't understand me right. No problem.
I was talking about inconsistencies we get when driver and the
mode-switch-part come from different sources.
That's one of the main problems in Unix-world, maybe that's the price we
have to pay for thinking more modular (packages) than in products like
in M$-world.
But we shouldn't pay that price needlessly because of splitting things
at the wrong position.

Frank


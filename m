Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58753 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932193AbZKBUKW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 15:10:22 -0500
Message-ID: <4AEF3CAD.10809@gmx.net>
Date: Mon, 02 Nov 2009 21:10:21 +0100
From: Frank Schaefer <schaefer.frank@gmx.net>
MIME-Version: 1.0
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
	linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB
 N devices in cdrom mode
References: <200910171606.02961.oliver@neukum.org> <Pine.LNX.4.44L0.0910171130550.25594-100000@netrider.rowland.org> <20091017220313.GH24502@one-eyed-alien.net> <4ADC3657.6080906@gmx.net> <4AEDCCA0.8050709@gmx.net> <4AEDD380.40408@draisberghof.de> <4AEDEB85.5080105@gmx.net> <20091102005144.GE24436@one-eyed-alien.net>
In-Reply-To: <20091102005144.GE24436@one-eyed-alien.net>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthew Dharm schrieb:
> On Sun, Nov 01, 2009 at 09:11:49PM +0100, Frank Schaefer wrote:
>   
>> Josua Dietze schrieb:
>>     
>>> Frank Schaefer schrieb:
>>>       
>>>> I really think the mode-switching should be done in the kernel and not
>>>> in user-space for reasons of usability.
>>>>         
>>> What is wrong with an udev rule entry? By the way, did the "eject"
>>> command line tool work as well?
>>>       
>> It returns an error but the device is ejected.
>> But do you really want the users to open a terminal window and call
>> "eject" each time they plug their device in ;) ?
>>     
>
> If 'eject' worked, then why not use a simple udev entry?  That way nobody
> has to call anything by hand...
>
> Matt
>   
And who will create this udev-entry ;) ? How can you make sure that this
is done on all systems ?

Frank

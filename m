Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:58772 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbYGBR1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 13:27:18 -0400
From: Chr <chunkeey@web.de>
To: Ivo Couckuyt <iv0co@yahoo.co.uk>
Subject: Re: PROBLEM: p54usb doesn't work with my Philips CPWUA054 usb adapter
Date: Wed, 2 Jul 2008 19:26:29 +0200
Cc: linux-wireless@vger.kernel.org
References: <486BB5D4.4010701@yahoo.co.uk>
In-Reply-To: <486BB5D4.4010701@yahoo.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807021926.29266.chunkeey@web.de> (sfid-20080702_192721_930790_BDA3AEC3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 02 July 2008 19:07:32 Ivo Couckuyt wrote:
> sent this a while ago, but might be filtered due to attachment (removed
> now):
>
> i tried the following firmwares:
> 2.4.4.0.arm  2.4.6.0.arm
> 2.5.11.0.arm 2.5.6.0.arm 2.5.2.0.arm 2.7.0.0.arm
> All give the same dmesg output, (HC died; cleaning up)
> except 2.5.8.0.arm which gives something else, probably not worth much,
> but nevertheless see attachment
>
> In the very beginning I used ndiswrapper without any problem (still
> works now), but at the moment i'm using the old islsm driver together
> with kernel 2.6.9 and firmware 2.5.6.0 (only one that works), which
> doesn't seem to be on the site you mentioned
> md5sum:
> 6ff238179cf9618aac2b5d7a34e41450  2.5.6.0.arm (is included for what it
> is worth)

No, your post didn't get lost...

however I don't know what's wrong with it, as my USB device is 
probably ?still? sitting in the custom office.. *sigh*. And even then, 
when I'll finally get it... It probably differs alot from yours.

However... the p54 code has sometimes some timing problems, 
that islsm didn't have?! so what happends have you add some
delays inside the the initialization/probe code?
(BTW: do you have a "lsusb -v" of the wlan stick somewhere?)

Regards,
	Christian 

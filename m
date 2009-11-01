Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56144 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753209AbZKAUDC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 15:03:02 -0500
Message-ID: <4AEDE973.1090907@gmx.net>
Date: Sun, 01 Nov 2009 21:02:59 +0100
From: Frank Schaefer <schaefer.frank@gmx.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
	chunkeey@web.de
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB
 N devices in cdrom mode
References: <200910171606.02961.oliver@neukum.org>	 <Pine.LNX.4.44L0.0910171130550.25594-100000@netrider.rowland.org>	 <20091017220313.GH24502@one-eyed-alien.net> <4ADC3657.6080906@gmx.net>	 <4AEDCCA0.8050709@gmx.net> <1257100045.3555.160.camel@johannes.local>
In-Reply-To: <1257100045.3555.160.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg schrieb:
> On Sun, 2009-11-01 at 19:00 +0100, Frank Schaefer wrote:
>
>   
>> The attached patch adds the mode-switching-procedure to the WLAN-driver
>> (ar9170usb) and disables the storage device in the usb-storage-driver.
>>     
>
> This patch looks weird. Have you looked at zd1211rw, which also does
> this? I think it just adds something to usb-storage for the device IDs?
>
> johannes
>   
Well, AFAICS, the zd1211rw does exactly what I suggest with my patch ?!
It calls a function eject_installer(...) for these devices in the
modules' probe-function which sends a single usb_bulk_msg.

Frank


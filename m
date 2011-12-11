Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43649 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab1LKMEn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Dec 2011 07:04:43 -0500
Received: by iaeh11 with SMTP id h11so1557591iae.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Dec 2011 04:04:42 -0800 (PST)
Message-ID: <4EE49C57.9040509@lwfinger.net> (sfid-20111211_130448_022616_17E3E4AF)
Date: Sun, 11 Dec 2011 06:04:39 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Roland Gruber <post@rolandgruber.de>
CC: linux-wireless@vger.kernel.org, 651622@bugs.debian.org,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Bug#651622: linux-2.6: Sitecom WLA-2000 v1.001 WLAN stick not
 supported
References: <20111210162607.1020.50335.reportbug@roland>		 <1323537258.18450.100.camel@deadeye> <4EE39C40.4030802@rolandgruber.de>	 <1323543622.25752.4.camel@deadeye> <4EE3D447.7030108@rolandgruber.de> <1323554710.25752.18.camel@deadeye> <4EE3DF19.6080106@rolandgruber.de> <4EE3E9A1.8000004@lwfinger.net> <4EE48317.4020909@rolandgruber.de>
In-Reply-To: <4EE48317.4020909@rolandgruber.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/11/2011 04:16 AM, Roland Gruber wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hi Larry,
>
> Am 11.12.2011 00:22, schrieb Larry Finger:
>> The driver for the RTL8188SU is r8712u. Try
>>
>> modprobe -rv r8712u
>> echo 0df6 005d>   /sys/bus/usb/drivers/r8712u/new_id
>
> wow, this works. Thank you very much for your fast help. :)
> This mail is sent via the WLAN stick. ;-)

OK, your chip is an RTL8191SU.
>
>
>> If that works, I can add that device ID to the driver.
>
> This would be cool.
>

Patch sent to staging tree via GregKH with notation to add to stable. 
Eventually, this change will part of an updated kernel - in your case, 3.1.6. 
How long that takes will depend on how long it takes Debian to pick up these 
changes.

Thanks for testing,

Larry

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:40049 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab3FOVIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Jun 2013 17:08:14 -0400
Received: by mail-oa0-f49.google.com with SMTP id n9so2020675oag.22
        for <linux-wireless@vger.kernel.org>; Sat, 15 Jun 2013 14:08:13 -0700 (PDT)
Message-ID: <51BCD7BA.1040900@lwfinger.net> (sfid-20130615_230826_596289_DC00B3A3)
Date: Sat, 15 Jun 2013 16:08:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Paul Menzel <paulepanter@users.sourceforge.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Connection not established with Realtek RTL8188CUS based USB
 device (EDIMAX)
References: <1371326265.9845.54.camel@mattotaupa>
In-Reply-To: <1371326265.9845.54.camel@mattotaupa>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/15/2013 02:57 PM, Paul Menzel wrote:
> Dear Linux wireless folks,
>
>
> hopefully I am contacting the correct list. I am not able to use the
> Realtek RTL8188CUS based USB WLAN device Edimax EW-7811Un.
>
>          Bus 002 Device 005: ID 7392:7811 Edimax Technology Co., Ltd EW-7811Un 802.11n Wireless Adapter [Realtek RTL8188CUS]
>
> The device did not work with Debian Wheezy with Linux 3.2.x, Debian
> Sid/unstable with Linux 3.9.x, Ubuntu 12.04 with Linux 3.2.12 to 3.5 and
> Ubuntu 13.04 with Linux 3.8. The person, from whom the device is from,
> claims the device once worked with Ubuntu, but I do not know which
> version and what WLAN type(?) this was with.
>
> The behavior is always the same. The device is detected and the
> NetworkManager applet `nm-applet` is also able to detect the available
> networks. But wanting to connect to one and entering the correct
> password, the connection cannot be established and I am asked for the
> password again. I tested this with different systems and different
> networks and also with wpa_supplicant. A Ralink based WLAN USB device
> works just fine.
>
> The Realtek RTL8188CUS WLAN device works also fine under Microsoft
> Windows, so the device is functional.

Use a compat-wireless package from 3.10-rc1 or later. If that fails, then I will 
give you a debug sequence to run.

Larry



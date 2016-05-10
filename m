Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:36224 "EHLO
	mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbcEJNQh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 09:16:37 -0400
Received: by mail-vk0-f67.google.com with SMTP id c189so1188727vkb.3
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2016 06:16:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e7b07631-da96-51c0-5960-ea5ed9d1d94f@gmail.com>
References: <d6e308b0-5deb-e792-5991-5afc46aa7420@gmail.com>
	<e7b07631-da96-51c0-5960-ea5ed9d1d94f@gmail.com>
Date: Tue, 10 May 2016 23:16:36 +1000
Message-ID: <CAD4Xxq_WPVxU8h3+KyxdgztchYyzkW7GOQ8iCOf4uKMQ_X-CMg@mail.gmail.com> (sfid-20160510_151641_287373_E1DD6FF4)
Subject: Re: Realtek USB WiFi rtl8192eu
From: Fisher Grubb <fisher.grubb@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Xose,

I'm not sure, I have the latest version of Ubuntu on my laptop and I
had to use the DKMS -2 deb file to get it working as no driver claimed
it.

After Googeling (especially for the 0bda:818b USB device and vendor
ID), it seemed the driver supported most of Realtek's WiFi devices but
mine wasn't listed.

>From memory, I used this page mainly when I was first checking:
https://wiki.debian.org/rtl819x

I didn't see any people in forums mentioning how they managed to get
this standard driver working, they all seemed to either have no luck
because code didn't compile, or link to source code that did compile.

If that mainline driver does work, then I assume there could be some
USB vendor and device IDs that it doesn't cover.

Here's the link for where I bought it:
http://www.ebay.com.au/itm/181860888357

Fisher

On Tue, May 10, 2016 at 11:01 PM, Xose Vazquez Perez
<xose.vazquez@gmail.com> wrote:
> On 05/10/2016 02:58 PM, Xose Vazquez Perez wrote:
>
>> That device is supported by rtl8xxxu.
>
> BTW, Realtek devices are documented at:
> https://wireless.wiki.kernel.org/en/users/Drivers/rtl819x

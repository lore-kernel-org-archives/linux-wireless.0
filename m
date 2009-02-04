Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:60909 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbZBDSSu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 13:18:50 -0500
Received: by ewy14 with SMTP id 14so3677697ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 10:18:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <cf70f0210902041010h24932f9ao3e5c9f6a243b483d@mail.gmail.com>
References: <cf70f0210902041010h24932f9ao3e5c9f6a243b483d@mail.gmail.com>
Date: Wed, 4 Feb 2009 18:18:47 +0000
Message-ID: <3ace41890902041018mdc6a5eanc79cebeb5759001e@mail.gmail.com> (sfid-20090204_191855_903650_924641DD)
Subject: Re: Regarding Belkin wireless USB adapter
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Shivdas Gujare <shivdas.tech@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 4, 2009 at 6:10 PM, Shivdas Gujare <shivdas.tech@gmail.com> wrote:
> Hi,
> I am trying to use Belkin Wireless G USB adapter(uses trl8187 driver)
> on ARM board. I am tesing this with x86 and ARM board (BeagleBoard).
>
> My problem is, this adapter works fine with my Ubuntu
> laptop(v2.6.29-rc2) using NetworkManager because of udev.
>
> I tried to run wpa_supplicant from command line as,
>  wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant.conf
> It gives error "Failed to read or parse configuration
> '/etc/wpa_supplicant.conf'"
> Because, my laptop doesn't have /etc/wpa_supplicant.conf file, But
> still wireless network works fine.
>
> I don't have wpa_supplicant in ARM rootfs, hence want to know
> Does wpa_supplicant is necessary to make this USB wireless adapter work?
>
> Also, is /etc/wpa_supplicant.conf necessary in rootfs, since device
> works fine without this file on my laptop.

Hmm, wpa_supplicant.conf contains security info, and wpa keys, etc and
such. Are you on an open or WEP network?
If so, you don't even need wpa_supplicant - just do iwconfig, etc.

>
> Thanks for your help.
>
> Regards,
> Shivdas
>

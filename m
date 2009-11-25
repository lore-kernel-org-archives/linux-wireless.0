Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f180.google.com ([209.85.216.180]:45871 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669AbZKYJr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 04:47:59 -0500
Received: by pxi10 with SMTP id 10so5627212pxi.33
        for <linux-wireless@vger.kernel.org>; Wed, 25 Nov 2009 01:48:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B0CFCC8.7090000@gmail.com>
References: <6a2053110911250132p737d6d41y7388b48bb426a82e@mail.gmail.com>
	<4B0CFCC8.7090000@gmail.com>
From: kasi viswanathan <kasi.wireless@gmail.com>
Date: Wed, 25 Nov 2009 15:17:46 +0530
Message-ID: <6a2053110911250147p6a99fa42j957636cfc26911e@mail.gmail.com>
Subject: Re: AR5523 Support
To: Jiri Slaby <jirislaby@gmail.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

thanks for the quick response.

here is the lsusb output:

[kasi@localhost ~]# lsusb
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 002: ID 046d:c018 Logitech, Inc. Optical Wheel Mouse
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 003: ID 0cf3:0002 Atheros Communications, Inc. AR5523
(no firmware)

On Wed, Nov 25, 2009 at 3:15 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 11/25/2009 10:32 AM, kasi viswanathan wrote:
>>    i am having an Atheros AR5523 usb wireless card.when i connect it to my
>> machine, device is getting recognized and i am able to see the vendor and
>> device ids using 'lsusb'.
>
> Could you attach lsusb then?
>
> --
> js
> Faculty of Informatics, Masaryk University
> Suse Labs, Novell
>

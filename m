Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:44260 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789Ab0LNUlB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 15:41:01 -0500
Received: by fxm18 with SMTP id 18so1213683fxm.2
        for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 12:41:00 -0800 (PST)
Message-ID: <4D07D678.8030903@lwfinger.net>
Date: Tue, 14 Dec 2010 14:41:28 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Eduardo Costa <ecosta.tmp@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: another device working
References: <AANLkTimQQ5dbFjiZD993OGTHp8Qvb9+N6n4ZhGuG3HTQ@mail.gmail.com>
In-Reply-To: <AANLkTimQQ5dbFjiZD993OGTHp8Qvb9+N6n4ZhGuG3HTQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/14/2010 11:09 AM, Eduardo Costa wrote:
> Hi guys,
--snip--

> Anyways, I just had to add the following line to
> `drivers/net/wireless/p54/p54usb.c' on a stock 2.6.30 kernel, prior to
> recompilation and installing the module to make it work:
> 
>  {USB_DEVICE (0x15a9, 0x0002)},   /* Gemtek WUBI-100GW 802.11g */
> 
> And about the firmware, it does work with stock p54's
> `2.13.24.0.lm87.arm' found on the website, so I just had to copy it to
> `/lib/firmware' while renaming it to `isl3887usb'.
> 
> Thanks so much for your code and support, and do not hetisate to
> contact me if you need any further assistance on my side.

Thanks for the report. I just submitted a patch to wireless-testing with a copy
to you for this change to be included in kernel 2.6.37, and to be backported to
all stable and long-term kernels.

Larry

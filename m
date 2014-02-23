Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:37262 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaBWMyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 07:54:37 -0500
Received: by mail-ob0-f176.google.com with SMTP id wo20so215483obc.35
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 04:54:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKH5=LtkNnX9g9U5Fv8EH9uDj2=KC6gieRT-Td8NNbFhkv_hvg@mail.gmail.com>
References: <CAKH5=LtkNnX9g9U5Fv8EH9uDj2=KC6gieRT-Td8NNbFhkv_hvg@mail.gmail.com>
Date: Sun, 23 Feb 2014 20:54:37 +0800
Message-ID: <CAKH5=Lu4EP9bx+nHtvGRgho7RKCV3n43VaweR0VnoHB1rAPvjw@mail.gmail.com> (sfid-20140223_135507_139219_4E111062)
Subject: Re: insmod: cannot insert `wl_high.ko': Success (17): Success ??
From: Naughtboy <skylvlinux@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

any big boy can guidiance me !!

2014-02-20 19:19 GMT+08:00 Naughtboy <skylvlinux@gmail.com>:
> i try tralsplant 43236  --5.8G usb dongle drivers into linux-2.6.21.5
> ,but here is some erros .....
>
> filename:       wl_high.ko
> license:        Proprietary
> alias:          usb:v0A5Cp0BDCd*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0471p20E7d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v04DAp23F2d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v043Ep3001d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v1EDAp0BDCd*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v050DpD321d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v050Dp615Bd*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0846p9011d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0A5CpBD17d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0A5CpBD16d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0A5CpBD13d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0A5CpBD12d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0A5Cp0000d*dc*dsc*dp*ic*isc*ip*
> depends:        bcm_usbshim
> vermagic:       2.6.21.5 mod_unload MIPS32_R2 32BIT
> parm:           oneonly:int
> parm:           piomode:int
> parm:           instance_base:int
> parm:           nompc:int
> parm:           name:string
> parm:           nvram_path:string
>
> # insmod bcm_usbshim.ko    ----ok
> but  insmod wl_high.ko occur error  .....    as the follow ..
>
> # insmod wl_high.ko nvram_path=../nvram/fake43236usb_p420.nvm
> insmod: cannot insert `wl_high.ko': Success (17): Success
> # insmod wl_high.ko nvram_path=../nvram/fake43236usb_p420.nvm
> insmod: cannot insert `wl_high.ko': Success (17): Success
>
>
>
>
> any bigman  can do me a gudiance
>
> thank you
> --Naughtboy

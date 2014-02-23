Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:53607 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaBWPnG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 10:43:06 -0500
Received: by mail-oa0-f51.google.com with SMTP id i7so3043255oag.24
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 07:43:05 -0800 (PST)
Message-ID: <530A1707.6010700@lwfinger.net> (sfid-20140223_164310_863804_F22DCC78)
Date: Sun, 23 Feb 2014 09:43:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Naughtboy <skylvlinux@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: insmod: cannot insert `wl_high.ko': Success (17): Success ??
References: <CAKH5=LtkNnX9g9U5Fv8EH9uDj2=KC6gieRT-Td8NNbFhkv_hvg@mail.gmail.com> <CAKH5=Lu4EP9bx+nHtvGRgho7RKCV3n43VaweR0VnoHB1rAPvjw@mail.gmail.com>
In-Reply-To: <CAKH5=Lu4EP9bx+nHtvGRgho7RKCV3n43VaweR0VnoHB1rAPvjw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/23/2014 06:54 AM, Naughtboy wrote:
> any big boy can guidiance me !!
>
> 2014-02-20 19:19 GMT+08:00 Naughtboy <skylvlinux@gmail.com>:
>> i try tralsplant 43236  --5.8G usb dongle drivers into linux-2.6.21.5
>> ,but here is some erros .....
>>
>> filename:       wl_high.ko
>> license:        Proprietary
>> alias:          usb:v0A5Cp0BDCd*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0471p20E7d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v04DAp23F2d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v043Ep3001d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v1EDAp0BDCd*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v050DpD321d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v050Dp615Bd*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0846p9011d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0A5CpBD17d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0A5CpBD16d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0A5CpBD13d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0A5CpBD12d*dc*dsc*dp*ic*isc*ip*
>> alias:          usb:v0A5Cp0000d*dc*dsc*dp*ic*isc*ip*
>> depends:        bcm_usbshim
>> vermagic:       2.6.21.5 mod_unload MIPS32_R2 32BIT
>> parm:           oneonly:int
>> parm:           piomode:int
>> parm:           instance_base:int
>> parm:           nompc:int
>> parm:           name:string
>> parm:           nvram_path:string
>>
>> # insmod bcm_usbshim.ko    ----ok
>> but  insmod wl_high.ko occur error  .....    as the follow ..
>>
>> # insmod wl_high.ko nvram_path=../nvram/fake43236usb_p420.nvm
>> insmod: cannot insert `wl_high.ko': Success (17): Success
>> # insmod wl_high.ko nvram_path=../nvram/fake43236usb_p420.nvm
>> insmod: cannot insert `wl_high.ko': Success (17): Success

That is a proprietary, closed-source driver. To get help for it, you need to 
contact the program's authors. You can, however, look at the dmesg output to see 
what is wrong.

Larry



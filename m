Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:28581 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbaBTMjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 07:39:47 -0500
Message-ID: <5305F77F.6030607@broadcom.com> (sfid-20140220_133951_063626_5BB009F7)
Date: Thu, 20 Feb 2014 13:39:27 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Naughtboy <skylvlinux@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: insmod: cannot insert `wl_high.ko': Success (17): Success ??
References: <CAKH5=LtkNnX9g9U5Fv8EH9uDj2=KC6gieRT-Td8NNbFhkv_hvg@mail.gmail.com>
In-Reply-To: <CAKH5=LtkNnX9g9U5Fv8EH9uDj2=KC6gieRT-Td8NNbFhkv_hvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/20/2014 12:19 PM, Naughtboy wrote:
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

You are basically on your own. You will never get much response from
people in the linux wireless *open-source* community when fiddling with
proprietary drivers.

Regards,
Arend


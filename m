Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:55992 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbaBTLTp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 06:19:45 -0500
Received: by mail-ob0-f178.google.com with SMTP id wn1so1897860obc.23
        for <linux-wireless@vger.kernel.org>; Thu, 20 Feb 2014 03:19:44 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 20 Feb 2014 19:19:44 +0800
Message-ID: <CAKH5=LtkNnX9g9U5Fv8EH9uDj2=KC6gieRT-Td8NNbFhkv_hvg@mail.gmail.com> (sfid-20140220_121948_499124_F0073E14)
Subject: insmod: cannot insert `wl_high.ko': Success (17): Success ??
From: Naughtboy <skylvlinux@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i try tralsplant 43236  --5.8G usb dongle drivers into linux-2.6.21.5
,but here is some erros .....

filename:       wl_high.ko
license:        Proprietary
alias:          usb:v0A5Cp0BDCd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0471p20E7d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v04DAp23F2d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v043Ep3001d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1EDAp0BDCd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v050DpD321d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v050Dp615Bd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0846p9011d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0A5CpBD17d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0A5CpBD16d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0A5CpBD13d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0A5CpBD12d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0A5Cp0000d*dc*dsc*dp*ic*isc*ip*
depends:        bcm_usbshim
vermagic:       2.6.21.5 mod_unload MIPS32_R2 32BIT
parm:           oneonly:int
parm:           piomode:int
parm:           instance_base:int
parm:           nompc:int
parm:           name:string
parm:           nvram_path:string

# insmod bcm_usbshim.ko    ----ok
but  insmod wl_high.ko occur error  .....    as the follow ..

# insmod wl_high.ko nvram_path=../nvram/fake43236usb_p420.nvm
insmod: cannot insert `wl_high.ko': Success (17): Success
# insmod wl_high.ko nvram_path=../nvram/fake43236usb_p420.nvm
insmod: cannot insert `wl_high.ko': Success (17): Success




any bigman  can do me a gudiance

thank you
--Naughtboy

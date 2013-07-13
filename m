Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alpha.kreiz-it.fr ([178.32.219.166]:49521 "EHLO
	alpha.kreiz-it.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408Ab3GMLPk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jul 2013 07:15:40 -0400
From: "Cedric GROSS" <cg@cgross.info>
To: <sedat.dilek@gmail.com>
Cc: <linux-wireless@vger.kernel.org>
References: <001a01ce7fb1$75bfdc10$613f9430$@info> <CA+icZUVoZkg3nT6=SwTaLCWoa+v6aLkXSP5b71a0GmxMMWOyHA@mail.gmail.com>
In-Reply-To: <CA+icZUVoZkg3nT6=SwTaLCWoa+v6aLkXSP5b71a0GmxMMWOyHA@mail.gmail.com>
Subject: RE: Firmware error for Centrino N 2230
Date: Sat, 13 Jul 2013 13:15:32 +0200
Message-ID: <001b01ce7fba$4bd15e20$e3741a60$@info> (sfid-20130713_131543_344560_91BFAB8F)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Sedat,

> -----Message d'origine-----
> De : Sedat Dilek [mailto:sedat.dilek@gmail.com]
> Envoyé : samedi 13 juillet 2013 13:04
> À : Cedric GROSS
> Cc : linux-wireless@vger.kernel.org
> Objet : Re: Firmware error for Centrino N 2230
> 
> On Sat, Jul 13, 2013 at 12:12 PM, Cedric GROSS <cg@cgross.info> wrote:
> > Hello,
> >
> > I’m trying to adapt current freebsd driver for supporting my 2230
> NIC.
> >
> > I try to follow ucode command order defined in kernel 3.2 but I reach
> > some difficulties because firmware raise error.
> >
> > Runtime uCode is alive. So far I sent calib result (cmd xB0),
> > configured advanced BT coexistence (cmd x9B,xCC and xCD) running
> > runtime calib (cmd
> > x65) but the command configuring valid chain (cmd x65) failed as the
> > result below :
> > CSR values: (2nd byte of IWN_INT_COALESCING is IWN_INT_PERIODIC)
> >   IWN_HW_IF_CONFIG: 0x00800302   IWN_INT_COALESCING: 0x0000ff40
> > IWN_INT: 0x04000000
> >   IWN_INT_MASK: 0x00000000   IWN_FH_INT: 0x00000000   IWN_GPIO_IN:
> > 0x00000000
> >    IWN_RESET: 0x00000000   IWN_GP_CNTRL: 0x080403c5   IWN_HW_REV:
> 0x000000c8
> >   IWN_EEPROM: 0x08450ffd   IWN_EEPROM_GP: 0x90000801   IWN_OTP_GP:
> > 0x00030001
> >      IWN_GIO: 0x00080044   INW_GP_UCODE: 0x00000004   IWN_GP_DRIVER:
> > 0x00000080
> >   IWN_GP1_DRIVER: 0x00000000   IWN_UCODE_DRV_GP2: 0x00000000
> IWN_LED:
> > 0x00000018
> >   IWN_DRAM_INT_TBL: 0x880b76e5   IWN_GIO_CHICKEN: 0x29800200
> IWN_ANA_PLL:
> > 0x00000000
> >   IWN_HW_REV_WA: 0x0001001a   IWN_DBG_HPET_MEM: 0xffff0000
> > firmware error log:
> >   error type      = "UNKNOWN" (0x00001987)
> >   program counter = 0x000179B4
> >   source line     = 0x00000167
> >   error data      = 0x0000000000000000
> >   branch link     = 0x0001798200017982
> >   interrupt link  = 0x0000EC7A00000000
> >   time            = 46566
> >
> > What I’m missing ?
> > What is meaning of firmware error ?
> >
> 
> What distro?
> If this is Debian or Ubuntu, this is not a vanilla but distro-patched
> kernel-version.

I'm working on freeBSD. So it's not a linux distro ;)

> 
> Can you provide more infos?
> Your kernel-config file, dmesg output, name of loaded firmware file,
> etc.

For firmware : iwlwifi-2030-18.168.6.1.fw

For the rest, I can send you what you wish, but it's not a linux output.

> 
> Did you check for newer firmware files (see [1])?
> 
> Did you try a higher kernel-release?

Doesn't apply ;)

> 
> - Sedat -
> 
> [1] http://wireless.kernel.org/en/users/Drivers/iwlwifi
> 
> > Many thanks for your help.
> >
> > Best regards
> > Cedric
> >
> > --

Thanks for help anyway.
Cedric


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alpha.kreiz-it.fr ([178.32.219.166]:25963 "EHLO
	alpha.kreiz-it.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab3GNJr1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jul 2013 05:47:27 -0400
From: "Cedric GROSS" <cg@cgross.info>
To: "'Emmanuel Grumbach'" <egrumbach@gmail.com>
Cc: "'linux-wireless'" <linux-wireless@vger.kernel.org>
References: <001a01ce7fb1$75bfdc10$613f9430$@info>	<CA+icZUVoZkg3nT6=SwTaLCWoa+v6aLkXSP5b71a0GmxMMWOyHA@mail.gmail.com>	<001b01ce7fba$4bd15e20$e3741a60$@info>	<CA+icZUX9jvAcvEkKSsN-KU2GWxPVGg9Z=soecwJtPL0soHD4Zw@mail.gmail.com> <CANUX_P2K9_q_FnkzDrn4=Y3rzn3FvkPjCB4qGmts=7kni9oW4A@mail.gmail.com>
In-Reply-To: <CANUX_P2K9_q_FnkzDrn4=Y3rzn3FvkPjCB4qGmts=7kni9oW4A@mail.gmail.com>
Subject: RE: Firmware error for Centrino N 2230
Date: Sun, 14 Jul 2013 11:47:22 +0200
Message-ID: <000301ce8077$252f1830$6f8d4890$@info> (sfid-20130714_114733_295326_9BBEA36B)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Emmanuel,

> De : Emmanuel Grumbach [mailto:egrumbach@gmail.com]
> Envoyé : dimanche 14 juillet 2013 07:03
> À : sedat.dilek@gmail.com
> Cc : Cedric GROSS; linux-wireless
> Objet : Re: Firmware error for Centrino N 2230
> 
> >>> > I’m trying to adapt current freebsd driver for supporting my 2230
> >>> NIC.
> >>> >
> >>> > I try to follow ucode command order defined in kernel 3.2 but I
> >>> > reach some difficulties because firmware raise error.
> >>> >
> >>> > Runtime uCode is alive. So far I sent calib result (cmd xB0),
> >>> > configured advanced BT coexistence (cmd x9B,xCC and xCD) running
> >>> > runtime calib (cmd
> >>> > x65) but the command configuring valid chain (cmd x65) failed as
> >>> > the result below :
> 
> cmd 0x65? it is not valid chain command.

Yep was typo, it's 0x98.

> 
> 1987 means that you haven't sent the Xtal calibration.
Many many many thanks. I will check that tomorrow.

FreeBSD driver for intel wireless card is a bit old and need a lot of
improvement to manage new NIC.
Is there a way to get all assert code meaning ? It could be really a big big
help for me.

Best regards
Cedric


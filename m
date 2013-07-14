Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:41990 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab3GNFDI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jul 2013 01:03:08 -0400
Received: by mail-la0-f44.google.com with SMTP id er20so8797014lab.17
        for <linux-wireless@vger.kernel.org>; Sat, 13 Jul 2013 22:03:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+icZUX9jvAcvEkKSsN-KU2GWxPVGg9Z=soecwJtPL0soHD4Zw@mail.gmail.com>
References: <001a01ce7fb1$75bfdc10$613f9430$@info>
	<CA+icZUVoZkg3nT6=SwTaLCWoa+v6aLkXSP5b71a0GmxMMWOyHA@mail.gmail.com>
	<001b01ce7fba$4bd15e20$e3741a60$@info>
	<CA+icZUX9jvAcvEkKSsN-KU2GWxPVGg9Z=soecwJtPL0soHD4Zw@mail.gmail.com>
Date: Sun, 14 Jul 2013 08:03:05 +0300
Message-ID: <CANUX_P2K9_q_FnkzDrn4=Y3rzn3FvkPjCB4qGmts=7kni9oW4A@mail.gmail.com> (sfid-20130714_070327_633164_CB03DC5B)
Subject: Re: Firmware error for Centrino N 2230
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: sedat.dilek@gmail.com
Cc: Cedric GROSS <cg@cgross.info>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>> > I’m trying to adapt current freebsd driver for supporting my 2230
>>> NIC.
>>> >
>>> > I try to follow ucode command order defined in kernel 3.2 but I reach
>>> > some difficulties because firmware raise error.
>>> >
>>> > Runtime uCode is alive. So far I sent calib result (cmd xB0),
>>> > configured advanced BT coexistence (cmd x9B,xCC and xCD) running
>>> > runtime calib (cmd
>>> > x65) but the command configuring valid chain (cmd x65) failed as the
>>> > result below :

cmd 0x65? it is not valid chain command.

1987 means that you haven't sent the Xtal calibration.

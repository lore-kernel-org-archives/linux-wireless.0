Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:63034 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbXJURwG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2007 13:52:06 -0400
Received: by nf-out-0910.google.com with SMTP id g13so816450nfb
        for <linux-wireless@vger.kernel.org>; Sun, 21 Oct 2007 10:52:04 -0700 (PDT)
Subject: Re: [Fwd: Problem with a Driver rt73 in ad-hoc mode between a arm
	and a pc]
From: Bruno =?ISO-8859-1?Q?V=E9tel?= <bvetel@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200710211820.13002.IvDoorn@gmail.com>
References: <1192979624.9056.23.camel@rigel.esas.fr>
	 <200710211745.18430.IvDoorn@gmail.com>
	 <1192982171.9056.34.camel@rigel.esas.fr>
	 <200710211820.13002.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Date: Sun, 21 Oct 2007 19:51:24 +0200
Message-Id: <1192989084.9056.40.camel@rigel.esas.fr> (sfid-20071021_185210_729091_9EFA6DC4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le dimanche 21 octobre 2007 =E0 18:20 +0200, Ivo van Doorn a =E9crit :
> Hi,

Hi

>=20
> > > Could you try using wireshark or a similar tool to see if beacons
> > > are correctly send out?
> > > There are similar reports regarding rt73 which suggests that in a=
dhoc
> > > mode
> > > the beacons are never being send out correctly.
> > >=20
> > With wireshark on the pc or tcpdump on the arm board, I don't see a=
ny
> > traffic.
>=20
> Just what I expected. Could you use attached script to create a dump =
of the
> registers. That way I can see if all beacon related registers have be=
en initialized.
>=20
I'm sorry but I can' find a file named chipset. I tried to find it
in /proc /sys and in my kernel on both my board and my PC.

Where can I find it  and what should I run the script. An information:
the debug mode of the arm board seems to tell me that beacons are
received

<7>RX beacon SA=3D00:18:f8:2c:b8:8d BSSID=3D62:e5:e1:83:a8:08
TSF=3D0xffffffffffffffff BCN=3D0x1bfa408de diff=3D-7510165727 @686761

 but I receive nothing at the ethernet level.



	Bruno

> Ivo

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:20152 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab3IEOYN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Sep 2013 10:24:13 -0400
Date: Thu, 5 Sep 2013 16:21:22 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org
Subject: Re: WARNING with ath9k_htc on TL-WN721N
Message-ID: <20130905142122.GE1570@ritirata.org> (sfid-20130905_162417_203347_FB06A98E)
References: <20130905100914.GA1570@ritirata.org>
 <52285C02.8050205@rempel-privat.de>
 <20130905103204.GB1570@ritirata.org>
 <52289033.8080205@rempel-privat.de>
 <52289080.80604@rempel-privat.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ZJcv+A0YCCLh2VIg"
In-Reply-To: <52289080.80604@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ZJcv+A0YCCLh2VIg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 05, 2013 at 04:09:04PM +0200, Oleksij Rempel wrote:
> Forgot attachment.
>=20
>=20
> Am 05.09.2013 16:07, schrieb Oleksij Rempel:
> > Hi,
> >
> > thank you.
> >
> > please do some tests for me.
> >
> > 1. run wireless adapter without other devices on this bus.
> >
> >> Bus 002 Device 003: ID 0cf3:9271 Atheros Communications, Inc. AR9271
> >> 802.11n
> >> Bus 002 Device 011: ID 03f0:8607 Hewlett-Packard Optical Mobile Mouse
> >> Bus 002 Device 005: ID 0403:6001 Future Technology Devices
> >> International, Ltd
> >> FT232 USB-Serial (UART) IC
> >> Bus 002 Device 006: ID 413c:8187 Dell Computer Corp. DW375 Bluetooth
> >> Module
> >
> > probably Bluetooth can't be removed, so disable it by software.
> >
> > 2. if this warning disappear, plug them back and rung kernel with
> > attached patch. I wont to see if this warning related to channel scan.
> >
> > 3. try latest wireless-next kernel
> > https://git.kernel.org/cgit/linux/kernel/git/linville/wireless-next.git/
> >
> > there are some patches which will affect usb communication, this will be
> > visible on your hardware, in good or bad way. Will see how it performs
> > in your situation.
> >
> > I assume this warning is related to usb bandwidth. Since we use BULK
> > transfer, we will get only rest of it. If other devices use ISO or
> > Interrupt, They well have priority.

Ok Oleksij, I'll try to do these tests soonish. You think the problem is
triggered by a scan operation?

If so, I'll try to reproduce it by scanning. Till now I had no clue about t=
he
cause.

Cheers,


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--ZJcv+A0YCCLh2VIg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSKJNiAAoJEADl0hg6qKeOLuIQAMZJEpkmn3+YDQH4AFn4eONB
+f8lPRJuKTqi0cPvz91fVng6DwrmlEJAH0SZrc+gQtXaF0QoFMBZtWUHs8oshAW9
oVUde57ozLLaUE86i7ivVFiMEAttGId+3kBQolzuIF7vdJnuV6Xr0iPPAHWdDixN
adfmuPQ+N4AW+SODjaXBTODA1UYNp8rgssmrCJEy/RorKTDdnBwMhWq2Rsye9iF0
tSpSBWe0Oh+AzN8tATLLZEcdYnXHEv73Z9y33uGd5BP7nD4/4msBevdTxABLt50Y
RNb+ZETLU+6NBpaXQwre1/SSHQZsWovlpBwsFgQDYPPmdSPlsRETqLrGTA5jKu4h
215yvR8nBVbMulEaSfxV0rB3vnHslorVK0covTOR+Ab8IXrPTW6B53g+78xqdaiE
JhTSAkN/unna4V1z6heHzBGtwmriEjoqJJQ3k/Uxcj+jzzETrbbmL/MDuAjIebJD
BXphH/4Gtr6RhHIy6f1gM7hzdH71KTWdOldF6FmHnhiFQYphJeOk0EZrRhUYRV0V
HdIHmQVs/0OXvOqERt+TjicO4ikJrOpwT4wY8P1AcIIXm/GYuJzYc+uuuhldGTCm
5B4R6otjBabKLy6WrvIzUM5DUMo/fZtkdCdNLkyHfE9SEllelbJ6cHfQoxq6pzab
rgOF8wnKlMPXen4tGU59
=bHDR
-----END PGP SIGNATURE-----

--ZJcv+A0YCCLh2VIg--

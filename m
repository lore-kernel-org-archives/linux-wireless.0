Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:27980 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab1JBIcu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 04:32:50 -0400
MIME-version: 1.0
Received: from TesterServ.TesterNet ([70.81.104.103])
 by VL-VM-MR002.ip.videotron.ca
 (Oracle Communications Messaging Exchange Server 7u4-22.01 64bit (built Apr 21
 2011)) with ESMTP id <0LSF004R8JGVPFC0@VL-VM-MR002.ip.videotron.ca> for
 linux-wireless@vger.kernel.org; Sun, 02 Oct 2011 04:26:55 -0400 (EDT)
Message-id: <1317544358.20966.1.camel@TesterBox.tester.ca> (sfid-20111002_103259_459859_D73406D2)
Subject: Re: Sometimes rtl8187 stops sending/receiving packets under load
From: Olivier =?ISO-8859-1?Q?Cr=EAte?= <olivier.crete@ocrete.ca>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 02 Oct 2011 04:32:38 -0400
References: <1310851053.5700.14.camel@TesterBox.tester.ca>
 <4E221A18.2070504@lwfinger.net> <1310864785.3540.5.camel@TesterBox.tester.ca>
 <4E228ADC.70606@01019freenet.de>
 <1313809445.12189.2.camel@TesterBox.tester.ca> <4E4F27A1.3050608@lwfinger.net>
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-kcPP/t96UQd1kRkRA0wc"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kcPP/t96UQd1kRkRA0wc
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2011-09-02 at 12:01 -0400, Olivier Cr=EAte wrote:
> Hi,
>=20
> On Fri, 2011-08-19 at 22:18 -0500, Larry Finger wrote:
> > I have 3 different devices that use either the RTL8187L or RTL8187B chi=
ps and=20
> > the rtl8187 driver. None of them have any problems of the type you desc=
ribe,=20
> > thus you may have either a screwy AP, or excessive interference. Have y=
ou tried=20
> > changing the channel to another of the set of 1, 6, 11, or have you tri=
ed with a=20
> > different AP?
>=20
> I tried with a different AP (some DLink with the stock firmware) instead
> of the WRT54Gv2 and the driver also fails after a while... Seems like an
> annoying issue to debug.. I'm tempted to believe that maybe it's an
> hardware issue maybe, I should do some stress testing in Windows maybe.

I've also noticed that just before it all goes horribly wrong, I start
missing events from my USB HID mouse.. Maybe its a usb host controller
bug or something.. hard to debug.


--=20
Olivier Cr=EAte
olivier.crete@ocrete.ca

--=-kcPP/t96UQd1kRkRA0wc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEABECAAYFAk6IIaYACgkQHTiOWk7Zortw6wCdEmxPvTZmW2CYzf2Op5NcVpDh
jTUAnA/Cjj8xCwVQX7wjV4qwk+czj620
=XKbP
-----END PGP SIGNATURE-----

--=-kcPP/t96UQd1kRkRA0wc--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailguard.fgan.de ([128.7.3.5]:54958 "EHLO mailguard.fgan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab0AZN2U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 08:28:20 -0500
From: Henning Rogge <henning.rogge@fkie.fraunhofer.de>
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: Network QoS support in applications
Date: Tue, 26 Jan 2010 14:06:59 +0100
Cc: David Miller <davem@davemloft.net>, kaber@trash.net,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
References: <87k4v5nuej.fsf@purkki.valot.fi> <20100126.041610.226004766.davem@davemloft.net> <87wrz5m3cd.fsf@purkki.valot.fi>
In-Reply-To: <87wrz5m3cd.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4303306.S5F0AqoMOV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201001261407.04947.henning.rogge@fkie.fraunhofer.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4303306.S5F0AqoMOV
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue January 26 2010 13:56:50 Kalle Valo wrote:
> So the idea is that the three left most bits (Class Selector
> Codepoints from DiffServ RFC 2474) would contain these values from
> IEEE 802.1d-2004 Annex G:
>=20
> 0 best effort
> 1 background
> 2 (spare)
> 3 excellent effort
> 4 controlled load
> 5 video
> 6 voice
> 7 network control
>=20
> What do people think of this?
The IETF is discussing about a traffic priority below "best effort" for bul=
k=20
traffic at the moment. Something you use to fill up links if your can but d=
rop it=20
if you are not sure. So it might be a good idea to make "best efford" not z=
ero.

Henning Rogge
=2D-=20
Diplom-Informatiker Henning Rogge , Fraunhofer-Institut f=FCr
Kommunikation, Informationsverarbeitung und Ergonomie FKIE
Kommunikationssysteme (KOM)
Neuenahrer Stra=DFe 20, 53343 Wachtberg, Germany
Telefon +49 228 9435-263,   Fax +49 228 9435 685
mailto:henning.rogge@fkie.fraunhofer.de http://www.fkie.fraunhofer.de
GPG: E1C6 0914 490B 3909 D944 F80D 4487 C67C 55EC CFE0

--nextPart4303306.S5F0AqoMOV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkte6PMACgkQRIfGfFXsz+C3owCgqAiF1R5lHUH0jHj48EwGUkN4
v6AAn23wy074YEgEveL/oLG8Lj+DGiuj
=+63I
-----END PGP SIGNATURE-----

--nextPart4303306.S5F0AqoMOV--

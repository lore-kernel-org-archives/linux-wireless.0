Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:46186 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754565AbYCaUWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 16:22:00 -0400
Received: from ironport-out-2.rz.rwth-aachen.de ([134.130.3.59])
 by mta-2.ms.rz.RWTH-Aachen.de
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JYM00ED21UM0R80@mta-2.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Mon, 31 Mar 2008 21:51:58 +0200 (CEST)
Date: Mon, 31 Mar 2008 21:51:57 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: mac80211 bug? no data is being transmitted after interface is
 brought down and then up again
In-reply-to: <20080331190225.GA12933@tuxdriver.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Message-id: <47F140DD.9050709@archlinux.org> (sfid-20080331_212206_525808_82670D9F)
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary=------------enig9C20D7E83AEFEAD1991CB619
References: <fsm20k$usk$1@ger.gmane.org> <20080331190225.GA12933@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9C20D7E83AEFEAD1991CB619
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

John W. Linville schrieb:
>> 1) Everything works as before
>> 2) Nothing works, but the card disassociates from the network.
>=20
> #2 would be my vote.

Fine by me, as long as I don't spend 6 months again trying to make my=20
wireless work :)

>> The current behaviour (card stays associated, but no data is transmitt=
ed=20
>> any more) is unintuitive and costed me much time.
>=20
> Seems like a bug to me.  Would you mind opening a bug at
> bugzilla.kernel.org?

Good, opened a report:
http://bugzilla.kernel.org/show_bug.cgi?id=3D10372


--------------enig9C20D7E83AEFEAD1991CB619
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEAREIAAYFAkfxQN0ACgkQEda5KzHP/VBJrACg0bKMNgQRVJAS2slDHP7KwrSu
oBoAn1d/gHoPReEXCB+lZVMnUgl3psNN
=S6T8
-----END PGP SIGNATURE-----

--------------enig9C20D7E83AEFEAD1991CB619--

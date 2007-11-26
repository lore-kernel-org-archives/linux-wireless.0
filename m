Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49862 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbXKZPwr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 10:52:47 -0500
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
From: Johannes Berg <johannes@sipsolutions.net>
To: dragoran <drago01@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>, Jouni Malinen <j@w1.fi>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <f6ca9fed0711260650j749de7a3x3edc084ae820d2eb@mail.gmail.com> (sfid-20071126_145009_936981_8E94FA2D)
References: <47494851.4070504@gmail.com>
	 <1195987773.4149.214.camel@johannes.berg> <474955E1.30603@gmail.com>
	 <f6ca9fed0711260650j749de7a3x3edc084ae820d2eb@mail.gmail.com>
	 (sfid-20071126_145009_936981_8E94FA2D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZFvwNqi1Ngp9Ui4arURb"
Date: Mon, 26 Nov 2007 16:52:39 +0100
Message-Id: <1196092359.4149.278.camel@johannes.berg> (sfid-20071126_155250_295501_4FC389A6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZFvwNqi1Ngp9Ui4arURb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-11-26 at 15:50 +0100, dragoran wrote:
> btw would it make sense to ratelimit
>=20
> "WEP decrypt failed (ICV)" messages?
> they are a bit annoying when connected to this network...
>=20
> dmesg  | grep ICV | wc -l
> 3489
>=20
> after some minutes.

I think they're only shown in a DEBUG config, no?

johannes

--=-ZFvwNqi1Ngp9Ui4arURb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0rrxqVg1VMiehFYAQKawhAAwpoRpAxPkbXBUMco6TQnlgeNbO+c9iDx
PGjmuRG4ghLyCBn57lDueZwkPa7BEzovmAJpoqPP1XtWDf8CwvroB2+RQjt6GFr7
kVG78sbNPDx1TCOpHLf9SdBICF+5MWLVoDdCIa+CnyxSCXRaVvfIM/+U8+z+tYf3
1Fq+gqTEk3TgTE6bCHBGeIJkG+GYbqwQTrJmTQw2OzdA74Fwgqru+vjhInDC6tut
DtuMpXMUQHGJN4B76C3YwCqYSBmxgyP52cqt9IMhKh5RksPihRIDKPHe07rWAEOt
6fuK5t9gcN8u3yuiwavvj0VvzBJ0AixMnzSYs0f5MsLTRHuCc2hWhG4L7PjpXBb2
o8fl0Gy12Ysvo8IvJIAX/fxx1Ur8+s0+Ylhusg0ws+2Nvlo0HeIhIq0AFPusGBkD
to/rrlhkTt4rFGpv5qoKmu5zFZXkjdsU7FPZWj4LkiLCCkxVLb8udBHdH3q3JrTU
h5+RzQspc/Rb5iMO6qMquuOVQEFB3LWrtIFGbY5DxpWJvvi0llb6Y3S2Mlu+s/Be
7+Ohk90CY869wt5/C2/vs9OTDuNfDSm27mjIenTVMKz3FkL11T483gDr1X3bJG0b
KbsnzELbX8HRJCJ935LJJh8oYnxoRU/e45XDyaAzqvNy78WUfGqLX7SGI9rFpAUL
QH3Wrd2nUkA=
=AHh8
-----END PGP SIGNATURE-----

--=-ZFvwNqi1Ngp9Ui4arURb--


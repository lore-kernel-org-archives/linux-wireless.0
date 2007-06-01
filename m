Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33069 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761888AbXFATMi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 15:12:38 -0400
Subject: Re: [PATCH] softmac: use list_for_each_entry
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Joe Jezak <josejx@gentoo.org>, Daniel Drake <dsd@gentoo.org>
In-Reply-To: <46604279.3070908@lwfinger.net>
References: <20070527142740.GB13105@APFDCB5C>
	 <1180643064.18266.2.camel@johannes.berg>  <46604279.3070908@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OduplpoKLcap0PC3iCMx"
Date: Fri, 01 Jun 2007 21:12:49 +0200
Message-Id: <1180725169.11026.29.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OduplpoKLcap0PC3iCMx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-06-01 at 10:59 -0500, Larry Finger wrote:

> As it is impossible to predict how long until we can remove softmac, such=
 patches should be=20
> accepted.

Oh of course! I do agree with both patches, I hope they're applied. If
you want:
Acked-by: Johannes Berg <johannes@sipsolutions.net>

> As we discussed earlier, bcm43xx-softmac has to be ported to mac80211 to =
support 802.11b-only cards,=20
> as the V4 firmware does not accommodate them. I had started this project =
by changing the namespace=20
> to bcm4301. That patch went into Linville's wireless-dev pending list. I =
then started learning the=20
> interface to mac80211. For a number of reasons, that step was going slowl=
y. Michael Wu recently=20
> offered to take over, which seemed reasonable given his familiarity with =
mac80211.
>=20
> When Michael Wu gets a version of bcm4301-mac80211 that compiles cleanly,=
 I will be testing it as he=20
> doesn't have the hardware. For my testing purposes, the 802.11g stuff wil=
l still be there. Once I=20
> get it working, I plan to post a patch to get as much testing as possible=
..
>=20
> In the earlier discussion, we also concluded that the product of a conver=
sion from softmac to=20
> mac80211 should not be included in mainline, with the exception of the b-=
only code. Depending on how=20
> long the port and testing take, and the state of bcm43xx-mac80211 at that=
 time, a reversal of that=20
> earlier decision may be in order.

I'd think that once somebody has time for it both port and testing
should go pretty soon, and I'd think that we can do that sooner than fix
the current bcm43xx-mac80211, in which case IMHO the result should be
included in mainline seeing that zd1211rw will probably be ready for
mac80211 in the .23 timeframe. That means that at that point we might
even be able to drop softmac already if the second straightforward (here
I mean without any other changes to the driver) bcm43xx port is ready :)

johannes

--=-OduplpoKLcap0PC3iCMx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGYG+w/ETPhpq3jKURAqUQAJwNY95ZBoZ50rXszl3m/+R4OLBSwwCfQ0mk
rsCna5cm4oCMr1Sp8OD1F4c=
=U6qY
-----END PGP SIGNATURE-----

--=-OduplpoKLcap0PC3iCMx--


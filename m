Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54749 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbYHGReu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 13:34:50 -0400
Subject: Re: mac80211/cfg80211: Add BSS configuration options for AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080807171742.GB21060@jm.kir.nu>
References: <20080807170701.GA21060@jm.kir.nu>
	 <1218129093.3630.15.camel@johannes.berg> <20080807171742.GB21060@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ArjUltn2vuA7u+PiRVU+"
Date: Thu, 07 Aug 2008 19:34:05 +0200
Message-Id: <1218130445.3630.17.camel@johannes.berg> (sfid-20080807_193453_822220_8296C641)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ArjUltn2vuA7u+PiRVU+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-07 at 20:17 +0300, Jouni Malinen wrote:
> On Thu, Aug 07, 2008 at 07:11:33PM +0200, Johannes Berg wrote:
>=20
> > I guess we'll also need to make the mlme code actually use it, as it
> > stands it looks like we never enable short slot. Oh well, later.
>=20
> Yes.. I tried applying your patch
> (013-BROKEN-mac80211-bss-slot-time.patch) for this and the results were
> enough to convince me that I do not want to do it today as part of the
> AP mode patch ;-):

Heh, yes, I know, never bothered to save it from bitrotting.

> I did not look into details at how much work would be needed to make
> this apply cleanly, but I would expect this to be relatively simple
> change.

Oh, you probably don't want to even try to apply this patch, I think the
code it was against has changed. If someone was to try to add the
appropriate short slot handling for the mlme, it'd be easier to just
implement it based on the new hooks your patch added.

johannes

--=-ArjUltn2vuA7u+PiRVU+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImzIKAAoJEKVg1VMiehFYINsP/0Z+V05kWtGXKrod2stRw8tv
1DpoxGS7jCIybjd8sKVn2gq+WCFP4jU6XZeCwKsqqT/WaOZyrrn1meDuW7lkMHkl
SkaU2kuUItKid4XJ3ZfX0DHio4enShhh/XbVLB6E65pXD7d1MP5nl4ly8xaxTYgm
odWrtB4ODh2plwEzyLsvsIIoVW7aZgbHdFwmWbvhIP6ufdlOwKxOBab1Kro6LskK
0Qrb0nteJlmVkTDDbqhO52fEaieRHf6D/3f+53AdqNPQiew4DlfulPi6v6lIV0Xk
y0+5loa2fHH2PQEZrX4LUxpX+2jSzn1oeqE5VpDxx6wc7NxHd36Gv16eub8v6Pa7
lYdPMsxQoFoF14UeEJryEsOyJ2FTNpKeEF4tTsuiDSy7FKw/0w3yiB72L9TibsGN
/dp3VJMqoBS8rtyY/IkDhSQxS6VUYYguqjpQZRKXuF8CRLju6nZI/rMHu/oGDMaJ
pI9D4RSCM6OjzjDMmaYWGJxBroxWoeDS4Wyg8pdDV7R3BvPncil1a/xWVzXSSopg
QIsMoKvTdBvDEtT4DnybN3JAmmV7G9AqweIQFPAx/Ju6Jr7pLlUO7HG4z6qaZdzE
qV9LdqwdkCPyevukP49UO068R9mMsEO5aZEZ01KgZ3XwP/Pk5DN65ad9BSz3WIKa
RkA2pJQA8e0qEaXB2aZB
=Jb2l
-----END PGP SIGNATURE-----

--=-ArjUltn2vuA7u+PiRVU+--


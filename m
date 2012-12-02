Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58078 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751628Ab2LBDfy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Dec 2012 22:35:54 -0500
Message-ID: <1354419340.7995.52.camel@deadeye.wl.decadent.org.uk> (sfid-20121202_043605_523851_138A7294)
Subject: Re: [3.2.y] Re: [PATCH 2/2] brcm80211: smac: only print block-ack
 timeout message at trace level
From: Ben Hutchings <ben@decadent.org.uk>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: stable@vger.kernel.org, Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Touko Korpela <touko.korpela@iki.fi>,
	linux-wireless@vger.kernel.org
Date: Sun, 02 Dec 2012 03:35:40 +0000
In-Reply-To: <20121124231438.GA26176@elie.Belkin>
References: <1330018703-2472-1-git-send-email-arend@broadcom.com>
	 <1330018703-2472-3-git-send-email-arend@broadcom.com>
	 <20121124231438.GA26176@elie.Belkin>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-fhHulY2XHxX5apPD5G2y"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fhHulY2XHxX5apPD5G2y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-11-24 at 15:14 -0800, Jonathan Nieder wrote:
> Hi Ben,
>=20
> Please consider
>=20
>   2b0a53d51b5f brcm80211: smac: only print block-ack timeout message
>                at trace level
>=20
> for application to the 3.2.y tree.
>=20
> It just lowers the priority of a distracting repeated message about a
> normal condition:
>=20
>   ieee80211 phy0: AMPDU status: BA Timeout, seq 152, in_transit 0
>=20
> See <http://bugs.debian.org/674430> for context.
>=20
> The patch was applied upstream during the 3.3-rc7 cycle.  Applying it
> should make debugging other problems easier.  Thoughts of all kinds
> welcome, as always.

Added to the queue, thanks.

Ben.

--=20
Ben Hutchings
It is easier to change the specification to fit the program than vice versa=
.

--=-fhHulY2XHxX5apPD5G2y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAULrMjOe/yOyVhhEJAQptYQ/+PwjCRBobI2YJ79VtB5cZ6jIBCq1oVQYf
EavNLgdudEiX7rKQ2DuBpGNk8++dj7jF9eHKUP/r/ZX5lkNsRAGWBwD9WqbzQ3Mf
W5RBCI4lgjgX3Ng9E/G9I7x2yOT77dEdAKlVUfWcJeONmNVM5oikKm0XZ/YsLe/X
569aU9vt8+Fzl+81rBp1OYiX7BuvDbP0zhh+32AwR2ng0GM3RxQ+m0xAoM4cvOIu
8+viOt0w4AUwFbUsb9NaK13IkiaK3d0Sg8mQqehNKWO7h75u5nPD/fQI+M3pNbtz
ncSsDMOYhDRR1eBrgokS6oKvMQhby2Eg12vFG3WZX0dFZwvt0cW7mNDS+XEua16c
RFTAEvxJIikv5+1qpoQrucH1ZE6OP14fqM2YaeDwjdadD+a3j1mapCFH0aPjKM9y
VqQW2VcEdhVCUN34KjE3SfLyp4sMghCGzLuSfSw3BQKfN8xZUsps4WqnVDsumLjb
0Jbu8BddOb6ovvsgPR2hY2KhsBDf1aJqWQ7JxTgsbut/fJLM0QQaGaYki7O8SFN7
LT2kPXDEpI0EgFTZEt5GwPm7458ItarUjKub/q1RCIBYKD7TSPbPp6tCEMV2vDmH
5eeJODfRzdV6lyLhB3x8V8dK5iiHTqyuYGkTpPAB2DTHmV9YYMGUSI8SG268eCiN
MAKKKBq7UEs=
=7uc/
-----END PGP SIGNATURE-----

--=-fhHulY2XHxX5apPD5G2y--

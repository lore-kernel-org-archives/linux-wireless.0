Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59079 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbZEXRZZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 May 2009 13:25:25 -0400
Subject: Re: [PATCH 5/5] libertas: fix WPA adhoc network creation
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1243171190.24236.1.camel@localhost.localdomain>
References: <1243037398.2495.14.camel@localhost.localdomain>
	 <1243067061.4606.43.camel@johannes.local>
	 <1243171190.24236.1.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/FizHKJ2rXl9lAkBG2Xk"
Date: Sun, 24 May 2009 19:24:46 +0200
Message-Id: <1243185886.29222.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/FizHKJ2rXl9lAkBG2Xk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-05-24 at 09:19 -0400, Dan Williams wrote:
> On Sat, 2009-05-23 at 10:24 +0200, Johannes Berg wrote:
> > On Fri, 2009-05-22 at 20:09 -0400, Dan Williams wrote:
> > > Oddly enough, the firmware's JOIN/START commands don't appear to have
> > > any facility for setting custom IEs, thus the started adhoc network
> > > doesn't advertise its WPA capability in the beacon.  Whee!
> >=20
> > We don't even properly support WPA IBSS in mac80211...
>=20
> Hmm, I support creating WPA-PSK adhoc networks in the NM UI (worked last
> summer when I added the code), can you give a 10 second summary of
> what's missing here?

Hm, well, Jouni says it doesn't play well with XP or Vista and we don't
have per-station group keys we'd need in theory.

johannes

--=-/FizHKJ2rXl9lAkBG2Xk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKGYLbAAoJEODzc/N7+QmaV7UQANQnKwxvUubcmT/lwV4PFbHt
namtQqmUe1DcesbIbpMvbMlm/YGnhRhdSBuX/W3+vyaXxXRiv3bm86MfR8ASn+JA
cNDAvEV53WYQ9coc6yZ9igIKQ8AOdYZBmCxg7oirfuQLAqmT6GS6CR8lTWJpdwjL
nicTyeI7/05t1Ascj3OhBeXfG+jFMr9XLXybXo4Tksg0Z1uJj7ksc3PM7BRoZcrt
W/vVmch9f9m/fkLA1pRF51F5gufz5AfJ75rPlvUNSG9MZZd5GpsSj4xTS/9EqNRF
GPStKjCvotWVTuupaiAN1JDS4Pkc1s9JYombuHP+Grn2kgkyC1p78fHAeHbLIgM0
6yZlk+NyVDh74V08W89plwbIV6tA330wRkEUncEYbUXe2i05JNuIwgC6HAVKAiB7
dIlwroYcFKBEFoXtzBvvL5EM6xGmb8mo/ECu5PBaydry6J8R/5NploP9Orf89E5Z
RJlPYseBj9gmoGkbpFu5HOPQwfNhNfc361tYtCLfvUBQ0cPNswYgA3greVYY3uYL
krmjuJNhOqG7Mt3CcugQLNXEVaVy8NZkL4HZ5PRQRx7zI3ohtST/tcgox17Ff0IF
uf+ZlfOOqvNmDrlr8vfP6k3T6tU+6iEL2MP/K3RsQZtTmxQqPJ4GTetA+GfNR3FS
YkByRlLoLcQJWJGW+QTD
=K/F2
-----END PGP SIGNATURE-----

--=-/FizHKJ2rXl9lAkBG2Xk--


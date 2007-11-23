Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40208 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbXKWV5o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 16:57:44 -0500
Subject: Re: timeout problems with certain APs and b43
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: bcm43xx-dev@lists.berlios.de, "John H." <mistamaila@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
In-Reply-To: <200711232258.25965.rjw@sisk.pl> (sfid-20071123_214335_768868_45E88660)
References: <5b9417770711211135p65eab873leef65cd0e71452aa@mail.gmail.com>
	 <1195812310.4149.73.camel@johannes.berg>  <200711232258.25965.rjw@sisk.pl>
	 (sfid-20071123_214335_768868_45E88660)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vuEuRFOTa9NZ0wSkGdGE"
Date: Fri, 23 Nov 2007 22:57:30 +0100
Message-Id: <1195855050.4149.179.camel@johannes.berg> (sfid-20071123_215747_659643_3E6A6471)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vuEuRFOTa9NZ0wSkGdGE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > on certain APs, the internet works for a long time then stops, and I
> > > get authentication time outs, why?  It usually works again if I reset
> > > the AP itself, which i should not have to do and don't have to if in
> > > XP....
> >=20
> > > wlan0: Initial auth_alg=3D0
> > > wlan0: authenticate with AP 00:0f:66:53:3e:24
> > > wlan0: authenticate with AP 00:0f:66:53:3e:24
> > > wlan0: authenticate with AP 00:0f:66:53:3e:24
> > > wlan0: authentication with AP 00:0f:66:53:3e:24 timed out
> >=20
> > Does it help to reload the b43 module? I think I have seen this problem
> > before but always associated it with suspend/resume rather than a long
> > time elapsing, I also thought it was due to bad power recalibration.
>=20
> It seems that I can reproduce something similar on demand with an SMC wir=
eless
> router by moving my box sufficiently far away from it. :-)

Well, yeah, that's expected though, you lose signal at some point. Not
expected is that it happens without moving anything. Unless the
calibration code is wrong which wouldn't really surprise me either.

johannes

--=-vuEuRFOTa9NZ0wSkGdGE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0dMyaVg1VMiehFYAQLDxw//X1h9gWn9NNBzwoPdqJeFOsiVbFTG0yPv
6jbA1bGLGT61iPVHff2VdUiSYd4RzbElTwJjfd9zo8k1xg7UDPZVfpdmMVrmpkKB
yFYEQoCDVZJC6ot0gGoHBeN50v1OItLqDnFsvvLU0kYEAsJVFeKCtJw8sgB0atmn
hBoZtN/aiOrAyFhuz0/JJC/7O8w8Xr/u6bHNIetVfKmnqqQImQpMUN+VzN3z7dk6
vf1titjVyLQbQCcN835NcrWiHpgaj/gnUyNMtTlMeetb2KRplq8o0XMePP/0MqGz
d1ffql/yTsECxYkF5l0rnQ31CgA973Dsk/yp+kvX5uB4k2bsuxt7zGJJh/85bHI5
v/pgbYTVNwni+cMXHAns9XMzSw/24S4st6odCPLtCFqcYVCU37wjhOMMBRq1aLrr
P26Hyh9n/DuDQ9KDO+BSkEixL+grz1MeVh736ZaAzdtzjd50vC/uF9e5M3YNpUnx
erS5mrmNDbdvOJwE/NNTGGp5KtnsqTRxxAxJI/yeL4WjQ0pSqdUo5nseLi0yq+aJ
ftUq/3WOZNiqwD+BUxDey+rVK8agro5uaDpwDkoXyqg+e0PqDM1W6t/P1otpFuCI
1VDaLzlthcmW8Uiyr//Wk6nFeW3DVrC0Y/pmdjfhbt2Q0XI5pBgsl3aOpv76Oy9b
mqKk9DRo2zE=
=q/qk
-----END PGP SIGNATURE-----

--=-vuEuRFOTa9NZ0wSkGdGE--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49642 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbYEMKHV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 06:07:21 -0400
Subject: Re: dynamic wep with mulitple keys
From: Johannes Berg <johannes@sipsolutions.net>
To: drago01 <drago01@gmail.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	Volker Braun <vbraun@physics.upenn.edu>,
	Linux Wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <f6ca9fed0805130244x648325a3k2ae7b77fa610ca6d@mail.gmail.com> (sfid-20080513_114503_459511_D50D0D96)
References: <1208969544.3312.5.camel@localhost.localdomain>
	 <8704f27d0805060032g2312e7dcwc19f382c431e6cd3@mail.gmail.com>
	 <f6ca9fed0805060510l36c72666v414dfd989625d18e@mail.gmail.com>
	 <8704f27d0805060514i59db36f0t9801fab7543b8655@mail.gmail.com>
	 <f6ca9fed0805120447wf6c1c38mea24ba587dc834d4@mail.gmail.com>
	 <1ba2fa240805120507r2914d23dt6826a732730fea49@mail.gmail.com>
	 <f6ca9fed0805120510yec6ba9fge41c46d2d01c236a@mail.gmail.com>
	 <1ba2fa240805120522m26904f72l45941b1beb411e60@mail.gmail.com>
	 <f6ca9fed0805120538k75a953acrc1cd251efe9bbe1b@mail.gmail.com>
	 <1210670668.3646.56.camel@johannes.berg>
	 <f6ca9fed0805130244x648325a3k2ae7b77fa610ca6d@mail.gmail.com>
	 (sfid-20080513_114503_459511_D50D0D96)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FVvpqzGClEo7nVg3e/n7"
Date: Tue, 13 May 2008 12:07:08 +0200
Message-Id: <1210673228.3646.60.camel@johannes.berg> (sfid-20080513_120726_531351_575CFFA2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FVvpqzGClEo7nVg3e/n7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> The problem is that when connecting to a dynamic wep network which
> uses multiple keys iwl3945 fails to get a dhcp lease. (See
> http://marc.info/?l=3Dlinux-wireless&m=3D120699235803881&w=3D2)
> Volker had the same problem with iwl4965.  But when turning off
> hwcrypto and therefore use the mac80211 code it works for him.
> iwl3945 does not use hwcrypto by default (and when I enable it it does
> not work either) but fails. Both should be using the same code
> (mac80211) but one driver works and the other doesn't which is odd.

I haven't got a clue. Are those identical networks?

johannes

--=-FVvpqzGClEo7nVg3e/n7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCloSqVg1VMiehFYAQL6Bg//U92w0HTk8tZMzCjnHx7FQ8oURZyplj6/
Wn2F3reB4cFw/y4qHTnaQm0k90uRv5zgvxFbmqRIvuiQJ9AH1XvwAqCZr+k3hEZb
vUTl98r3tYMHEGCJ5JqiI2zQu5oZyvj0uAUnQxlV/ifGpL6E11abB9ocnYftrCCw
4JW6XT87kgkIYx63Krit0d0s9HoYKLPymFD7Hk38puiLJKPpHXPVGqaL4DQdy52F
S0bG32SygPvlKlEbXB8SVSbCbMn/k2LtqEDYFxpJFPCyudi601pUwfq2KzdjIBim
sw7qIb+PQn1CFxW1iqgbxjGRvYPwInSZazWmcDGUDqKy6F6RV8Qsdmd9ackiIu+8
ubhaGIni2DXl9lEQjM0+sAjca9Jb4/6VIJzBWZYJAo9uXvr0cEdy1yTbLk+t2OtU
vxIqNZP0GuKCxw38SAJqwOUN/+kepIZ4rpvzHHIBfuvaO/fXW5KHB8W0fHSxY7Uu
cGYvv3jGEUE5KIZoh+OfJ3Iye4Wye3FNOY+MtLCWO0haN8oVoDCcDvk6AG1nx4tO
uo/GtzdkWjJnHA2jLOBLPwBLI+ti/b1XqdrcjLAJUqDSXPgYedUg3aP1G+DiSfLq
ia5TUP3s/mLNh0xvpr8LIhMUQlnn0+WoIVFkWYk/UMRv9pa1PXoX+BHtaiMvU1I1
Pb24FUFKYTE=
=XGSC
-----END PGP SIGNATURE-----

--=-FVvpqzGClEo7nVg3e/n7--


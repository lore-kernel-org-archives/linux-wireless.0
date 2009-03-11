Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58546 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbZCKMkB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 08:40:01 -0400
Subject: Re: [PATCH] mac80211: ieee80211_ibss_commit() cleanup
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090310224427.223760@gmx.net> (sfid-20090310_234458_784141_4631D28F)
References: <20090309234946.99940@gmx.net>
	 (sfid-20090310_005017_999744_57F45C40) <1236669682.9658.34.camel@johannes.local>
	 <20090310224427.223760@gmx.net> (sfid-20090310_234458_784141_4631D28F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wtbtEgn8OYZ10UkPS3N4"
Date: Wed, 11 Mar 2009 12:53:30 +0100
Message-Id: <1236772410.20266.7.camel@johannes.local> (sfid-20090311_134028_274588_13D3553D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wtbtEgn8OYZ10UkPS3N4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-10 at 23:44 +0100, Alina Friedrichsen wrote:
> Hello!
>=20
> > And now to explain why this is desired?
>=20
> For unification with the STA implementation=20

FWIW, I don't see that as something that is necessarily desirable, I've
split them up to allow them to diverge further and in a manageable way.

> and besides it fixes a bug, that ieee80211_sta_find_ibss() is
> triggered while the interface is down and do some strange things that
> it shouldn't do in this interface state.

Indeed, good point, that can happen without this patch.

johannes

--=-wtbtEgn8OYZ10UkPS3N4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJt6Y3AAoJEKVg1VMiehFYS3gP/RK6is6LtgrnvIm0Hd7v3xdO
rW9+0pD0NtNGo/1cI0uXMKkfzIU/EFLCaw6Skr4oJ+i2FaOs0D11YJfOJSljjCX4
6buSKs0ToaAZGmsadjlkwoOEpHnlRlLqhmFUlCX8zU/Z2aX5GaUWhOy2lvsWipjD
k8/G2By/jVySNX9Sbt6f3D7e+PiQgC54Ya16LncR4uYmKHOlrDXe+F1P040zPoWs
75W3CaG9lqQjgcpILGmQsHAaW23wv7KET6VkhL8XmN5YVMsr7+rzZDEgZxiyTkfN
cFpZknuQOZ58lFE+SSvcf52/LoWl4fW6ujW3oiIuXl4BJrkUS/AE+q6z8KHrZ95B
HI42pmWLCnnKdHVCTZyXqXeXrxpOZBXyF3mF1N5SdtndXw0amQWutVLF/yAtmieD
PZSsTv9nrOJjTiVyiE+B0mHjDZ3k33dbfn9NbCtuGL+QFZWlxCkbMX6HF1S1Gcj3
9+HjOwJ9tO5SX+IQrSv72ln9XYH8ZbKHMUFpPPXtd9XDnH2mL7ahziRFBagmCmIG
Wh0IvgWjLpX7cN9rGdOWyXbLGs/QXiLkLHv232NGurids16x2wpWLBwBvsgLeTrW
fBIodzJi7Z21h+8lh8TSaK64X26Sua+rZL2+P8SVevwHWYE1c33nxjC7UoTH1Gul
AR9N4qW2nMy9VnUqATFM
=r4ny
-----END PGP SIGNATURE-----

--=-wtbtEgn8OYZ10UkPS3N4--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35007 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267AbXLNMRw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2007 07:17:52 -0500
Subject: Re: privacy_invoked in AP interfaces?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20071214045404.GC5698@jm.kir.nu>
References: <1197453187.6558.88.camel@johannes.berg>
	 <20071214045404.GC5698@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zarGo4NXfKBex/FklyjN"
Date: Fri, 14 Dec 2007 13:14:29 +0100
Message-Id: <1197634470.16079.38.camel@johannes.berg> (sfid-20071214_121804_370648_B521E229)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zarGo4NXfKBex/FklyjN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > I was just testing hostapd and it told me:
> > Could not set PrivacyInvoked for interface wlan0
> >=20
> > This is because we only allow setting that for STA interfaces, but what
> > should the setting do for AP interfaces? I don't see any point in it, i=
s
> > there?
>=20
> The only use for it in the AP mode is to support drivers (or well, more
> likely firmware designs) that insist on generating the Beacon (and Probe
> Response) frames themselves. I would be fine with net/mac80211 not
> supporting such designs, but it would probably be better to continue to
> support this in hostapd (and make it possible to do this with
> cfg/nl80211, too).

Ok, thanks for the clarification.

johannes

--=-zarGo4NXfKBex/FklyjN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2JzpKVg1VMiehFYAQI3LBAAjzcgKZdk+n7ZhN6tb1cxalY2941+T4fO
wU+loj/vCw6UQjidCIODozacMSuFUVXxAAp+ypyH4PHCIxV9Xx5IjQid/vdIoIqh
J6lASgvj+uTchqcU01zJfqtXagcFwTeGC8T+ZKO+lqb4TnVNvMFg50OvP9RBAA07
Wlth6iqS52B1zq9nIysZPJniTaY6NrB5yt2SbWkXWHyhnoDcNJ8haCFqxYqA97kg
D86RZZoTJYlWxs9y7QPt00vWUwSBMxLRMFZI8oHM1oFslaDDpQ/197Kq6GcZbsiz
8DXtt1dqkePFkMnZ3roFalR5P8llaVKXUdjVXvvgcVzb6qctAyyGYIeYtSHMmdVP
Dx770Cl6bXin97klhIwXQDGYfOT2ZKy2kfMxklSCwFRcbYxZzLpCwvdmWh/BtuaZ
FBLe5SA0IBjA/Wvp26Bhdvn5UQx2NGp88G/xU2omyp6w64C3sKFJAbX2ZAejSFZ6
rIeK6qmzNBwRsfoLV4grisvGRfZx6qVrvN44JsVTDIboBe94lf81IYPjkfQaQC8d
uSpUYyQ+pNufxOuQLLfnVETzmB/c4HdlngMGKlcigdJunOwfyMQTa//PUt0s/X1v
IVI3r65HRTcEpd/osrUdUlsqHCzFsumL67L8WEEEvxbHf7K1XaYBMHaG7NxJFm83
YMeFBoQtPrg=
=ITBl
-----END PGP SIGNATURE-----

--=-zarGo4NXfKBex/FklyjN--


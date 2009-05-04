Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59459 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757121AbZEDPd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 11:33:27 -0400
Subject: Re: IEEE80211 Acknowledgement
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Alexandre Becholey <alexandre@shockfish.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200905041729.13805.IvDoorn@gmail.com>
References: <49FF06BB.2090106@shockfish.com>
	 <200905041729.13805.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lFn9Uqrf+H/g+03Kp4sD"
Date: Mon, 04 May 2009 17:32:54 +0200
Message-Id: <1241451174.8683.48.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lFn9Uqrf+H/g+03Kp4sD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-04 at 17:29 +0200, Ivo van Doorn wrote:
> Hi,
>=20
> Just as side information for other readers:
>=20
> Alexandre is looking into the problem of rt2500usb/rt73usb and
> possibly other USB drivers, that they cannot report the ACK status
> of frames to mac80211 which is problematic for hostapd.

I realise that this probably doesn't help and is tangential to the
question being asked, but I do not think processing ACK frames in
software is possible for this, since the software does not know which
frame was transmitted, due to four queues being used, and retries etc.

johannes

--=-lFn9Uqrf+H/g+03Kp4sD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/wqjAAoJEKVg1VMiehFYKz8P/0wPfnwGJEtHM/Cx6LVeqtFw
ReFkmrMiBX9RxWJh4LqleqzpQ/0Pi2xbnjvJsc53TBjpbMXeK2Qf+IAnPPbqshSD
XkTwIFap/UaSEZDVwHMfSz+P8YLJHhG2+sJajyQVyol6vUu+Y7MTaPW5mvVzlVUu
zIy2HOI54BA61hfCZ0mf/40vNTlWnueasQ9Nxaxwh96ksb6wcaEyrLFf8U7k9Kzu
bHnPSOpy9i8UkUAhgVooBv1gS+M9VjOHtrZ6W46l9LGyeSrIdHkuCDthEusSqdIM
f1lvLcICVBDIyMgCFeRszPJdKIDWezQb1FVL0J1/vOaSuvdRh2mVbBS4SJTtkX2y
lfoaBlVS1dPFtFbjf7KLYHeMvvxdy/kRUng//lztfEqiGb7JXj/CP0oFHGt3SqVm
zkfUV89T8ix5PFPIePMcOYKKwFV3p1EhmErkCSdyYxXhLoY7dtAmrIe3AkYlJIfr
4nEQeIjRKZi39v5YfycC9YKk+hdiqrLuC9cxRvEXiuCdOIjidvSYtZ1akzi5xILE
p2shWOaBtvww+l7qSiChEUZBd3X7XZ8sbkkNqpdL6Dey3FlKhbzPfs1LimDIoUUg
D4otTA32C/4JwzZCWhCg6VDOeahjpUKNdGEIaGw22Gm006b4LEb8rv0bJYAziZvZ
YSUrx/+RG2d4cU+7C8ys
=SzdX
-----END PGP SIGNATURE-----

--=-lFn9Uqrf+H/g+03Kp4sD--


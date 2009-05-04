Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52093 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbZEDQk1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 12:40:27 -0400
Subject: Re: IEEE80211 Acknowledgement
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Alexandre Becholey <alexandre@shockfish.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200905041835.35104.IvDoorn@gmail.com>
References: <49FF06BB.2090106@shockfish.com>
	 <200905041729.13805.IvDoorn@gmail.com>
	 <1241451174.8683.48.camel@johannes.local>
	 <200905041835.35104.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-s99QIhTuTZXljTuAZEyB"
Date: Mon, 04 May 2009 18:39:55 +0200
Message-Id: <1241455195.8683.61.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-s99QIhTuTZXljTuAZEyB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-04 at 18:35 +0200, Ivo van Doorn wrote:

> Well I believe the idea would be that (I'll see if I can dig up a referen=
ce
> to the initial discussion about this feature on this list) the driver set=
s a flag
> that mac80211 needs to keep a list of all frames send out to the driver a=
nd
> listens for ACK's.
>=20
> As soon as a ACK was passed from driver to mac80211 it could check if
> the corresponding frame=20
      ^^^^^^^^^^^^^^^^^^^

Here's the problem. What I'm saying is that there's no way to knowing
what the "corresponding frame" is.

johannes

--=-s99QIhTuTZXljTuAZEyB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/xpYAAoJEKVg1VMiehFYJuIP/RlkIyt33Vh+piNoKH8Bb+Ih
Poz7svxx7RjvTkEM/W9nOudDH4AfsvjC2Y1vktqXgDLDyhxAauLH3YdKcCyHnyGG
eh8Igij0g928O+jBXE8OsnY1svX3JZb3BJgPoQuxXEC/H69l6M3O/NdANwHJIIbv
JMu9ZMwaDV5z+Of7hrm9I+WL4rNN7N9asCdF9kHRMIB/4vgfSF41oAvLy7oWOpr2
n/EIY0fCtBrOoNMyl+vRjDiGllAxsKlJ6nszlIMFkjlS5eSSovMexoTV3JOy9kx0
YENbfRfqRJObUMrxq2W3wuQt+gnseJfMp9wVN7AsAJQdrXNre2Y0u+t2rXEUHcPX
RF074imJWP+/mZtDpqBqj/qMRySC0lJLuH8U95V0MLmJmsDQQdX5fJKZq+8fvrd/
jLAKMe5b4Nii6vPToWjMkbzhnopjIji/vpu6c4+vaiEM68nh606/5kb1E5CKPw4S
izFXiKF4S/CIz2MmW8ePfqU/zOouVQnYZIJoTjKu11gqPomJSoFOjMZMEfjnIhBW
NxIq/iC795Bn4F+ZD6DJuaxh3JBYsBPD+UiCjwjEego/5h+lsy/SIw2/thRGakqC
2LO7CSasRYUyDoI2rezcp/yGC1MaihOdw8S8W2dAoAFs4Q9GBJ7Dh6v52cEZnUKF
UNkNBWgi+mNcBsklXYDh
=otb7
-----END PGP SIGNATURE-----

--=-s99QIhTuTZXljTuAZEyB--


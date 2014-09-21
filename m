Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55122 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbaIUTVI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2014 15:21:08 -0400
Received: by mail-wi0-f170.google.com with SMTP id fb4so1789870wid.5
        for <linux-wireless@vger.kernel.org>; Sun, 21 Sep 2014 12:21:06 -0700 (PDT)
Message-ID: <541F251C.8080105@gmail.com> (sfid-20140921_212111_997517_1080B72B)
Date: Sun, 21 Sep 2014 22:21:00 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: pull request: iwlwifi-next 2014-09-21
References: <541F23D2.90600@gmail.com>
In-Reply-To: <541F23D2.90600@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="oN5gSo7TdqIbjSlucv4jsRbCG6MGQnjEW"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oN5gSo7TdqIbjSlucv4jsRbCG6MGQnjEW
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On 09/21/2014 10:15 PM, Emmanuel Grumbach wrote:
> Hi John,
>=20
> Here is another (last?) pull request for 3.18.
>=20
> I have here a few things that depend on the latest mac80211's changes: =
RRM, TPC, Quiet Period etc...
> Eyal keeps improving our rate control and we have a new device ID. This=
 last patch should probably
> have gone to wireless.git, but at that stage, I preferred to send it to=
 -next and CC stable.
>=20
> Let me know if you have issues!
>=20
> The following changes since commit 6bd2bd27baf12fa0f2e6d611509fc0e1bffb=
0f97:
>=20
>   Merge tag 'mac80211-next-for-john-2014-09-12' of git://git.kernel.org=
/pub/scm/linux/kernel/git/jberg/mac80211-next (2014-09-15 14:51:23 -0400)=

>=20
> are available in the git repository at:
>=20
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.gi=
t master
>=20
> for you to fetch changes up to 908f324b609320a8839211922f8c4946c891d56c=
:
>=20
I had to edit one commit message - new HEAD: 48849a4150e353656dc5d207f2a5=
6ebd00484ce6


--oN5gSo7TdqIbjSlucv4jsRbCG6MGQnjEW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUHyUgAAoJEC0Llv5uNjIBbOIQAKduhDPRAleklqFovhVqh+1a
+se9wpPzNs6vho1ByeSq+QnM4OEV7RVx739SVIQzq3XnHa9iaa7/RSnm5WSzFcnS
RUP3lFgHWgnyRyprahiRFaR4EjLbkSOVngULNnH8DkLS2zUwBmmhFeL4W9vghZgF
KP7u3sT7yAguDiEFAb/nMhfN3VbGflG5KkPHGv5ZfUOLCqPSgCbu6+6h4cCmL03O
K5C0gRA0T3Cgf59hfHcFH/dSoG45QEGSAB8AtK7JVCuWq8a/MGB7gjPzuDIeMFLr
mIHsQehZkyRQGyDwc87K8tbfScV4kGwM61J40nQJ496jKRIeW0dNg8TYTo7DXJ2f
Qg5zDq41RPKw3by8kq6wGrUFpgXbT+kYtAIsm6NbUXKO4pJASY98d3XRl8LMErzk
MNa7BWJBSGDQa94TZnwYFxHQCOhvQL+DiAjJnyFchLP7kfB9sEZIyYhPIfeqJQB2
JPGnmqbEa9PeaITb5/dEkffwl9rYK5GKPULFzhAkahlTgnyZrCdbHMadDwLJF0s7
WW+v5AzMUq/SMYnAStfO5iwC38bfC4/AmNYWS0at6hRLV8XnZ1ExWWOuCnBgowno
d+KbPail8gELu5uxvR5pI7DdUKGGrD2FXpaIwzwJ7brAUlpMLoN3umcVlR2MeMy1
Nhgrf5IYJJtpLycAfaVY
=xP6s
-----END PGP SIGNATURE-----

--oN5gSo7TdqIbjSlucv4jsRbCG6MGQnjEW--

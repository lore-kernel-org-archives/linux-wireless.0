Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:62855 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934069AbcIVRMQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 13:12:16 -0400
Subject: Re: ath9k_htc kernel driver regression affecting throughput
To: bruce m beach <brucembeach@gmail.com>
References: <CAArymCks5NN=09EdJ4uaoRrHZciYAkYTES+i62BkfZ4R-W30HQ@mail.gmail.com>
 <96b0636d-1171-5830-6481-edb991ca8e1a@rempel-privat.de>
 <CAArymCnJZgUbgCiLqA6-94RAtXYkYeeS9uF71MX9+ou-AbYszg@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <82f2de29-e021-f7de-d5fa-a4063a5c92d6@rempel-privat.de> (sfid-20160922_191219_846447_4954B3FA)
Date: Thu, 22 Sep 2016 19:11:47 +0200
MIME-Version: 1.0
In-Reply-To: <CAArymCnJZgUbgCiLqA6-94RAtXYkYeeS9uF71MX9+ou-AbYszg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qstdR4LhJkjtSMm9LT61gKgUgUfVVcIkc"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qstdR4LhJkjtSMm9LT61gKgUgUfVVcIkc
Content-Type: multipart/mixed; boundary="uKeBVmKNdjmXqjE9iVBXJwALJ9sgpWPN1";
 protected-headers="v1"
From: Oleksij Rempel <linux@rempel-privat.de>
To: bruce m beach <brucembeach@gmail.com>
Cc: linux-wireless@vger.kernel.org
Message-ID: <82f2de29-e021-f7de-d5fa-a4063a5c92d6@rempel-privat.de>
Subject: Re: ath9k_htc kernel driver regression affecting throughput
References: <CAArymCks5NN=09EdJ4uaoRrHZciYAkYTES+i62BkfZ4R-W30HQ@mail.gmail.com>
 <96b0636d-1171-5830-6481-edb991ca8e1a@rempel-privat.de>
 <CAArymCnJZgUbgCiLqA6-94RAtXYkYeeS9uF71MX9+ou-AbYszg@mail.gmail.com>
In-Reply-To: <CAArymCnJZgUbgCiLqA6-94RAtXYkYeeS9uF71MX9+ou-AbYszg@mail.gmail.com>

--uKeBVmKNdjmXqjE9iVBXJwALJ9sgpWPN1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 22.09.2016 um 05:34 schrieb bruce m beach:
>> We recently updated FW to GCC 6.2 which can detect more problems. So i=
t
>> will be probably interesting for you to pick this patch out.
>=20
> Yes I saw the message by Adrian Chadd and tried tried to git clone the =
link
> he gave but that clearly wasn't what was to be done. Is there a patch t=
hat I
> need to apply to the firmware? I do have a local copy.
>=20

this patches are now in main repository.

--=20
Regards,
Oleksij


--uKeBVmKNdjmXqjE9iVBXJwALJ9sgpWPN1--

--qstdR4LhJkjtSMm9LT61gKgUgUfVVcIkc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlfkEOAACgkQHwImuRkmbWn0AgEAkq+ycRVrUNw+eC+fT0TohfVu
eIEsgVQDCwhj83HPJEAA/3/9FkISZtIbFZTdGlHstWxBMDJP2y1cNJ1WoSYUs3pg
=GoJ1
-----END PGP SIGNATURE-----

--qstdR4LhJkjtSMm9LT61gKgUgUfVVcIkc--

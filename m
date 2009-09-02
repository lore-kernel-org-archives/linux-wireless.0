Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39713 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbZIBRE0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 13:04:26 -0400
Subject: Re: [PATCH 2.6.31] iwlwifi: Reenable power_level
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Andrew Lutomirski <luto@mit.edu>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <1251910457.13180.160.camel@rc-desk>
References: <cb0375e10909020753o4d314f61k74dd35025f61666a@mail.gmail.com>
	 <1251906970.13180.137.camel@rc-desk>
	 <cb0375e10909020941qa54215cqb6af7ac01e87ccb3@mail.gmail.com>
	 <1251910457.13180.160.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3qSARCWQ7Bln3fiQqNiY"
Date: Wed, 02 Sep 2009 19:03:49 +0200
Message-Id: <1251911029.2999.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3qSARCWQ7Bln3fiQqNiY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-09-02 at 09:54 -0700, reinette chatre wrote:
> Hi Andrew,
>=20
> On Wed, 2009-09-02 at 09:41 -0700, Andrew Lutomirski wrote:
>=20
> > Fair enough.  Would you accept a patch to remove power_level from sysfs=
 instead?
>=20
> No. This file is used when users want to manually reduce the power used
> by device. This is the file you want to change if you want to extend
> your battery life.

Actually, we have already removed that file for 2.6.32 I think? So it
may be fair to remove it for .31 since there you can't use it anyway.

johannes

--=-3qSARCWQ7Bln3fiQqNiY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKnqVxAAoJEODzc/N7+QmakWMQAIS9arc14lSrJCP7KyG2D1UU
ShqT5FyvDhPJZ7MAJ8hGL4nCDMy4aAfOfm4koE0rC8Eq7nbeEZ2hRjz+565XL1TE
ThrbYB+NH34E5Ewm8Bdxrw3WqVxiFpcvYDE9yVRpEpavH+YtLc+g2hwYoz7M3RAx
nmtQsFdjGHDvazk1IGHxpFW96XHeRdVJPqgddwnfZIi2dLP0vnb/h9dvmO1icVLM
Ytxn1Pp8tjp4XCJsqkFw4+oSC819/t39Ci/NPO0QtzgSSnM1XdHgVBDgVoe08mnM
iQFnsN7SIfiNBofFQTNpi/AkK30I9oBRq9je9+OeJB//Bw3DMwVZrwvi4Ef4YtVg
CaJQgJ1Xx3k8RRAMvcFwoTKNZhm02GL2IKTnUYXtgyxfSEbB6iiWTTK2FTHnnRS+
YV2GIm6xZMxdSLK0cIUGD6MtLnBPrIRoml/mcpepOZPp3ZFrjHa0cnn6+Zvm/ZHV
cANlnwGjsPbJpoaVwA26EOwvMl2MDpt3AQwk86a49JykfL1xK2MxGC1t6biVebg9
ixQHFQC66kZhket2z/F01/rt/g6LlgM4w/xZSxC5Ev6kVikJGJGoECr2fmyshLnw
eUhW6kjL4/kojWrXjINFmSMqhDLZv//Y6utkXsmCOBkhSoaROUR3lKxB0ewSfmLI
Rrc56yPjV2PiS6wrFaH/
=9I4T
-----END PGP SIGNATURE-----

--=-3qSARCWQ7Bln3fiQqNiY--


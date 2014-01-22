Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev-nolb.cloudtrax.com ([54.203.245.161]:43954 "EHLO
	dev-nolb.cloudtrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaAVSpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 13:45:19 -0500
Message-ID: <52E01172.2080907@open-mesh.com> (sfid-20140122_194530_880330_A3CB37B5)
Date: Wed, 22 Jan 2014 19:44:02 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Thomas_H=FChn?= <thomas@net.t-labs.tu-berlin.de>,
	Johannes Berg <johannes@sipsolutions.net>
CC: Antonio Quartulli <antonio@meshcoding.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 1/5] cfg80211: export minstrel best rate information through
 get_station()
References: <1390302591-3352-1-git-send-email-antonio@meshcoding.com> <1390302591-3352-2-git-send-email-antonio@meshcoding.com> <1390320014.6199.61.camel@jlt4.sipsolutions.net> <52DE9BAA.6020205@open-mesh.com> <1390321084.6199.65.camel@jlt4.sipsolutions.net> <52DEA10F.6090700@meshcoding.com> <52DFD8A5.5090800@meshcoding.com> <1390401820.4334.32.camel@jlt4.sipsolutions.net> <7C173B24-D062-49BE-836E-E0889633E955@net.t-labs.tu-berlin.de>
In-Reply-To: <7C173B24-D062-49BE-836E-E0889633E955@net.t-labs.tu-berlin.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pRxx1fQO3vl4aB84EbPRfxJljxcQX9ETN"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pRxx1fQO3vl4aB84EbPRfxJljxcQX9ETN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 22/01/14 19:32, Thomas H=FChn wrote:
> Hi all,
>=20
> I do also agree that the expected throughput [=3Dmax_throughput(mac_thr=
oughput_rate) * success_probability(max_throughput_rate)] is the value of=
 interest.
> For my current power control development I just use those minstrel stat=
istics per client, that are provided via debugfs and parse those values t=
hat I am interested.
> Maybe it is an alternative option for your development of batman is suc=
h a way to use those debugfs statistics, where you have all information, =
expected throughput included. And once your experimentation shows which s=
ubset of those stats is sufficient for a better routing performance, you =
go for a proper api. Or are you already confident about the expected thro=
ughput value is the one and only ?
>=20

The only stable point is that the our metric will be "throughput
based"...the way how this "throughput" is computed could also change in
the future..


Actually for experiment purposes I have already implemented my hacky
cfg80211 API and I am using it (therefore I have no real need to use
these debugfs stats).

Now I would like to bring this API to the next level and merge it.

The experiments performed shown that bitrate*probability is a reasonable
value to use. But even if in the future we may decide to change how this
"expected throughput" is computed I think there is no problem as soon as
the semantic of the API is remains consistent (=3Dreturn expected through=
put).


Cheers,


> Greetings Thomas
>=20
> On 22.01.2014, at 15:43, Johannes Berg <johannes@sipsolutions.net> wrot=
e:
>=20
>> On Wed, 2014-01-22 at 15:41 +0100, Antonio Quartulli wrote:
>>
>>> do you think that an API exporting the "expected throughput" would be=
 a
>>> acceptable? At that point any RC algorithm can implement it the way i=
t
>>> prefers.
>>
>> I think that's a better choice, yes.
>>
>> johannes
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wirele=
ss" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Antonio Quartulli


--pRxx1fQO3vl4aB84EbPRfxJljxcQX9ETN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS4BF3AAoJEEKTMo6mOh1VvB4P/i3phzAQZDZXCWM/VoU0xFm8
CMiTvzeBdXyZ+LL1TCkdorokqT+d7StAd/k5JKL2YeW4qlo2pUchbCb2QFpYKkgn
DsHT5LcCdfrO4hMiukYjFmY7B3o+eKSzP1L6uvH3Y9Izh7UNJO7OaUFwhEOmfOSd
zkN6LCdHXoXuvEFYwfuEC6+o9rNjDuV4EZ/0lxmhGMQTXM3UCoZong/b35L4TGPd
Q+uVfwE470KjC8uJ0zO+0u+Vo96/CoSMWh9JdFU4x8m8oOBSiuOSGduawKauDUN/
gy7IkspEVSVySEOwGc9OrAWtyFLwsR30qKWyhB4B5MhbES4fl2lfeiULtkQ3iJkQ
7GYC3UOHaUofqup1fPCnK0/8vJoVbNM4Fbz1UvSW363uyTZAjJdCtCwqXIdI+/Bz
1F/RU0HAo1f1oPqFUvAwnegQ59zEesJwC0hbR6o9gjS5dq0lqRoVUGRWD4nBG+kN
sO7oajgjuDU2M66V8RnYYb8tL+aJQ9p3sr/DxO22cqx5dZKNbs4ZYg88Aidipk0T
Ke8ZeIF/VmOeie3WAnAqyHtY7PQoQSu9l7bNuF86BUYFmvxgAr4LzgEXQlJUC9bW
zY6FamRXDKeNIyhbp8rMmeIt4V/u72qWGjA6GENfsEV/p4zniFhfoCNpnS2fIPLJ
VsFUVZPkf2HmpiESNsCr
=CDIN
-----END PGP SIGNATURE-----

--pRxx1fQO3vl4aB84EbPRfxJljxcQX9ETN--

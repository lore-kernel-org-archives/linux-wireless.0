Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:38973 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbaAVOmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 09:42:54 -0500
Message-ID: <52DFD8A5.5090800@meshcoding.com> (sfid-20140122_154312_222402_84FA8618)
Date: Wed, 22 Jan 2014 15:41:41 +0100
From: Antonio Quartulli <antonio@meshcoding.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Antonio Quartulli <antonio@open-mesh.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 1/5] cfg80211: export minstrel best rate information through
 get_station()
References: <1390302591-3352-1-git-send-email-antonio@meshcoding.com>		 <1390302591-3352-2-git-send-email-antonio@meshcoding.com>	 <1390320014.6199.61.camel@jlt4.sipsolutions.net>	 <52DE9BAA.6020205@open-mesh.com> <1390321084.6199.65.camel@jlt4.sipsolutions.net> <52DEA10F.6090700@meshcoding.com>
In-Reply-To: <52DEA10F.6090700@meshcoding.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iDI5KvlRAfpM23pMCPkLNmd9gebKNj1CK"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iDI5KvlRAfpM23pMCPkLNmd9gebKNj1CK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 21/01/14 17:32, Antonio Quartulli wrote:
> On 21/01/14 17:18, Johannes Berg wrote:
>> On Tue, 2014-01-21 at 17:09 +0100, Antonio Quartulli wrote:
>>
>>>> Actually this isn't expected throughput, but
>>>> wouldn't something like expected throughput make even more sense?
>>>
>>> How should I obtain that if not with the previous operation (bitrate*=
prob)?
>>
>> Minstrel actually has some tables for that, no? This would still just
>> only be the raw bitrate, not the actual throughput.
>=20
> I will check within Minstrel, but in this way we are limiting batman-ad=
v
> to use only what Minstrel thinks to be the "expected throughput"....And=

> if this turns to be something not adequate we will have to change
> API.
>=20
>=20

Johannes,

do you think that an API exporting the "expected throughput" would be a
acceptable? At that point any RC algorithm can implement it the way it
prefers.

Moreover, if users realise that the API is not returning a proper value
we can still fix the implementation in the future (as soon as it still
returns something called "expected throughput").

Can this be the way to go? At this point we forget about the concept of
rate and we move to throughput, which is what we are really interested in=
=2E


Cheers,

--=20
Antonio Quartulli


--iDI5KvlRAfpM23pMCPkLNmd9gebKNj1CK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS39ioAAoJEEKTMo6mOh1V4fcP/AgnkfA2qc3fZf9VkAAyyVJw
cKaTfgesw+efhzCAQMEnidOicjz9TkGhu5zMABk2OM2AJTcDX/zpoBFVnOEtsJMR
xG8QVPXScxzIBXqJQ52dGz09mjvxf2m9M73Lxtro5SmftiHOiIpSfv7XSeZMdvMU
fUpybjzdhvHEc8xFpSYoIbgOsGA6cpcKgi6uu6jyYKSypOXvJWDiTItucVmv8xe4
2ah6/mQCkl8R0v3KkRo93as+1tzAuDPdRJDDVXWCWgGV8a9vwrjEtAt4wXtu/3aQ
30qvQBDEuFBH4v2W3nZvMK+/pmq3JmXGDqKqkhj4ZEyAdITFU/IqChIBuO6bDh2m
h4wNLF7oNak/H+Yt5y1ice7WrsdXCe38vYwEh5P0LhopCXmNQXK4zMxNB1VB1Jb1
DtwvnlnNx1EfC7FF1vSHMKs3YQpIv9oiUqvxNheouRpJwt/B8Lrswl+vwx6KsgIt
VjWqinQdFzBoDjjQnktb1OHd3fWZgc2aO3+tWKgTlqlCLrVDEFi6JLE3ttuxe6bt
00TZvCnpP/xWSTv/5ef0hoQW+KqxgEjN2oa4tQ8DtSgk9edPOyRnf7tE9NPphUjI
0uFL78kQoyb/OExrleSUzl/wAcwdYbbc3QO7GEdSipK6aHycQ8ZJzp1IbOYWn9xo
Tn/UH/Xv7AdiGKAkkouN
=FWPJ
-----END PGP SIGNATURE-----

--iDI5KvlRAfpM23pMCPkLNmd9gebKNj1CK--

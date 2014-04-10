Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev-nolb.cloudtrax.com ([54.203.245.161]:52885 "EHLO
	dev-nolb.cloudtrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbaDJQXA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 12:23:00 -0400
Message-ID: <5346C540.9020703@open-mesh.com> (sfid-20140410_182304_978832_8A7FD0AA)
Date: Thu, 10 Apr 2014 18:22:24 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Antonio Quartulli <antonio@meshcoding.com>
CC: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org
Subject: Re: [RFCv2 1/6] cfg80211: export expected throughput through get_station()
References: <1396211704-4677-1-git-send-email-antonio@meshcoding.com>	 <1396211704-4677-2-git-send-email-antonio@meshcoding.com> <1396951400.5936.15.camel@jlt4.sipsolutions.net>
In-Reply-To: <1396951400.5936.15.camel@jlt4.sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xauqixIdKw9XLveqMCuU5gBEC5LVN9UTv"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xauqixIdKw9XLveqMCuU5gBEC5LVN9UTv
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 08/04/14 12:03, Johannes Berg wrote:
> On Sun, 2014-03-30 at 22:34 +0200, Antonio Quartulli wrote:
>=20
>> -	STATION_INFO_INACTIVE_TIME	=3D 1<<0,
>=20
> Since you're touching these all anyway, maybe convert to use BIT().

Will do!

>=20
>=20
>> @@ -1013,6 +1015,9 @@ struct sta_bss_parameters {
>>   * @local_pm: local mesh STA power save mode
>>   * @peer_pm: peer mesh STA power save mode
>>   * @nonpeer_pm: non-peer mesh STA power save mode
>> + * @expected_throughput: expected throughput as reported by the RC al=
gorithm
>> + *  about the bitrate having the maximum throughput. This field can b=
e filled
>> + *  only by drivers using Minstrel
>=20
> This value needs a documented unit ... :)

Yep. As suggested by Andrew, I will try to be clear about what unit is
returned.

Thanks a lot for your review!!!!

Cheers,

--=20
Antonio Quartulli


--xauqixIdKw9XLveqMCuU5gBEC5LVN9UTv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTRsVFAAoJEEKTMo6mOh1V9uoP/1a/1RDjvFcU1lxDd0L2V9yQ
sB9gFiWZA0HZ/T2U4tnrn1saIRWg5Lp2hPiv/ZrDfkK0DMA+45cguG0nKAzKu5jD
n56Efcqchpht7q0gI2rpSLYh5GFo6v4c5rP7bm/q0eMbXQc/FwAxWVBXXkzqbZOl
4bnAcF3nJG6VwZVjALTKIqkF2+aZDWf3sUQn2wK+E+LrD5rZd7KNhv6dWWA4nkx2
wT2fKMeSLVqoC/oNQK20T2MEP7R28tOO/rl3gEbISJNPIZWOedo6siJR+LpFO9la
Bf+Qu4xy3KJ1HSIDUUUafZrkxJByJL+/hqu7hlbLzdj060VLdJPScp6NQ4LRLqfK
+GtqkyXx5nX4II6mNf711qx09kzxBhXbUHmkUYsotIRjlJmtlyNEs5pawNZzzvhL
eqbC8NRmzWQA+K3M8/GJ0WRJMrwfRGmTEqyab9I+fuybetbrBd4Lr2gae/KuMecn
8hhe19JTiO2PuLpy4DvgZoFPTRtXEFok6hxI5C52pklDt3fmfmsOyeljNPgjv02w
3hHCqjrn+BwrUGHKUDRGpDk8VMIKOK+uPQtjlJdbce0XLlDK0CAD8n5SwwqFDp7E
G9xQwj6hoeei4P7t5O4uKnOoDXNSeDWzJaQXv4ZqQcFF4RvXWr0KlWUoqxxXo0NR
fnDfz4ZKX9+LkiZt/3Az
=MXIZ
-----END PGP SIGNATURE-----

--xauqixIdKw9XLveqMCuU5gBEC5LVN9UTv--

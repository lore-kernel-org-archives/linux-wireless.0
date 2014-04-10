Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev-nolb.cloudtrax.com ([54.203.245.161]:52871 "EHLO
	dev-nolb.cloudtrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934836AbaDJP50 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 11:57:26 -0400
Message-ID: <5346BCEB.1010700@open-mesh.com> (sfid-20140410_175741_236004_76B2A95A)
Date: Thu, 10 Apr 2014 17:46:51 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org
Subject: Re: [RFCv2 2/6] mac80211: add new RC API to retrieve expected throughput
References: <1396211704-4677-1-git-send-email-antonio@meshcoding.com>	 <1396211704-4677-3-git-send-email-antonio@meshcoding.com> <1396951430.5936.16.camel@jlt4.sipsolutions.net>
In-Reply-To: <1396951430.5936.16.camel@jlt4.sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Pbx75SHwfRNxpuLFsrelQIUVUw9BrPG4v"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Pbx75SHwfRNxpuLFsrelQIUVUw9BrPG4v
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 08/04/14 12:03, Johannes Berg wrote:
> On Sun, 2014-03-30 at 22:35 +0200, Antonio Quartulli wrote:
>> From: Antonio Quartulli <antonio@open-mesh.com>
>>
>> In order to make get_station() export the expected
>> throughput, we need a new API which extracts such
>> information from the Rate Control algorithm.
>> Therefore add the get_expected_throughput() member
>> to the rate_control_ops structure.
>=20
> What about drivers with HW rate control?
>=20

True, they do not implement the rate_control_ops API.

Therefore, as discussed on IRC, I need to move this new API at the
mac80211 level, so that each driver can implement it the way it prefer.

Cheers,

--=20
Antonio Quartulli


--Pbx75SHwfRNxpuLFsrelQIUVUw9BrPG4v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTRrzvAAoJEEKTMo6mOh1VxU8P/3ts4WAVnEJWSsWTnUzrdkwX
7AAa+Q8UrA9i4497c7zakCSXg4KAdXDglGFanjOn4Av7UEUIUNUDaT+axvzKDSlq
vsKA4qcf4WPNRyVFxZd6FZCNuVNWT7qh01i1g2BTZFuI1oHzYBk77JsLh7Ndf5U/
oFKD9CWilfo96g+ThbuB0ob/TA5x+yFtoYmIZ/HrV9e71jSEv0Zwks/wXcTfiwdZ
I38kHw1acu3oCPs3t+52Z6G5XIM0uq5m0Y7gH5hYd2DQYID/O/s3rfm8n6mjvjrQ
s/c+fe2dZnX9oVAfEeQ6IqMdchOYXzVKfpafb0zeYPH+1fP5jZkg8cA8q2I5pjVL
919tnPYeMx59tN1L4RkRxsGk1O1BYuMn6Yi7eXHBQBxqX9Vn1JwPcmiHTmsS6iyx
pZm6Y92SjgMklpt4kDQHKr5mqwH/TxgdZ6Md0laSS6k+SF+0ONvfDroCw+VgECaZ
zr4WGBCwrgDbgPCFihpbxeYab6P56XHGOYVvrnRVOqol67g9z1TIj52+JhakwYEX
2pkCZ9uFHVbmTxgkYNziL2n6eEqcztZRIb9hzpEQPRYSyOWs/qZx1/nr1n+/T4FT
Pz3A5jirNe4U8p6N/4xeydIDnlBL7JAZcpRR0NXZHXtAuHBua6GPhacKbf57TQj9
c73te3oACnO8XprZSPuJ
=KTfn
-----END PGP SIGNATURE-----

--Pbx75SHwfRNxpuLFsrelQIUVUw9BrPG4v--

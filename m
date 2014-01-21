Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:13085 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbaAUQdb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 11:33:31 -0500
Message-ID: <52DEA10F.6090700@meshcoding.com> (sfid-20140121_173335_076693_C9D90294)
Date: Tue, 21 Jan 2014 17:32:15 +0100
From: Antonio Quartulli <antonio@meshcoding.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Antonio Quartulli <antonio@open-mesh.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 1/5] cfg80211: export minstrel best rate information through
 get_station()
References: <1390302591-3352-1-git-send-email-antonio@meshcoding.com>		 <1390302591-3352-2-git-send-email-antonio@meshcoding.com>	 <1390320014.6199.61.camel@jlt4.sipsolutions.net>	 <52DE9BAA.6020205@open-mesh.com> <1390321084.6199.65.camel@jlt4.sipsolutions.net>
In-Reply-To: <1390321084.6199.65.camel@jlt4.sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mLo12wNqLNdMoLQAl8GTllWvCI0Wr3L7V"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mLo12wNqLNdMoLQAl8GTllWvCI0Wr3L7V
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 21/01/14 17:18, Johannes Berg wrote:
> On Tue, 2014-01-21 at 17:09 +0100, Antonio Quartulli wrote:
>=20
>>> Actually this isn't expected throughput, but
>>> wouldn't something like expected throughput make even more sense?
>>
>> How should I obtain that if not with the previous operation (bitrate*p=
rob)?
>=20
> Minstrel actually has some tables for that, no? This would still just
> only be the raw bitrate, not the actual throughput.

I will check within Minstrel, but in this way we are limiting batman-adv
to use only what Minstrel thinks to be the "expected throughput"....And
if this turns to be something not adequate we will have to change
API.


--=20
Antonio Quartulli


--mLo12wNqLNdMoLQAl8GTllWvCI0Wr3L7V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS3qETAAoJEEKTMo6mOh1V2bMP/2MzZmeCA/wFe0NNDHGmUsWG
5xNnd/IJBzSdXAA4zJm0HyA90WXpiv1txNa9SYSFVB12SaqXCb5mblBqqd6IL6qD
+8MUHcgMD7gRT4ya2UZby7pdFmzPhgCVtPhz3nkMLB/LDiDs1CpOp1sQyL3fJfe3
gXpwxv3xkPhvM6sb+/d4Dpzo7+NtxEiu/Z0OHk0hzkmnCwDARlIqFBRFPwwy/JNQ
FWTHrmjMCARle/ES4kK5RVLeaYTYZRixp2P6GFiuCTQdCxbyz4OiM4qKsKxunGlM
8zldJL94z1/SweRjJYfsmm2nVL+kYQrC34L+7W3Bhci6iACBO2BJjMH7h17qDM+a
AaWyTMvuz8K6+Cs//T5hmgxMQi7DYVMIQ0voijY8yDF4jJaTxi3DfBRvDxu+PsYJ
jsZsTXHHNaaQF47yY32orpMrk4RGT8GnIA7lj+glgM75SCSPsUEMqkXxsaLbNd3t
1j8YjmBmgBPDgO2fQ/EtGz4Z5yrPhsyIx+8V0ORR6qw/5gUdptchSRAcrRSobn1B
Z/+sjd/1hxgGEp+1eLANIySb4KVeNxHBzMiZlVRyJ4hd/yn9F46Pq6vIUn4DgC7q
mOuw2JG7iYdEWDEIhAfM04J1Hm7babtZMk70/WJP9GQg2UobiHGg1N++ldeH8+Y/
+UACLzJnm8qUIlHXrr51
=RpKA
-----END PGP SIGNATURE-----

--mLo12wNqLNdMoLQAl8GTllWvCI0Wr3L7V--

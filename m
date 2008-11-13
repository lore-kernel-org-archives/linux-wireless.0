Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39306 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbYKMApn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 19:45:43 -0500
Subject: Re: [FYI] ar9170 driver
From: Johannes Berg <johannes@sipsolutions.net>
To: "otus-devel@lists.madwifi-project.org"
	<otus-devel@lists.madwifi-project.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1226531788.14186.41.camel@johannes.berg> (sfid-20081113_001659_069366_BA2AA5E2)
References: <1226531034.14186.39.camel@johannes.berg>
	 (sfid-20081113_000444_962024_07ACD3CC)  <1226531788.14186.41.camel@johannes.berg>
	 (sfid-20081113_001659_069366_BA2AA5E2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cm8w5tou8ru8ycRjtWwi"
Date: Thu, 13 Nov 2008 01:45:16 +0100
Message-Id: <1226537117.14186.44.camel@johannes.berg> (sfid-20081113_014611_302976_93001DBF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cm8w5tou8ru8ycRjtWwi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-13 at 00:16 +0100, Johannes Berg wrote:
> On Thu, 2008-11-13 at 00:03 +0100, Johannes Berg wrote:
>=20
> >  * use rate hw_value instead of huge switch statement
>=20
> done,
> http://johannes.sipsolutions.net/patches/kernel/all/LATEST/
> (look for *-ar9170.patch)

Better URL is
http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-ar9170.patch
because it automatically gives you the number.

Also, I just realised that you need two firmware files for that, I'm
working on getting those into the linux-firmware tree at
http://git.kernel.org/?p=3Dlinux/kernel/git/dwmw2/linux-firmware.git;a=3Dsh=
ortlog

johannes

--=-cm8w5tou8ru8ycRjtWwi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJG3iYAAoJEKVg1VMiehFYEegP/1TQRbaAkV5QZu5utIkcDdaN
0a6Y4IMbygtxnXTJVJCjbIhgELSKHfhgPjR1cMGb6amWl/KxA5/g0N06/PYuGAIm
igomuGndNfnrCiLHRuXsBLSoDNgv0aPRxF9QZeyYrzz1sGDScHHST+me2quSRqGt
92G/MnKcyEXjIDCbxMMQdVF/v07Let/ahbbxDqREovnT1pdp69zXWN27Nte5EMtk
bqkL+HJRZpwZDWY/vTKsFrFhht438tT9tj5CnPFbyNHIjrJ8TxLsAsl1GgqF4njR
e6h5xtREy2vq8BN+OQCK0R8Je6r0wtDZntVGJRoPdrPQO/6ihaFqquX9qMNMvkVf
urww7kgM6wMBiomJXrswyjfM0AiWf4TBuzYk79viafcDNkoVgZIVIKuPGRvamTs6
0rnGhNAjNASHqsPBRy4sWP3T4DchHAafzJxaKCGLTqUf1VlhucOiUj+edrzdjV4b
oK8LUmSV+hFhgBpG8jJ+n8p9MwNoaaf8d1jXBa9snUZYT02C3zN/RV4NsbbCvle0
hdP+TkCIVjJ5qwQTBp/Qjq0P1tYWt29wVBKucJUyS2QPhqsDYHBG1jC6w1YLMARu
25G+DDbT37usjrMTaj/6agzZ2toNp0zddbdWRI+fR7I54/6Mtrdc5jEFafybaFDs
nOJZuK4CWDy3nCOuFWUP
=REgL
-----END PGP SIGNATURE-----

--=-cm8w5tou8ru8ycRjtWwi--


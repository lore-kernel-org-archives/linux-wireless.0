Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60846 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbYCKQOo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 12:14:44 -0400
Subject: Re: [PATCH 3/5] mac80211: replace Mk16 helper with le16_to_cpup
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1204968187.23455.39.camel@brick> (sfid-20080308_092339_300656_E96B3B6F)
References: <1204968187.23455.39.camel@brick>
	 (sfid-20080308_092339_300656_E96B3B6F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bYcVv4EQR6QGcNfZeZD7"
Date: Tue, 11 Mar 2008 17:14:29 +0100
Message-Id: <1205252069.6387.52.camel@johannes.berg> (sfid-20080311_161446_830126_617FD3FD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bYcVv4EQR6QGcNfZeZD7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sat, 2008-03-08 at 01:23 -0800, Harvey Harrison wrote:
> Opencoded byte-swapping could just use the kernel helper.

> +	p1k[2] =3D le16_to_cpup(leptr++);

I'm ok with this if architectures guarantee that these operations work
on unaligned values, but I don't think that is the case.

johannes

--=-bYcVv4EQR6QGcNfZeZD7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9av5KVg1VMiehFYAQLJHw//VDlSDLBDgwwBQqecGxvBgB7ycJpgiKNj
AmX9cox+DXmVo75W+yEx3BZkypHTPtkuklhevPzCq1JFJiDw0c0iAd6fbxaEnxGW
nMo/269N2MzM2oeAjZrHJup7MhzdGe6ZYtxerQTKg2OQEVrGHitIj/Pte3RfqF5d
D5utlknfNR4A2TCRBvczxQth7vtgJ9Twrza8WRQLdTndcve7CVHEsIrkvqwcENTi
N6xBNjCfIre5q7CA+/Rrb3XcQwZpcfJODCzm+AjvTCR8+FZ0eYRIVbxhyss/GYvT
ims6dIi5oUqi6dmZwoLKaLzOIGdjOIC5M6XwJNv9wzeESw+HgB8bQbiAkyBpgVBo
pkT8Zq9xylKPBVUHKZL2aEprCYYONquwvTO7oRQlzJdnSrvMSz9c9JTbQC2fipF1
3r77CrakfBj1ooDE3HZecqFfTJigoR3puGu9Ozq4tHVEl2dT2ti4RKMlStsxpgWE
vMTO9RGVfgterEMHi3araNxr28lZ9WkDR0UNKHsZMmddtnC1zWv25lesMmc/dINw
BfoFll7fTFE+iF9aKemZL+rlo18rhacSpSyPKjYlQaSNKpw2o/+Z6egLw8TVq4VQ
7hpLDVqD43OtnurvF+Ic+MfQXg7cTyp/PsjECmbBm0VPG3a4lQQgaUhPweU7rHE6
UTXKqOIQMtg=
=Y/m6
-----END PGP SIGNATURE-----

--=-bYcVv4EQR6QGcNfZeZD7--


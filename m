Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44513 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693AbYBYTio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 14:38:44 -0500
Subject: Re: [PATCH 11/13 v2] o11s: support for on-demand Hybrid Wireless
	Mesh Protocol
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1203968210.6929.22.camel@localhost> (sfid-20080225_193515_727081_D7673A7D)
References: <47be77ee.02098c0a.5eba.ffff81ef@mx.google.com>
	 (sfid-20080222_072128_730595_F951750B)  <1203697819.7082.75.camel@johannes.berg>
	 <1203967829.6929.16.camel@localhost>
	 (sfid-20080225_192854_280269_CEC357A7)  <1203967819.13162.136.camel@johannes.berg>
	 <1203968210.6929.22.camel@localhost> (sfid-20080225_193515_727081_D7673A7D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ky+5/Utc9te0KRjgiygs"
Date: Mon, 25 Feb 2008 20:38:32 +0100
Message-Id: <1203968312.13162.142.camel@johannes.berg> (sfid-20080225_193926_096741_29DAECE0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ky+5/Utc9te0KRjgiygs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2008-02-25 at 11:36 -0800, Luis Carlos Cobo wrote:
> On Mon, 2008-02-25 at 20:30 +0100, Johannes Berg wrote:
> > What sort of value is this?
>=20
> Channel access overhead, in hundreths of TUs.=20

Huh. The draft says something like

"includes frame headers, training sequences, access protocol frames,
etc."

That doesn't seem to depend on the hardware but rather on the PHY type
used, i.e. whether you have short/long preamble or 5GHz etc. Am I
misunderstanding it?

johannes

--=-Ky+5/Utc9te0KRjgiygs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8MZNqVg1VMiehFYAQKVoRAAph+cGh1de6u2W2RaB4agy890L9Pq27Nd
/qwmri0lP79ATj/FceJj62rEHyucvSFNHgPwOH7v6nYj8ZnMUhEpZczwSCdUOiMe
9ZHhcUs2sifra336Cxj4Up6O0+2zaHmH1ep16Q9avx08qliZgxkbFuoBw483pxlG
DVM/qnHaghJtFbW5vBPJshoEL8erLV1AfH9MSeevMfijwOpe+j4xTRp7jDixtUa+
OeNY2U1Q6VsX31RSZA0YBl4m5oSFOZgOYOEXydMVlI38ETInFi3HoG6fMvBkCSYn
On8icRAaVM72RXmZtGEJkVcx9nTmr6+oYylLYb9FJZgOn23pQOLVnruxXv8oaEWl
n1ccZPocC5f3mq4IALiW4a5gy797JypNi8smuf2IpAUitYCnWaWr+ctThMn5fVCz
BuwT1vDD1Pfp3nSYigc3TugK+SoWUeTkhuZDfqJT36nVqcy3tnWB1JX69Ow41vh8
zVDsmndVXBf3TfqNqb6HHATKl0g1S9gndnMhDQ+Hzq642VPa4Tbo1OrWZWs1xmoZ
UknXkWT1xSNW4ulZqYl6tS8LAP3oabJfTVgVU3vcS0dxJ/y7Wyyhwlhhb19BcnTq
rAnLBnUy95PYH8yiLnOBQ8wY8SiC+wQspQM7pr5RtUBDrn4esPYy0k5Qp/APtWpQ
nW/XZe7FDYE=
=3JJD
-----END PGP SIGNATURE-----

--=-Ky+5/Utc9te0KRjgiygs--


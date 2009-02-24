Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49543 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbZBXFSN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 00:18:13 -0500
Subject: Re: [RFC PATCH v1 3/3] mac80211: add beacon filtering support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890902232046v3c785a01s42e411e47a22288f@mail.gmail.com> (sfid-20090224_054702_450298_51E73780)
References: <20090223163626.20939.4879.stgit@tikku>
	 <20090223163738.20939.25890.stgit@tikku>
	 <43e72e890902230947x6e55bf36ve715295f43f74fbb@mail.gmail.com>
	 <87prh9ht22.fsf@litku.valot.fi>
	 <43e72e890902231111g3705c5bh445e3317de5967f3@mail.gmail.com>
	 <87bpst7xxd.fsf@litku.valot.fi>
	 <43e72e890902232046v3c785a01s42e411e47a22288f@mail.gmail.com>
	 (sfid-20090224_054702_450298_51E73780)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-92yaU+zKDGhfX0pjQrd9"
Date: Mon, 23 Feb 2009 21:17:17 -0800
Message-Id: <1235452637.4455.83.camel@johannes.local> (sfid-20090224_061817_362792_04BCE75E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-92yaU+zKDGhfX0pjQrd9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-23 at 20:46 -0800, Luis R. Rodriguez wrote:

> How does the hardware deal with IEs that may change order? I am not
> sure how common this is but I do wonder.

Uh, it would be extraordinarily stupid to change IE order in every
beacon! I guess it won't deal and we lose the benefits...

johannes

--=-92yaU+zKDGhfX0pjQrd9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo4LaAAoJEKVg1VMiehFY27cP/3TdMoSxn6EpOX6ZOgkHoU1G
CWq24K3EYnBrm43/3PlwDuKStSsqp55UK4Tx7sZeplw9uNOiidb6u2eFtKYrgB/8
aDL26u+p672pzk0L8KKsmRz+qnjFnXSKYC8du814EzcRsHC/zGVRRXOc3v+0Wb0A
fTms0FD7rgHWAsa4GWAp0TnGCt1LPErVADibq2Gwyi2DFDVpRwdMkhgd+fHS2hXd
KheRuxVCio2pvs1qtdKyQmkcUC4ZCRRD1Nc7wedVF2xW0gPQHg2XCEvIa5fCsO4A
TEzUHfhrZNpAVsIS8WOlLy/etR8iwzowl/NHu8D4XRZinyLKaxXxo/HHUHvTAQM4
BqEeEN5zmlchZwTJWmvQOQ/6YtbDTO0/qfpYqN1AkMiWc6RqrmNvWXwtgjN7ejWs
T4QIQe6bDxYNa6I5RDT4D+PVu5rfhhc6o4udlwfKz2ww8Nfqg5dFFhSgbELoRqlF
6QgNvX2wsVOBcjpv1yYGMO41mwKXlxVos+JJdGfSzB7PC6T+u3n1GseCLGOTj/r0
YTC+W1j3U1FIkkcw2ku7E3Xi6PQRlF8SzUJNZ3c82Qx0J81GSmiBcKLvfxEvHoue
yXQWfiPwyTSI1g8YQ+tOdfxUMOoD/0UhklGTJOZTlMKt/1PClW1uJCo8R14rYLIJ
Jbtb2sCRJrGquE5yaioG
=PqB2
-----END PGP SIGNATURE-----

--=-92yaU+zKDGhfX0pjQrd9--


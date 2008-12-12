Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46269 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbYLLWwX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 17:52:23 -0500
Subject: Re: [RFC 2/3] mac80211: Make use of the new F_TX_NOACK and
	F_TX_NOSEQ Radiotap TX flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <69e28c910812121451u25713c82o229a56006089edd6@mail.gmail.com> (sfid-20081212_235104_744345_FF8EB7B3)
References: <69e28c910812121432n6e84de41s94a887110051a1dd@mail.gmail.com>
	 <1229121558.3565.6.camel@johannes.berg>
	 <69e28c910812121443h1fae52e6uc88749d7e9baf529@mail.gmail.com>
	 <1229121947.3565.13.camel@johannes.berg>
	 <69e28c910812121451u25713c82o229a56006089edd6@mail.gmail.com>
	 (sfid-20081212_235104_744345_FF8EB7B3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CUmURFnExU3JTiDQXprR"
Date: Fri, 12 Dec 2008 23:52:19 +0100
Message-Id: <1229122339.3565.18.camel@johannes.berg> (sfid-20081212_235227_178091_6D88C305)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CUmURFnExU3JTiDQXprR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-12 at 23:51 +0100, Stefanik G=C3=A1bor wrote:

> But if we redefine !ASSIGN_SEQ to mean "use the sequence number
> supplied by userspace", we will need a new flag to distinguish between
> driver-level vs. stack-level sequence number assignments, which is
> essentially the same as this patch. There is no way to switch between
> 3 states (control in driver, stack or userspace) using only one bit.

Good point, I forgot about that. But that isn't true for no-ack :)

johannes

--=-CUmURFnExU3JTiDQXprR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQusdAAoJEKVg1VMiehFYBJsP/RVCg00jSZEAtZmet6kENOau
L6jnzRAJ7wotVAUabu2FX61cZzxcHok1KAwQrjisTPkypVSMlWFwsGfKJBGb1ou+
pWI5PCeouirfk09bYOTk0s3NoFwDwiI3l/AEep2nKAG8bTaitReWVdQEBvYVDZbI
HBhRHCBiP7997kQIc3KG88emPcft//6D8V3bcxYabrscryIJ2s198gqnhqWQhoiu
5FnPTqLTOoWZ/nSZqsJTaA4zV4Y33iCJlwWepbQkZCpvtpBAiKtSboA6O4oNfFTs
DksUqSNAqqnWVyKsmuc91li/hdrJZWEIMkdU7wTafjgi4oHKiuptEtTX+U+w3r6a
ffqKZJ+RICaaRmxPUdyJCr5aT+Q9bvSAvbQJhvkT4FyuUKD+AAU4KTayswYFUM/h
Z0Q2VKluvX0TzdoAkmamuTStSjJb5xH8f9Rf4DSrBm6L8522CJ4D7cwG4LawK4oU
apqBW4OZwOHyrrKj1eUNcG3Tboj8m2fNJv0OoIqrwoxWkvQMP8otZg7YXgwCMGwF
n44cBIz7dzs4yi5BFYXMlbncubwTl8Gi9Yl7Q7fMTheIKtfPGsK7rIWk+1fPQiqS
91Z0cf2XbJ/MZE/d+TF1K2pQwCRi6y3YKmj5UUbZD/M0KtIGCDH6OdPCkcF8W+Cj
xmX/LxPBRWExKaTLFnYe
=y7XB
-----END PGP SIGNATURE-----

--=-CUmURFnExU3JTiDQXprR--


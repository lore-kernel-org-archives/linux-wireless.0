Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43282 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbXHCKbX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 06:31:23 -0400
Subject: Re: mac80211 driver interface semantics
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: Ulrich Kunitz <kune@deine-taler.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>
In-Reply-To: <46B3032C.5040306@warmcat.com>
References: <46B27729.5030406@gentoo.org>
	 <20070803052935.GA12683@deine-taler.de>  <46B2E06F.4090706@warmcat.com>
	 <1186134894.4647.24.camel@johannes.berg>  <46B3032C.5040306@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-I8UK0uSy8aJq0K32enWZ"
Date: Fri, 03 Aug 2007 12:32:46 +0200
Message-Id: <1186137166.4647.34.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-I8UK0uSy8aJq0K32enWZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-03 at 11:27 +0100, Andy Green wrote:

> Inside that question, if you mark up skb->ip_summed with CHECKSUM_NONE,
> include/linux/skbuff.h says this:
>=20
> /* A. Checksumming of received packets by device.
>  *
>  *      NONE: device failed to checksum this packet.
>  *              skb->csum is undefined.
>=20
> If we mark up the skb with FCS-broken packets with that, maybe it would
> be compatible with the networking stack for this purpose.

No, that's the IP checksum. It may or may not be broken if the FCS CRC
fails.

johannes

--=-I8UK0uSy8aJq0K32enWZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGswRO/ETPhpq3jKURAtWCAJ40TkrHyWBhrHlZnp1Et4nTRJilUQCfXgiv
5qyqsn3vnApgVsm7oUsdQVs=
=tsnY
-----END PGP SIGNATURE-----

--=-I8UK0uSy8aJq0K32enWZ--


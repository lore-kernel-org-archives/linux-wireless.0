Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35064 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbXERHEX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2007 03:04:23 -0400
Subject: Re: [PATCH]  Add iwlwifi wireless drivers [part 2/2]
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	James Ketrenos <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070517080540.4db88dd4@freepuppy>
References: <464B7B7C.5080800@linux.intel.com>
	 <20070516203505.556df4f9.randy.dunlap@oracle.com>
	 <20070517080540.4db88dd4@freepuppy>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vinAXe/8kzToeNELV/1i"
Date: Fri, 18 May 2007 09:04:16 +0200
Message-Id: <1179471857.3658.12.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vinAXe/8kzToeNELV/1i
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-05-17 at 08:05 -0700, Stephen Hemminger wrote:

> I did this in sky2 driver:
>=20
> /* Return high part of DMA address (could be 32 or 64 bit) */
> static inline u32 high32(dma_addr_t a)
> {
> 	return sizeof(a) > sizeof(u32) ? (a >> 16) >> 16 : 0;
> }

Note that akpm recently added a macro/inline for this to the tree which
IIRC went to Linus.

johannes

--=-vinAXe/8kzToeNELV/1i
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGTU/w/ETPhpq3jKURAsJuAJwJLJHv8DJUggl+ATFMV0ml5FTxqwCfe3Cp
X7JWNeOgy4tyKUG24UVAfVw=
=+JsI
-----END PGP SIGNATURE-----

--=-vinAXe/8kzToeNELV/1i--


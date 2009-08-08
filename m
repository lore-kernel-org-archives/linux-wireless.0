Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53755 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933653AbZHHJJG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 05:09:06 -0400
Subject: Re: Mesh fixes and improvements
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org, andrey@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
In-Reply-To: <1249702711-32737-1-git-send-email-javier@cozybit.com>
References: <>  <1249702711-32737-1-git-send-email-javier@cozybit.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-u1tZnKP+M/OH+1JyTB6o"
Date: Sat, 08 Aug 2009 11:09:02 +0200
Message-Id: <1249722543.31670.19.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-u1tZnKP+M/OH+1JyTB6o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-07 at 20:38 -0700, Javier Cardona wrote:
> [Resent with proper patch numbering...]
>=20
> This series includes some fixes, testing aids and improvements to the mes=
h
> stack.  It is important to note that the patch
> "Use-3-address-format-for-mesh-broadcast-frames" breaks compatibility wit=
h
> previous versions.  This is unavoidable and will keep happening as new ve=
rsions
> of the 802.11s drafts are produced.

That's ok, can you update the Kconfig though to indicate which draft
it's compatible with? It says 1.08 right now.

> Also, I'm not sure if "Simulate-transmission-losses-on-plinks-to-..." sho=
uld be
> merged upstream, but we find it really useful to test mesh configurations=
.
> Please comment if you have different opinions on its adequacy or
> implementation.

As I said elsewhere in this thread I don't think that should be in,
especially not, as Kalle points out, using nl80211.

All the other patches look ok on a cursory look, I just wish you'd write
more detailed changelog entries.

johannes

--=-u1tZnKP+M/OH+1JyTB6o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKfUCrAAoJEODzc/N7+QmaWUsQAI01HfZvhpgwvknH3KtSI47r
84msnCNzR5Nl5398pxfcdxCZElhzc+n4SLhXXuuT0q2RXhO1vWTkXAknejDFLZtt
BgFoUUW9Ku5Syq8JZfQf1+M4HD904ruAnd1aNXMz4qs7TZ2ji3lMX0ksAgd7BhAl
SAuIGSc7yZvkwH6+0xRveGBvMNsEzR5Sft7u3dBfBMDAyO4JAXdhyBt9XIDY2mUO
U2G0Np3hIL0MVaI9GSWOMDPbX2YXK7ZjuH56OdasfiFC0NnMqIp0zzoPEuDiz9wj
ih69L1BEb1BECJVaO0gVUddAHvRQWMXg1hkB1GhNkiZn94CyN8DvSL986lihYUnC
C4eb4Nbxu36Szk1Q9Tm1ifc7Rgui7F9wndC7kn0ykC5R4RZlNwxn5pI29HSFnQKZ
RF5S7z2+d7PWP7rnqE4hdbGZ1rkFdrtNEbqLDP7TDSDdI5ILR3BjUaPE/ivDJhks
N1n+PXpeFlkMO/lQXpfMNONKiAWfdnlFrySY5fHwyDudtlG80DFJUFHMXbHEHAA8
XBiCH/JBEkx2XzhtayJqj8uIMNFmnGkY8hLw+7wCQMsUCr/hkT5ceMTlNHFkO/oT
sUyysp8VbFxtcumKIj5BwHzuQvfHz+ulKa86ei1mCDLrmwL3at+kXvyHrHd/DsRH
6D8EMZ66kMdTxZxFyqLN
=tXuK
-----END PGP SIGNATURE-----

--=-u1tZnKP+M/OH+1JyTB6o--


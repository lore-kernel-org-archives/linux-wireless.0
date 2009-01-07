Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37648 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbZAGRai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 12:30:38 -0500
Subject: Re: [RFC v3] mac80211: extend/document powersave API
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: Vivek Natarajan <vnatarajan@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <87tz8b3u6i.fsf@nokia.com>
References: <1231264395.3654.10.camel@johannes>
	 <1231273502.3767.4.camel@johannes> <878wpn5d64.fsf@nokia.com>
	 <1231346625.3545.56.camel@johannes>  <87tz8b3u6i.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fXFDRRDnxrJd8/RbRTZN"
Date: Wed, 07 Jan 2009 18:31:00 +0100
Message-Id: <1231349460.3545.63.camel@johannes> (sfid-20090107_183040_795048_709D4D26)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fXFDRRDnxrJd8/RbRTZN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-07 at 19:25 +0200, Kalle Valo wrote:

> > -set:
> > + set:
>=20
> Really? My emacs always indents it without space, should I fix my
> settings?

I like it better for two reasons:
 (1) my editor uses a heuristic to display the function you're in, and
     the heuristic will display the label if it's in the first column
 (2) diff -p does the same, so you'll end up with the label in the @@
     row which isn't very useful.

The "right" way never got added to CodingStyle, despite discussions.

johannes

--=-fXFDRRDnxrJd8/RbRTZN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZObSAAoJEKVg1VMiehFYJ24QAJjM8z6CtYmXgwOEYZ0B+fkO
j+mxoG6BeTElRZwbUyGKkSAePhY3qUK8x8wApuYezK6IVwQT3CInmGo6XdbdJHOi
noAZlg1i6lSdLCLn5XJhtmBXpHKANZuW5cWcYSLWqR5PQ+qOUjHBUPOayOVMZO2c
fGNsYYGK3YNiTBVy9b1iUG52mHEs9CVgicaN5jO0NdZvRqDjSwt08wARGA0/DaTl
n7AecWsPN2MYSYXwojMHfiNyfk+S9mjFOgaFPwNbRDvr31AuECiNX4t+aCKVS9Es
6Szum1R+VSGtbT3O01e6RJMKKcAuPfd7AoO1F+ar74gwDLxd4Ie+VIDqVOE2p7pL
xXwifUG6IH/tIqAy6QhqtZw+er+BNDcr0obYumlFi7FwGYu56JM/m4BbyrOKnKhb
g5s/NGcI7JLSI8jbP266dwPwI1oBRtEZWkYfBY/J8Z1OZXGfiKsxS+gOPZ9T8WQO
gFM4xyG0rHlw+f8iAQl4jPfPeY0mXe+zkPcjNU6x5rhJ8kSkg5D2gqsUiY3+r8eJ
eJWJPKWdsby99kzQTtN/TmFTQ4XXZqCgWP05uYvyqn87yas1cyzIHWDCXwgzI1EN
FN7iDgc2GcFNARSq3TBEuiWnZfugOqELINQB5xusqDPv0ScqU6cJBXqWaTjCQZLo
1aoDDwApbsQ8iMA6b02V
=6bE7
-----END PGP SIGNATURE-----

--=-fXFDRRDnxrJd8/RbRTZN--


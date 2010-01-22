Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53397 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab0AVU2u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 15:28:50 -0500
Subject: Re: Starting hostapd causes kernel panic
From: Johannes Berg <johannes@sipsolutions.net>
To: Markus Baier <Markus_Baier@web.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20100122T205326-794@post.gmane.org>
References: <loom.20100122T205326-794@post.gmane.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZAYZFSn9WQdUfKVYCsLU"
Date: Fri, 22 Jan 2010 21:28:46 +0100
Message-ID: <1264192127.2593.15.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZAYZFSn9WQdUfKVYCsLU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-01-22 at 20:14 +0000, Markus Baier wrote:
> After the latest git pull from wireless-testing
> master-2010-01-14 to master-2010-01-19
> the start of hostapd causes kernel panic.
>=20
> Tested with wireless-testing master-2010-01-19
> and hostapd 0.6.9 / 0.7.0

> EIP: [<c126afc9>] invoke_tx_handlers+0x909/0xf40 SS:ESP 0068:f6c07b34

Would you compile with CONFIG_MAC80211_NOINLINE (may need to enable
CONFIG_MAC80211_DEBUG_MENU) and give me the stack trace then? But maybe
I can reproduce it this way.

johannes

--=-ZAYZFSn9WQdUfKVYCsLU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLWgp7AAoJEODzc/N7+QmaYUEP/RJr8k+2SLUrEB4wckXhr9R4
mKN1pDCYZZ9xrz04SAzXZA2JpC9O3JeeUA8n32NOG7wi2lpLaizDMDe1oEghiz91
raugEMHUj2Gzxno9gyNEbHStAWLHVD0ylCHlX++akzeDMZnJA4lQUZHIvwNhz2+w
3JyKAnqWsXy+ejCECe5w8RbhTkf36y97H0hCtoAGrVAH6ONyB/h+9RfeCktDmh1o
1DOwuIXuWGnqHExu6OW/ZYRbHNeYeGwDbK43Xj1lBp+Ipcfx676DxkNstvFlnxZE
DfNwVNE2BW2gGwFw78+5gK/GSmnWBNXoI2OlxqoDM9EAOSqQbJHPYNyqfTNa0pOC
zSZgH7pfHJqXd61IDGAHbG4kGWPSKydlEBZxh8Nn7esn5bfCFNopDj5aYYyweZS8
XnzsreDKekWwxsQvB9+fFPqTklbUwXoyYsfJsWYYD4YrsHMKSDoPyz5+aNRTmCKT
K2a3LNz4yLyS4qAYkDXZBbvho+UZ524/Ua17rP1l4Uxz3qx1nAQVqMsz1OjwQX9y
/gNXrF4XIZfyzbg/32IaJnsojSF1dI+c2a+esOuY6FfWUHoTKMOrnLp6Uaa7MUZh
qTTtLWiuq3c+YJOxmko9Y8Pl3EuHPSb7mNSYt/KZkuzMGtGTD2H9RWK49aUEGnK6
8/mK9x7PZx5AyILTStjO
=ldRU
-----END PGP SIGNATURE-----

--=-ZAYZFSn9WQdUfKVYCsLU--


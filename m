Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50255 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbZFBHqP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 03:46:15 -0400
Subject: Re: b43 : unaligned access on mips
From: Johannes Berg <johannes@sipsolutions.net>
To: matthieu castet <castet.matthieu@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4A244F6C.3000509@free.fr>
References: <4A244E19.7090501@free.fr>  <4A244F6C.3000509@free.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/18kvp8cxuo/+dHABDcw"
Date: Tue, 02 Jun 2009 09:46:14 +0200
Message-Id: <1243928774.5299.38.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/18kvp8cxuo/+dHABDcw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-02 at 00:00 +0200, matthieu castet wrote:
> matthieu castet wrote:
> > Hi,
> >=20
> > b43_generate_plcp_hdr generate unaligned access on mips with gcc [1]=20
> > from openwrt.
> >=20
> > A small testcase [2] show that &plcp->data is access as a 32 bit aligne=
d=20
> > variable (see the "lw      $2,0($4)" and "sw      $2,0($4)").
> > I don't know enough mips to know if it is a gcc bug (ignoring the packe=
d=20
> > attribute) or something missing in b43 code.
> For example using "plcp->data" instead "*data" produce the correct code.

That's valid, send a patch.

johannes

--=-/18kvp8cxuo/+dHABDcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJNjDAAoJEODzc/N7+QmaedEP+gKUAOB4G1ip0B1E4s+DqV3j
Awc+3v1jiwEV1e1XLakeL6222Kb+UDsY9rXyop0lA+68qa/6sCVN/cM5Xwss9P4Q
4gccHB0i+OstxF43+GaOe0ecJE8EJ/3PMu8VI3kCq1MyDRo5U/bQTL4UgqE3s76U
WgJIYgTepOAqhylcPVb2ASG9Slc5+XZAhVyqO6+DdQWMA0QFWUDIOFdfM+3s9QGT
kZ1BErgHSjV62G0ZiMauxqyn/TsGF+Ec0XX6Zip3zjevKI1EmcYgvmasBAO7/Bjn
bhdJfZow/SGUvU5OXV4cyj7XrF7hxLyoMejkTT16mfIbzcO7QH4Q37WTr59H5PZI
ItQzYbNypvbP5L4neDaaOuILMTNugksE2mnuxsMLb2LlCq71pfZ6rvIR+EYXQJ0x
jsmo3o/UqoPPXj7Aa/vWpi1OimgGgsCp/35zcjf6nOHdOTjMKVYDUdQF28k68hJ+
X22PQw6ghJMP2FBPdS/cP0TEnWXTRMjBxujMSjT7ztMgxa473JU+HpCm/SPuPBuD
L9uXYQUp4kpLD8Wtg8NHr7Zb5HNnUhPbKIn1Quzbq9CIZrtCpiobh4XuDlV7vbFH
YDITZAMkuQAyMCbb8eBTRpMvylYJE5cb9vf3twzkDtr80qhUsuV/VlQwa3oFTIql
wtLGMjd/qw3mVr0RlQ7P
=CmJX
-----END PGP SIGNATURE-----

--=-/18kvp8cxuo/+dHABDcw--


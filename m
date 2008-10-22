Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46469 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbYJVH51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 03:57:27 -0400
Subject: Re: New iwlwifi 3945 uCode available
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: reinette chatre <reinette.chatre@linux.intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224662185.9386.131.camel@californication>
References: <1224613633.10863.43.camel@rc-desk>
	 <1224624324.28639.9.camel@johannes.berg>
	 <1ba2fa240810211433q2e7a13b2p45cb8d38a74393c9@mail.gmail.com>
	 <1224624899.28639.17.camel@johannes.berg>
	 <20081021213814.GM17268@tuxdriver.com>
	 <1ba2fa240810211453y40739183v84999364c89886ee@mail.gmail.com>
	 <1224627187.9386.103.camel@californication>
	 <1224628088.10863.100.camel@rc-desk>
	 <1224660449.28639.22.camel@johannes.berg>
	 <1224662185.9386.131.camel@californication>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JwZ9RyBfps+dH1T0nHvP"
Date: Wed, 22 Oct 2008 09:57:17 +0200
Message-Id: <1224662237.28639.31.camel@johannes.berg> (sfid-20081022_095730_876573_BBDCAA1E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JwZ9RyBfps+dH1T0nHvP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-22 at 09:56 +0200, Marcel Holtmann wrote:

> > I really don't know why we let you get away with this and bitch
> > endlessly when b43 does such a change, to the point where we finally
> > cave in and support both versions. Why should a community-supported
> > driver be held to higher standards?
>=20
> If in any way possible, we should support both versions of the firmware.

It doesn't look to me that the wireless folks will succumb to any
pressure unless John reverts the patches. But they haven't even managed
to identify the patches that caused the breakage...

johannes

--=-JwZ9RyBfps+dH1T0nHvP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/tzaAAoJEKVg1VMiehFYCwMQAKVQK79Lu4gfK7IKTzDWcOiT
D0Cfx3DIgWGnMRkLHin/Lyi79x0Lu8VtRfsxbQGTv+w4+KQ1uZ0N8AlKXHy6B6/p
OhhcKYoD35vDiZlNVhVoF5tOpm8wn7ZBaaLuh5ubgdVcrIHeQOawwdfDZcCyitDq
Yb6FC7DZIbLP/eyoVNDn+6bZJmyRM92nCZQSJV6afmKu3jmiWxqYs8/uETkZr6rQ
WWNA/njgit3v89QZmFf/1AJSuQIpixAbwgh+ewfITUdzJ9AzNpF/4C7B33mGI03B
GZLK5RIebyshk1L34fi6NtorGyd5R3rLiHD+hFrVH+uubO1ciydOjhXRebsp6n50
2ayk+PpJ1jipuEpZX/8LudgZfSUP+27CCrqyNrPMJvpIqwl2F7wA3WeQMQvct/au
peHPvpw0GQQIr4fcKtmCf3QSGjgNiWROi++yM861RS9OOSl8WEUGw5cBiHZ9GSAy
QLn3ESDVDcAbM+lXvt2HtJb6jzjlCrFgxPD4E8KRsXI85HlOPfZeQHDrhK4839/X
0FiT+D156zIrv/JyXEAydvVM1AXMBNADfO6zxWnSucyvuUzZ11LhIq/69+HGCRYg
E0tAUy9SnL4Qel++abutOoqehHj4VuNsYBY49p0qhYWym+ECIzPMwY1pEBubqW0o
U/o2WEk2sbuM+SK0EP+S
=X2e9
-----END PGP SIGNATURE-----

--=-JwZ9RyBfps+dH1T0nHvP--


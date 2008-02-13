Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42290 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbYBMMtC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 07:49:02 -0500
Subject: Re: [PATCH] ipw2100/ipw2200: note firmware loading caveat in
	Kconfig help text
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Drake <dsd@gentoo.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw2100-admin@linux.intel.com,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20080212134942.9FD589D4135@zog.reactivated.net> (sfid-20080212_141033_444486_ED50E00D)
References: <20080212134942.9FD589D4135@zog.reactivated.net>
	 (sfid-20080212_141033_444486_ED50E00D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-40gDdzgdwM4ED6TnnndC"
Date: Wed, 13 Feb 2008 13:48:50 +0100
Message-Id: <1202906930.8931.44.camel@johannes.berg> (sfid-20080213_124908_381772_B7F30A68)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-40gDdzgdwM4ED6TnnndC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2008-02-12 at 13:49 +0000, Daniel Drake wrote:
> Most wireless drivers load their firmware at interface open time, which
> generally occurs after the filesystem is available. However, the ipw driv=
ers
> load their firmware at probe time because firmware is required to read th=
e
> device MAC address. When built-in, probe happens before the filesystem is
> available, hence device init will only complete successfully if the user
> has made special arrangements (including firmware plus a loader in the
> initramfs).

I wonder if the MAC address can be read directly like the 3945/4965 hw
can?

johannes

--=-40gDdzgdwM4ED6TnnndC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7LnMaVg1VMiehFYAQLGTw//UYVXDq0TBzgC9k5pYShiJ4Pu5w4YYAch
U4qs/UvWY3Spv699hYf3ckEmil2ow34s4q1xY+kFa4iTP8TEhbXx4Kjyhp3wnPzH
u8uwJd4+a1oPIZHFSJjch4MygTIfkmzENnC/S8lq02aFIWwzLv+dtkFSacjRxOLk
Hi5o/do9qu5fz9ypa4WnVfVv9JD7m3mzC3k+3KXOn+3XN9PqsiywBPCmWyEiRlHh
OZTvFGPhatogFz5yNLhMfCiNqlf+19kEl4+isodQ9FVQov72zenjH+JRAO2AjKoe
+enNA+/zm60ZFV4SaE3497hFtGTiaW2l5hlOvHn3lLu/QkGiCJTiPrQ7o2x2kNkj
stcBw+yLSvmdb142cZdZ4fwNehF/gI2b0qKOZB05DN1DWhpRoCd+ACv8qvueWUyS
uTex8GBsLNgd0TYQkH4ftxfGl/aGKYnaPLrwTFiVfhQJEAU1TwdpD89TY98T4EI7
cusdaj1BR9Lzk//Ba54fqelfbdYu7ztmUb/Ba95R5GZ54q39SaZGQK5GSnen0N25
x0lSMyUPbCArVJyEO+X0lGd0cWZ2CayiBOPiEkXuCvHY4HjbmCy+Xz8G5bjB8NZ2
hBsb1HQq4BhKpRR+sNvE4VabgQCJGBtkvSlfJJaObNXfkP4gXOCMK72aIMsr7xRB
1m2suJUPBJk=
=Q+Am
-----END PGP SIGNATURE-----

--=-40gDdzgdwM4ED6TnnndC--


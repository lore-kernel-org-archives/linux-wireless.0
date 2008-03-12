Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60729 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbYCLOyk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 10:54:40 -0400
Subject: Re: [PATCH 5/5] mac80211: remove Hi8/Lo8 helpers, add
	initialization vector helpers
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1204968188.23455.41.camel@brick> (sfid-20080308_092341_810876_E42905A3)
References: <1204968188.23455.41.camel@brick>
	 (sfid-20080308_092341_810876_E42905A3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1snrXHipj+dHyyWHrgxs"
Date: Wed, 12 Mar 2008 15:54:16 +0100
Message-Id: <1205333656.15910.8.camel@johannes.berg> (sfid-20080312_145446_558589_DD15F6CE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1snrXHipj+dHyyWHrgxs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +static u8 *set_tkip_iv(u8 *pos, u32 iv32)
> +{
> +	*((u32 *)pos) =3D cpu_to_le32(iv32);

I can see alignment problems here as well.

johannes

--=-1snrXHipj+dHyyWHrgxs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9ful6Vg1VMiehFYAQINIQ/+L4chV+c/imiVlB64E1O0b1GoLF+x92i1
l547bGHg94bhd+4Z7BRuMIcHTIygZsK7Xfytc5tkTPUqLtWmUChP6Xlxbq6N9swk
BHqcLP7+wnXvj8Yh1QKvsYhXRi7m7+PFl1Isd2GU70cm+ft23Ph7nW1Ts0jVoLUT
wRuFammY+rMRByjHGHNYVqwgQ0oHtebySBMqXuJ+lxENcuczAbhxpVNAqYgQXq2D
kp1AZT82x1QShTZlGUWLHVO2K9FU1TQgFMnZBT0SvMpEnWgWGsZGMmfY8IflVdX4
FOFUBR/ZlTNvj9BX5Afcc0PZDjOhBETxRvs8/rFnNzAGYVNbiJVE/+yYkB+Tr6LC
phkDSbM9Jk0beWcYxTiJzqESeDDQK/9tZ6/QFXRDOKHUV/IE9t2J2ZUmxXMzGvo6
LztpJjyzZ0VmSU3WIYeiD1dR3f+GuIPYunebGtB4p2fLBHl3MDrv+aanVw84WARM
IZzybqiDSJzYXDE2AFJTDa0mOC1li4O6tIX5IvGAeZgHh7ajHJTmCpXJUL+2i9ix
NEjzU2vBjVrdaPLD+HKTgWbz+M13tac5OdQ8cVK0zXP7RI8amnlwOy8IeverKafD
HCHT2QhjEiTo4D1ix1wIFjcbvH2uww4fkFNGupWvxXKFSeIqEAKpeRiDCpmZWzr+
K2K5R+shJec=
=W/5Y
-----END PGP SIGNATURE-----

--=-1snrXHipj+dHyyWHrgxs--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58521 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761944AbYCTAHI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 20:07:08 -0400
Subject: Re: [PATCH] iwlwifi: prevent tuning during scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>
In-Reply-To: <1205970201-22241-1-git-send-email-reinette.chatre@intel.com> (sfid-20080319_234534_228497_EC4DD4E8)
References: <1205970201-22241-1-git-send-email-reinette.chatre@intel.com>
	 (sfid-20080319_234534_228497_EC4DD4E8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bS7sBhoAHkcuQt+yNEPT"
Date: Thu, 20 Mar 2008 01:06:52 +0100
Message-Id: <1205971612.16475.87.camel@johannes.berg> (sfid-20080320_000714_985260_CF9C7AB4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bS7sBhoAHkcuQt+yNEPT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Wrong patch title. Trying to sneak patches past me? ;)

Also, I thought you explicitly wanted the channel change callback to be
allowed during hw scan because hw scan could return to the home channel
inbetween...

johannes

--=-bS7sBhoAHkcuQt+yNEPT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+Gqm6Vg1VMiehFYAQIgwA//R4NQKwjMXkfs+DQi0gnMw5D9GcVCUPHM
3A0TOruJ8vIqcrchzCwFXD5bzE5qJ9zXvxev8SkuygtNemMKymJZDwKrlpZnU0fb
unKmwIaz0fr1PiONbX/dqptgYbrbzAXpD9893oWqcXzNGqd0ckN/LnKZ2pkstsHD
L2OKg7JyVwcQlxpoyZrQ8S5uElbuoViLUyl9DDe8+GQMD8/W8SYxDiy8R5DTjTxG
1tBBK2I9LSWXzjbmG5c27Eaj0syPWYARp+DqE0PX5H11SjnLQp/fIr9wHaw7xOA1
31N9aIyH1eLV6V1Lvh7oRqk8yNrGO6YMIxVLAvlgaqeLTTkAwrQRE/aslLFCp4vj
vq414sycxFgNog3ZANaop9PuwAI4Elt0w6ZMudZ6j9SRaIQ1nMvTq1UPt19+MpLa
QScwRza5p9oB4dSMndS3XrI0R7o5DF1jXcsStmKLxjBN9t3RNQrRa97UuaXYXLUz
zXhGPkrrLkzW0rEBoY2dgv9Ouw7KNSZ8mM6ZX3W6NbQb1m+FH5TLwxXGxrNf3Wof
X69NitJWtA/YK/P+5pkwGuKbavoprDKAj5ijsPlWCE0pbMWpj6fZGRG/dm5zAYjI
m1m0lsn+EAze2KWb3dqTFVplCKF28rc1oBeBHNX8ZBoRM0sRSvyDj91f1R8X0yGq
QE8OdgvB2cw=
=jY80
-----END PGP SIGNATURE-----

--=-bS7sBhoAHkcuQt+yNEPT--


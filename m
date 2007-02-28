Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52512 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbXB1Qhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 11:37:48 -0500
Subject: Re: [PATCH 2/28] rt2x00: Add debugfs support
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200702281732.08221.IvDoorn@gmail.com>
References: <200702281507.13953.IvDoorn@gmail.com>
	 <1172679612.5015.35.camel@johannes.berg>
	 <200702281732.08221.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lRbwVT7EvvrH9r73t1YQ"
Date: Wed, 28 Feb 2007 17:37:19 +0100
Message-Id: <1172680639.5015.39.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lRbwVT7EvvrH9r73t1YQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-28 at 17:32 +0100, Ivo van Doorn wrote:

> Well at the moment the cfg80211/nl80211 updates have had a great impact
> on our CVS tree. So it is starting to look like we are going to drop our =
CVS
> version if we don't find a backwards compatibility for vanilla kernels fo=
r it.

Well, we had to start looking forward somewhere. I wish we'd gotten our
cfg80211 wext-compat hooks into mainline but unfortunately that isn't
so.

> Working the other way around will have a negative (But as mentioned above
> a probably unescapable) side effect. 90% of our testers use the CVS again=
st
> vanilla kernels, and I cannot see them swicthing to the wireless-dev tree=
..
> So I could switch (it is already under consideration) but it will cost us=
 a lot
> of testers.. :(

Intel is providing snapshots for this stuff and I think James is still
trying to figure out if there's any chance to provide cfg80211 w/o
patches to mainline, which may just work until critical functionality
mac80211 is moved over to cfg80211 instead of wext.

johannes

--=-lRbwVT7EvvrH9r73t1YQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5a+//ETPhpq3jKURAnn2AJ9dGg9MmNFAIQ22LfJW5snzECl7cQCbB1qa
Hvu+BCO/nftP4tbt76k4b0k=
=77iL
-----END PGP SIGNATURE-----

--=-lRbwVT7EvvrH9r73t1YQ--


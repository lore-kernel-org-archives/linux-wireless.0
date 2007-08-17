Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52794 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763643AbXHQVTY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 17:19:24 -0400
Subject: Re: [PATCH 1/2] mac80211: embed key conf in key, fix driver  interface
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070816135318.221574000@sipsolutions.net>
References: <20070816135314.691716000@sipsolutions.net>
	 <20070816135318.221574000@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0v/+geF6pa6BnDdtM7WV"
Date: Fri, 17 Aug 2007 23:02:34 +0200
Message-Id: <1187384554.6090.9.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0v/+geF6pa6BnDdtM7WV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-16 at 15:53 +0200, Johannes Berg wrote:
> plain text document attachment (042-embed-key-conf.patch)
> This patch embeds the struct ieee80211_key_conf into struct ieee80211_key
> and thus avoids allocations and having data present twice.

Somehow, this missed the changes to ieee80211_key.h, I'll resend.

johannes

--=-0v/+geF6pa6BnDdtM7WV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxgzq/ETPhpq3jKURAjRHAKCNb/PVbhpZwFaCP5Wq6elpUXAI/gCfXMsj
LHzk09YCpNUZ9m99Tdojqkg=
=+BxP
-----END PGP SIGNATURE-----

--=-0v/+geF6pa6BnDdtM7WV--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51538 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961AbXHTLXV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 07:23:21 -0400
Subject: Re: [PATCH 08/20] mac80211: remove unused ioctls (3)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070818040943.GH1415@jm.kir.nu>
References: <20070815144920.135826000@sipsolutions.net>
	 <20070815145045.151670000@sipsolutions.net>
	 <20070818040943.GH1415@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WbQsUEViikVrv0Gff7bJ"
Date: Mon, 20 Aug 2007 11:15:41 +0200
Message-Id: <1187601341.6090.50.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WbQsUEViikVrv0Gff7bJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-17 at 21:09 -0700, Jouni Malinen wrote:

> Create IBSS is a somewhat commonly used configuration and so is mixed
> cell configuration in Cisco-world (and the only point for the
> privacy_mismatch check that is left broken after this patch).

I was under the impression that the auth mechanism setting would still
do that. What is "mixed cell configuration" anyway?

> No, but iwpriv.. See the pattern here.. ;-)

Oh, I can see that, but none of these things are documented nor do any
existing tools use them. I don't contend the fact that these may indeed
be useful, but I think none of them should be private ioctls. If you
have a use case for all of these I'd be happy to see an explanation so
we can add this with proper documentation elsewhere. Without
documentation, they are a rather useless special configurations nobody
will ever touch.

johannes

--=-WbQsUEViikVrv0Gff7bJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGyVu9/ETPhpq3jKURAhfTAJ9kPDhiQCBB6X4Lt+oC48Og29dJ/QCfceW4
FlWcvR+dLUaWw168Yq3qVXk=
=AaRb
-----END PGP SIGNATURE-----

--=-WbQsUEViikVrv0Gff7bJ--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55062 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbXH0Nl4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2007 09:41:56 -0400
Subject: Re: port of my recent patches to net-2.6.24
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Jouni Malinen <j@w1.fi>,
	Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <200708270029.35845.flamingice@sourmilk.net>
References: <1188027470.9529.5.camel@johannes.berg>
	 <200708270029.35845.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7BiU8D3OGGCOqK5P++nq"
Date: Mon, 27 Aug 2007 15:43:03 +0200
Message-Id: <1188222184.7837.24.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7BiU8D3OGGCOqK5P++nq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-27 at 00:29 -0400, Michael Wu wrote:

> Patch 10:

[...]

I addressed your comments with the patch against wireless-dev I sent to
linux-wireless a few minutes ago. The same patch I rolled into the
updated patch 10 at
http://johannes.sipsolutions.net/patches/net-2.6.24/all/2007-08-27-13:38/

> Patch 17 (by Jiri Slaby):
> +	pkt_data->flags &=3D ~(IEEE80211_TXPD_REQ_TX_STATUS |
> +		IEEE80211_TXPD_DO_NOT_ENCRYPT | IEEE80211_TXPD_REQUEUE |
> +		IEEE80211_TXPD_MGMT_IFACE);
> Or set it to 0?

Yup, changed, and will post change to wireless-dev.

> I'll review the rest of the patches tomorrow.. Patch 22 (revamp key handl=
ing)=20
> is a bit too big and scary for me to review tonight.

Don't go any further than 027 and then review those against wireless-dev
I posted instead, though I expect I'll be reposting today to fix the few
bugs people found.

johannes

--=-7BiU8D3OGGCOqK5P++nq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG0tTn/ETPhpq3jKURAgYcAJ9X6wty39aIkAF3id/Sj8r9F6+9IgCfTppF
G/JWf4sTOx2PXJqV2gw5D94=
=Itj4
-----END PGP SIGNATURE-----

--=-7BiU8D3OGGCOqK5P++nq--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49710 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbXHOKsm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 06:48:42 -0400
Subject: Re: [PATCH] hostapd: remove use of  ieee80211_msg_wep_frame_unknown_key
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070815033555.GI1415@jm.kir.nu>
References: <1186781366.17351.8.camel@johannes.berg>
	 <20070815033555.GI1415@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1bN5FHzLb9xQVY4HUtit"
Date: Wed, 15 Aug 2007 12:45:59 +0200
Message-Id: <1187174759.3998.8.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1bN5FHzLb9xQVY4HUtit
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-14 at 20:35 -0700, Jouni Malinen wrote:

> This feature was originally used to allow a station to be disassociated
> if it seemed to be using incorrect keys.=20

Makes sense, this is a bit icky.

> However, this was causing
> interoperability issues with some client implementations and the code
> was eventually commented out and this was only used to update a dot11
> MIB counters. Consequently, I did not see much point in integrating it
> into hostapd and we might as well just remove the TODO item completely
> from hostapd.

I'm not sure whether it'd be worth it going forward anyway, with WEP
deployments hopefully going down.

johannes

--=-1bN5FHzLb9xQVY4HUtit
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwtln/ETPhpq3jKURAn3xAJ9J9o2VMRzbPfj79Ff7iDPT0SXhkACgj5/l
ZtL9zY+u0pd07V9Qj3CTjmI=
=+PUD
-----END PGP SIGNATURE-----

--=-1bN5FHzLb9xQVY4HUtit--


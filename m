Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49631 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbXHPNOD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 09:14:03 -0400
Subject: Re: [PATCH 18/20] mac80211, drivers: remove reset callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200708152010.52433.IvDoorn@gmail.com>
References: <20070815144920.135826000@sipsolutions.net>
	 <20070815145049.384297000@sipsolutions.net>
	 <200708152010.52433.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ObUAvaE4RdNf9Twa1MDb"
Date: Thu, 16 Aug 2007 15:14:41 +0200
Message-Id: <1187270081.5141.33.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ObUAvaE4RdNf9Twa1MDb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-15 at 20:10 +0200, Ivo van Doorn wrote:

> ACK for the rt2x00 part.
> If reset is permenantly gone, I'll probably move the reset handler
> to rt2x00dev.c soon since that is the only place where it is used
> at this time.

I noticed, but wasn't sure what you planned so refrained from further
changes (also to make the diff smaller etc.)

johannes

--=-ObUAvaE4RdNf9Twa1MDb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxE3B/ETPhpq3jKURAmznAKCHA/vJy0tzuFBvgsLt8epfJegczACgk00p
vAj5wJ5NtmlsZ+VpsBpbj3A=
=lpzG
-----END PGP SIGNATURE-----

--=-ObUAvaE4RdNf9Twa1MDb--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38539 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbXHGJmu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 05:42:50 -0400
Subject: Re: [PATCH] zd1211rw-mac80211: use correct preambles for RTS/CTS  frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Drake <dsd@gentoo.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kune@deine-taler.de
In-Reply-To: <20070805231845.657BA7B409F@zog.reactivated.net>
References: <20070805231845.657BA7B409F@zog.reactivated.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4CvgaWQ4W8N+dGk4R6vu"
Date: Mon, 06 Aug 2007 18:15:23 +0200
Message-Id: <1186416923.28655.78.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4CvgaWQ4W8N+dGk4R6vu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-06 at 00:18 +0100, Daniel Drake wrote:

> +	/* We always send 11M RTS/self-CTS messages, like the vendor driver. */

That will most likely be safe almost everywhere, but I don't think it is
required by the standard that 11M is a valid basic rate and these frames
must use basic rates IIRC.

johannes

--=-4CvgaWQ4W8N+dGk4R6vu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGt0kb/ETPhpq3jKURAsOKAKCjjxAREolk9e1Mq9FQ6v18MyUMmwCgn17g
STyf90PeZ6bK5jGcHlmG+QQ=
=in0M
-----END PGP SIGNATURE-----

--=-4CvgaWQ4W8N+dGk4R6vu--


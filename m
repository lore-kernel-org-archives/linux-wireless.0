Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60722 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbXG3LcM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2007 07:32:12 -0400
Subject: Re: Linux wireless stack question
From: Johannes Berg <johannes@sipsolutions.net>
To: maali Al Janoob <mms82@hotmail.com>
Cc: tomasw@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <BAY111-F325FAED32F3D133BCD0C69B6ED0@phx.gbl>
References: <BAY111-F325FAED32F3D133BCD0C69B6ED0@phx.gbl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ETxmtgnP9ZhJ4CWfSMQH"
Date: Mon, 30 Jul 2007 13:33:18 +0200
Message-Id: <1185795198.4006.89.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ETxmtgnP9ZhJ4CWfSMQH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-07-29 at 18:21 +0400, maali Al Janoob wrote:

> What I want to do basically is changing the backoff algorithm to implemen=
t a=20
> modified protocol in Linux (for my thesis). From what I know, the firmwar=
e=20
> is inaccessible. Are you aware of any available source code for a firmwar=
e=20
> of any driver?

Nope, none freely available. There are some efforts (prism54, bcm43xx)
to write free firmware for some devices, but none of them are in a stage
that could be used. (prism54: dunno, but I know it's not usable;
bcm43xx: only partially reverse engineered)

> Please, I need this help so badly to continue my thesis work, any ideas?

Play some connections to get firmware under NDA?

johannes

--=-ETxmtgnP9ZhJ4CWfSMQH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGrcx+/ETPhpq3jKURAod0AKCqrM1Eg4EePQAx78zlGgtnuvovzQCfShP3
G6/ruXKQI0BV3frrZUUzRBE=
=ha/v
-----END PGP SIGNATURE-----

--=-ETxmtgnP9ZhJ4CWfSMQH--


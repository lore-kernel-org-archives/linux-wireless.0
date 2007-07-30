Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50277 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759534AbXG3MQ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2007 08:16:57 -0400
Subject: Re: Linux wireless stack question
From: Johannes Berg <johannes@sipsolutions.net>
To: Alfredo Matos <alfredo.matos@digitalself.org>
Cc: maali Al Janoob <mms82@hotmail.com>, tomasw@gmail.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1185797310.12159.2.camel@pegasus>
References: <BAY111-F325FAED32F3D133BCD0C69B6ED0@phx.gbl>
	 <1185795198.4006.89.camel@johannes.berg> <1185797310.12159.2.camel@pegasus>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ShQI23a+pdy7X+TOUhCN"
Date: Mon, 30 Jul 2007 14:18:02 +0200
Message-Id: <1185797882.4006.95.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ShQI23a+pdy7X+TOUhCN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-07-30 at 13:08 +0100, Alfredo Matos wrote:

> What about atheros dadwifi [1] and openHAL [2] ? Could this help ?

Not entirely sure, but I very much doubt they do backoff in software.
Similary to bcm43xx, I expect they set the backoff parameters from the
driver but the actual algorithm will be implemented in hardware or
firmware. But I really don't know. I guess you can check out the code
and go through it.

johannes

--=-ShQI23a+pdy7X+TOUhCN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGrdb6/ETPhpq3jKURAg/dAJ9P78Q/9xmPcp2zBNyV+171gNb/HACfeq7C
qN0mqRNeMa4fT6V6ofk6ytw=
=v4I8
-----END PGP SIGNATURE-----

--=-ShQI23a+pdy7X+TOUhCN--


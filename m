Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57472 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbXIZHaw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 03:30:52 -0400
Subject: Re: AW: API to regulatory control (1)
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <696484.11170.qm@web51403.mail.re2.yahoo.com>
References: <696484.11170.qm@web51403.mail.re2.yahoo.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yHRXoC/wPdFQoVSd8++R"
Date: Wed, 26 Sep 2007 09:32:08 +0200
Message-Id: <1190791928.18521.346.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yHRXoC/wPdFQoVSd8++R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-26 at 00:25 -0700, Joerg Pommnitz wrote:

> No reason to get testy. I thought this was about a design and I wanted to=
 point
> out that the assumption, that the regulatory settings are global to all i=
nterfaces
> in one machine might not apply in all cases.

Sorry. It is about design, but it seems we've got far too much on our
hands with it already, and I'm not sure I want to spend a lot of effort
on this special case that likely interests nobody but you.

That said, maybe it'll be clear to you what type of restrictions are
actually needed per-device once we've got the API figured out. I'm not
convinced that you really need different API, if you're using stock
hardware you can't increase TX power by much anyway so you have to use
amplifiers and special antennas, no? And I guess that in the "debug"
regulatory that Luis added there are basically no restrictions and
you're on your own.

johannes

--=-yHRXoC/wPdFQoVSd8++R
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD4DBQBG+gr4/ETPhpq3jKURAltnAKCCRcfo5RYvR1jSiMZ7n+m03yt/pwCY3XRl
zhwlCxmSR3s/vE7LOR31PQ==
=qStL
-----END PGP SIGNATURE-----

--=-yHRXoC/wPdFQoVSd8++R--


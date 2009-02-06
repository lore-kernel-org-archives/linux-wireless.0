Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52309 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbZBFVLZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 16:11:25 -0500
Subject: Re: [PATCH] mac80211: Remove TSF atomic requirement from the
	documentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Alina Friedrichsen <x-alina@gmx.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <87ocxfp937.fsf@litku.valot.fi> (sfid-20090206_220815_144086_DD693107)
References: <20090205165834.63840@gmx.net> <87fxirpe1q.fsf@litku.valot.fi>
	 <1233953047.4175.27.camel@johannes.local>  <87ocxfp937.fsf@litku.valot.fi>
	 (sfid-20090206_220815_144086_DD693107)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LzDT3VCxCtwrO4fXqHil"
Date: Fri, 06 Feb 2009 22:11:20 +0100
Message-Id: <1233954680.4175.36.camel@johannes.local> (sfid-20090206_221129_062795_322845E5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LzDT3VCxCtwrO4fXqHil
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-06 at 23:08 +0200, Kalle Valo wrote:

> Alina, it would be nice to explicitly mention that the function can
> sleep. Otherwise driver authors need to guess if sleeping is allowed
> or not.

That's a larger project to actually annotate all of them either way ;) I
think we only mention atomicity requirements right now.

johannes

--=-LzDT3VCxCtwrO4fXqHil
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJjKdxAAoJEKVg1VMiehFYtxYP/Rwlydw1Y6XgYeNiOGj5Fh+0
IU8uc7qBfV1bMY6keYak57NsQx8I9niKGWfpc1On1eJZtPfDjtEmMM3sK42aDsK2
eUesXaSribhro8ilCTaxjnSwfT3EOMfc5AOmVmaSbs4tiI985IF2UmjvpR26k51c
PoWybjNeJQez/ahpHqpXATwSd/Heh/3dHY7qJ7PbA214/D8+Gjt1vyPV+N8Z6SPu
jRbV2C2mpwdyTRL283IE3rOayiXfE3QIJpdPiolZnfSyoT4PninKp+/IleEGo04Q
gd2PUsPKtOErXqzT/MEIk+C7a9NT4uwyd0Kl+WDcWoVvow4+dNcaMJ9YXrplT3QQ
9N8s39d37pP7Q061B+ZMcKWp/5m4MkF6PnMKl+mLXjSMZ6bp4MKw6ZS5xTWRQuHJ
jSKUWSwJ4wxvy060nPDzP5A3HJIMZhbALm9AfxytzJZtai5dX8P4LdHpXkn6eEYC
HsyM8eyAEdlYswJEbTdLgs4En2wlkfGKdD2CLa82OD7AN3CGNcd0bDJGRBVZmTrh
0ShawBtRyxD0m3GPhRJ43n4uxZBgDbSJiEQrWigW0nMPDH6qZupEcriuGJdf5kyX
Rk/o6Fq1Euz+Q48/GVrp9k7e3V0idz4px5dBad9S6dVILt370yWXjGWztCewZMWG
VSgxfMpQW8s8/zFekW8B
=GaAI
-----END PGP SIGNATURE-----

--=-LzDT3VCxCtwrO4fXqHil--


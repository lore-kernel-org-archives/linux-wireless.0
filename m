Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33356 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbYCZMvm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 08:51:42 -0400
Subject: Re: [PATCH] mac80211: silently accept deletion of non-existant key
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
In-Reply-To: <20080325173628.GA3026@tuxdriver.com>
References: <1206459795-18167-1-git-send-email-linville@tuxdriver.com>
	 <1206462125.16475.303.camel@johannes.berg>
	 <20080325163751.GA19318@tuxdriver.com> <200803251812.45916.mb@bu3sch.de>
	 <20080325173628.GA3026@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-G2nsYTjilg1Iee0y4gpI"
Date: Wed, 26 Mar 2008 13:47:54 +0100
Message-Id: <1206535674.16475.314.camel@johannes.berg> (sfid-20080326_125145_840333_3969D94C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-G2nsYTjilg1Iee0y4gpI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> FWIW, the iwconfig semantic is "disabling encryption", not "deleting
> the key".  Disabling encryption that is already disabled should be
> treated as a no-op, not as an error.

I wish semantics were actually documented ;) I guess you can see it that
way, feel free to apply the patch based on that.

johannes

--=-G2nsYTjilg1Iee0y4gpI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+pF+aVg1VMiehFYAQKyORAAtP1fjztIeHQJrWGi1FRGTQ6J0FTixKEp
6Z10sR793hM7LNpDZZhxBAvYS5tjPkNIx370sdqriHPL0OiyP0KY02mnMzmgmuef
t5F3JWYmsq2Mien+6uPL2Sc3/438F/qgkuRmw8X54yVTiIa2d/UWeMo1yG+asO1L
WS9rb0ayMt0t6285+ADY4anD8wI9kNnZIFmFKaWXAZA4wEuZ7KoXw6JlWFyceIop
HF1YNo6IZHE7LDQwYFY4CnrPptVXROMDkeazPzS8wh1eOh19nH1YoIr1bCcZ89TO
iHvszyLHnF4nl6AmHNr6Wd8yl4kxhH8k6ut44b2t/zF9o1eKROg28g7tpLJlalWl
VOwX4FrJV3ZHwYyBFZUZCmBOFYn2kp89r1SO7S76o92GLE6fQO5M5WYPmKR90ZCz
CktHaUgotvLsiV0uQVfxGKox1T3FHCPKIXnwMpNQc3hhQ/sY42p8plTXJ5tnLji4
kOC59udnVCD4qH4ZC6QyuMMXCKNsLsGaUr/IInUeiASr/+yeAkso/5HscCE5lBSr
kGxKp0J7dHQZW8CjAoM6Gc8IgaoYAUKPwhHvxILduF26+orybtXizwLOFh6CU7TS
rd5WBX5bMN81lEBUKhhK+GKdJ45o6xHwlmMp0YcJBNnq3SucxOFjyd2n7UyfhTZY
lkuHsBzdTDY=
=VHd2
-----END PGP SIGNATURE-----

--=-G2nsYTjilg1Iee0y4gpI--


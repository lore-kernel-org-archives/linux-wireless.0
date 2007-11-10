Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56156 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbXKJVdP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Nov 2007 16:33:15 -0500
Subject: Re: [RFC] b43: multiple MAC addresses support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <1194659639.7258.20.camel@johannes.berg> (sfid-20071110_015245_812007_C5FEDBB5)
References: <1194572631.4793.64.camel@johannes.berg>
	 (sfid-20071109_120958_259609_BC4A521E)  <1194659639.7258.20.camel@johannes.berg>
	 (sfid-20071110_015245_812007_C5FEDBB5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-O9Mgho0+c2UKwWi+WRlo"
Date: Sat, 10 Nov 2007 22:34:34 +0100
Message-Id: <1194730474.27854.6.camel@johannes.berg> (sfid-20071110_213321_606373_A05F7250)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-O9Mgho0+c2UKwWi+WRlo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> http://git.sipsolutions.net/bcom-ucode.git
>=20
> Requires patched bcm43xx-asm and bcm43xx-dasm so you won't be happy
> until Michael does similar changes, I've sent them to him in private
> mail.

And he has committed them. Grab my script above,
http://git.bu3sch.de/git/bcm43xx-asm.git and let me know the test
results ;)

johannes

--=-O9Mgho0+c2UKwWi+WRlo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzYj6KVg1VMiehFYAQJK4w/+O9xXpoZu0toNjknuOQjBno8wfeDjSlU2
DINkuJELi7idyTVycRWy2HqvfoACx+xg0v01DhpG7ttM0DbKlX8f3bfSIDpd0gw0
Tyao4hvI6U7V6+7A6TieZsyTGKZzb/adLZvyV1RYsWk+y7sFYwOorQrOnPj17zyl
Hcqa+wqtDf/HAChWjFJe0bAKKChcPviiLOYhhu4aNWHtWz/SFm+hFWiMpY09Vgvu
GRnpKaJmE/FLsYxsedJ8aGxGbfEBjYylfa8+EU4QdYgArg1fKXhbrNCZLwv2Cdzq
xq8uHXRvw8V3qsiGnO/4n37fkDFj8gmiMcgpIunXD6ZrXQQIIvmffeyXa7VvIUJ9
E+mLMiKZQlOgqRlPz510iHnrwadRrfHYESTvNS3LEDTm5g1p19b2XpOoz1j2JOmi
rC1/yQhb9W5w5Ys83JMPmobPxyyDf3V/Lvhm/s5djpLMezmeO2UnTt0fzS3rptym
3uLTyc7/FLxZBE6mR7cuPTVJKdoKEctlmB7cAQpEBGeQgpaBv2pNMDu74sOOYAEa
AEFZYu2rFT/XoZ7fbxj0/g3HgVKR4Vi61s9FVoVQ4aat8d3ZLHPgVGHUacTervhm
bJBuMZWg0lLZjoRyEI579AhdgKvbGmUS1aeiGe56/WX3F4ACaZEY0ef4sBS/LVQv
awzDNDDDmSI=
=7mmK
-----END PGP SIGNATURE-----

--=-O9Mgho0+c2UKwWi+WRlo--


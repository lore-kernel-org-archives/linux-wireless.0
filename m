Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52163 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030744AbXCHWWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 17:22:08 -0500
Subject: Re: wireless extensions vs. 64-bit architectures
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: Jouni Malinen <jkm@devicescape.com>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
	Jeff Garzik <jgarzik@pobox.com>, Dan Williams <dcbw@redhat.com>
In-Reply-To: <20070308221128.GA24884@bougret.hpl.hp.com>
References: <1173144447.15891.93.camel@johannes.berg>
	 <20070306171316.GA19669@bougret.hpl.hp.com>
	 <200703061943.07350.mb@bu3sch.de>
	 <20070307020310.GA20466@bougret.hpl.hp.com>
	 <1173364747.14001.7.camel@johannes.berg>
	 <20070308184954.GA24485@bougret.hpl.hp.com>
	 <1173382042.3248.63.camel@johannes.berg>
	 <20070308193412.GG23040@devicescape.com>
	 <1173382802.3248.68.camel@johannes.berg>
	 <20070308221128.GA24884@bougret.hpl.hp.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gRVbqpQMitVO9qXu6ELY"
Date: Thu, 08 Mar 2007 23:22:06 +0100
Message-Id: <1173392526.3831.12.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gRVbqpQMitVO9qXu6ELY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-08 at 14:11 -0800, Jean Tourrilhes wrote:

> 	This is exactly what I was pointing out earlier. Well,
> actually, there may be ways of fixing it in the kernel, but that would
> be real ugly, and I don't want to go there.

Yeah, it would be extremely ugly and involve a lot of copying around
when the app actually receives the data.

> 	I've just released wireless_tools.29.pre15.tar.gz. This is
> supposed to include a "band-aid" for that problem. To the best of my
> knowledge, it should catch the problem and not introduce false
> positive. I would be glad if you guys would have a quick look into it,
> because obviously I can't test it.

I looked at the diff between pre14 and pre15 but have to admit that I
don't understand the code change. Unfortunately I can't test this until
the 20th earliest so it'd be good if someone else could test this.

Btw, could you look at the information leak patch I posted? We really
need to get that fix (or another appropriate one) out asap.

johannes

--=-gRVbqpQMitVO9qXu6ELY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF8IyO/ETPhpq3jKURAmY+AJ4kBibiCUqvIm+bStJ3epwJR/tX0ACgnO0Z
TwFT8NV/WroevycvVw8dMOU=
=Cr0E
-----END PGP SIGNATURE-----

--=-gRVbqpQMitVO9qXu6ELY--


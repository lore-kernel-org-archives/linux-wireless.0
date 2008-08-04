Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45530 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbYHDQkb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 12:40:31 -0400
Subject: Re: [RFC] cfg80211: add PM hooks
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217867815.1299.13.camel@johannes.berg> (sfid-20080804_183740_875620_7179922F)
References: <1217853236.4721.32.camel@johannes.berg>
	 <99AFB2EC-AECE-419A-B014-8391E45DF6C4@holtmann.org>
	 <1217866765.1299.9.camel@johannes.berg>
	 <6064CD72-8B4A-4F23-BCFA-4D656729E60D@holtmann.org>
	 <1217867815.1299.13.camel@johannes.berg>
	 (sfid-20080804_183740_875620_7179922F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FTfU0dWV9PUZuIFa4hlp"
Date: Mon, 04 Aug 2008 18:39:54 +0200
Message-Id: <1217867994.1299.15.camel@johannes.berg> (sfid-20080804_184034_662420_2FEF60DB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FTfU0dWV9PUZuIFa4hlp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> The more interesting question I guess is: are we now required to have
> these callbacks even if CONFIG_PM(_SLEEP) is not defined? I'm not all
> that interested in trying to find answers right now though.

In fact, I don't even want this patch merged. I just think that it'd be
the right approach for anyone trying to implement suspend/resume support
for mac80211.

johannes

--=-FTfU0dWV9PUZuIFa4hlp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIlzDWAAoJEKVg1VMiehFYeM8QAJApH3tEydJLjBCzjIwDeHuZ
KqwLCGnlqYLV6PTjBk1j4lez3c+OEYmB/0IFyT1aQyGOqi0XoFU8WFuzRnH/Hy9n
zZa6ZzvHaTmRbiwXT9HhzQVGQis82jcjXbZVLFlGzCZWX70WR6TwzUcquM5pEdq7
J2eM0clcpv7TquEgtzagIpxQyrWHmxIWuxPIWv86HJCz/05kvQ9DW1WEMQiEHUww
6DmnoWPwqXQsW4/7drJKihZX5pwTH1qpMyw73MwpgrwBiI4+wBlzIWB9Wdv0wu+R
q7RiXjXQMbk0DqMV+iXie8XXHQHEchdVw+aW+wp3Ur7JkxBvHDsfnvRZDUskSLVn
0C1u+HV/bJZjnB2uFIvA2GcG7XfvCG74K+njmNJOZPIFGxB4RdfkquOlu2/nyKVb
mLecJz7L54hvdwDebFcBrDX+I+DS2Y3NjTCP7ub5IVAmj1oVSpalMB1kPjbt31qk
CSeFNWhq2/1S0EJDxgfYwDxDw9goOZeqFaeetFX20x9pypOB9fPFOqAU5koO/7Gd
/LMJ6PsyhhIXRHcR2YtuAVeegjc97FDFAtgte6REdL9u+fK8ElguVlQp7oEAnjy0
TkLgqI8+NKDFLChKc1+7uRWD6iK+0GJ9jw+NtXH/xAkrfWTbwAfXP1SnNqvy+Exa
3ZOEEezvd9C7CpnXp0I8
=qRkl
-----END PGP SIGNATURE-----

--=-FTfU0dWV9PUZuIFa4hlp--


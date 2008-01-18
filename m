Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55909 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419AbYARMhy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 07:37:54 -0500
Subject: Re: [RFC PATCH 03/12 v2] mac80211: A-MPDU Tx adding basic
	functionality
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1200508864774-git-send-email-ron.rindjunsky@intel.com>
References: <1200508860699-git-send-email-ron.rindjunsky@intel.com>
	 <1200508864774-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dutnPpuq2iR1ujKO6iSw"
Date: Fri, 18 Jan 2008 01:49:03 +0100
Message-Id: <1200617343.5716.15.camel@johannes.berg> (sfid-20080118_123759_104644_80288CC6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dutnPpuq2iR1ujKO6iSw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	ret =3D ieee80211_ht_agg_queue_add(local, sta, tid);

Not going to compile since you haven't added that function yet... You
should at least already have no stubs and later move them into the
#ifndef QoS section.

[...]

Hmm. Now I forgot what else I wanted to say. I'll try to review the
patches in more detail but TBH I still haven't understood the qdisc
stuff. Well, that's not really a blocker I guess, you just need to stick
around to help me with it in the future ;)

johannes

--=-dutnPpuq2iR1ujKO6iSw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4/3fqVg1VMiehFYAQJuDA//Y3D0McbVQuEoA4GDGfRUtEuw3MWyM+uV
cnL+n5aWhlPqTbqIBZxJJiqrbmpbeZ3+WRWUXt3NJrANXV5ipWpZ0GG2Rn8nryrs
1DUAnAX4tvJnIpDluS+yKV8IQVzy+/K9GvLx6GC3KkLAfNm+ZhIjwWSLpS8mcJ1h
fcZZPXOPESJXcrdFuLxd1abxclAfEjDEaRHMVSoOKEysY9WghICKqEHwt+lpyBg5
FJOn2G1s9j7P1Z6kmhgRjgItraC1Ay5bb0vjkfqmIEfGby4nsFBbZuqFvEHYSBGO
xAsc0jRDtvyrEbPC9ONvbaVlkvz6cKZCQVT6tYgt1EVi6znG1XeA6ziqlbE62r3Z
BL8Pi3S37QEfjkqf0oEEp/4p3cX33AkHv2HQ7gIHWHIxSop5hsjEbeQMfsXvwbpk
6J4tQBP3uVkt/2hw18DUlbrKVf47XySa4xReEUv8HfSW5n3tXQkgbHZz/yA/iCLc
drIkyFcO/uZnDvvpoKI/HgXp1TkG5YAm4qkz/ulRhT/6PXZWhPbHhrlm8msTkjBX
7+oEp72yBpOl77xHr1RQBv8OptF41lK5TVi6Y6kABxBLlXX8aP0czueoeWdY3dvj
iUaAzuKf1KxqwBznG4fbc9wHz3XylftbXxRPpqpazeSN1IrcHty7j4LZkYp2L9vF
MqHlm016vZM=
=MV+q
-----END PGP SIGNATURE-----

--=-dutnPpuq2iR1ujKO6iSw--


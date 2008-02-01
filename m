Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35035 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbYBAMrL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 07:47:11 -0500
Subject: Re: [PATCH 1/1] ath5k: Cleanup after API changes patch
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, bruno@thinktube.com,
	jirislaby@gmail.com, mickflemm@gmail.com
In-Reply-To: <43e72e890802010441n4770fe0ag69899a537f551080@mail.gmail.com> (sfid-20080201_124142_517727_E44AB445)
References: <20080201012544.GD28995@ruslug.rutgers.edu>
	 <1201869496.4188.15.camel@johannes.berg>
	 <43e72e890802010441n4770fe0ag69899a537f551080@mail.gmail.com>
	 (sfid-20080201_124142_517727_E44AB445)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-veTerMpibT703di2e5mc"
Date: Fri, 01 Feb 2008 13:46:10 +0100
Message-Id: <1201869970.4188.24.camel@johannes.berg> (sfid-20080201_124716_799750_C7B18587)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-veTerMpibT703di2e5mc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > What is cap_range and why should it be in struct wiphy?
>=20
> Its the device's frequency capability range on the bands.

Well since we always need channels I decided to not have such a thing
but rather require registering a channels array that is also used for
bookkeeping about enabled/disabled channels etc.

I guess you could add a helper function that allocates a channels array
based on a frequency range.

johannes

--=-veTerMpibT703di2e5mc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6MUkaVg1VMiehFYAQJx3xAAs929SEr4z5fiqrC7aVBNQ2tqdntJVjQ3
CiCAAf9jlnu2/tLOyNsTWJPBfw3AId/eHZ/K7YOMAfKn+s+QafOLxwry13LzhaB2
WApTm7Ou4j69yBFIYBGs0hujrSfTnAFPmquwZZBn2r6NLgSNtJDBgbvt0IVglnyZ
AOg9EWT5DcF0HSLlnLFsTITFkptqmDJB+L/2c0m4j5XWpUaVt/wLAqBSjIKPtCLl
4Du/++DWwIViHwkkV3WLHJVChlJhZ8bQNycyawikbS6RNMq6QsBXtL+Qsk9sAyjQ
Cid9AYqKWxli+SpoAEzGaLMromPTQkB/kjHwiYKlaGalMiUZZRRZpGbjKe4lKOmp
VHtqbkVBcYRt5ShWJfHou5/ff+RYbBSzsR+rjk2IPW1MB4iBPD3DmWnJPrWXkREF
E9mjl82LWGYBCjzM23+lScv+SR8yPJqBpAl9+ZyznAMhz/gmwfoR/v/ISmWehE3y
x6NdjSqIxTP06xu7IG66hJgEhKnNTwfMTA/fnE159Yd/b7LYCpNjoIg9wPcDyTxX
Lxv/2dx5HtT+IlUlCCT+BIDik+xpM6kTb/9exPVPZH/0175E0GTVxa2b7+kI3UvI
lDajCSBzh5VV1CzHQt9WcHSFdvXuxxwDNQtl+i7aFoz8czGQsiorATDtwK/Jjp3L
4rOKBaK3ScE=
=KJ/1
-----END PGP SIGNATURE-----

--=-veTerMpibT703di2e5mc--


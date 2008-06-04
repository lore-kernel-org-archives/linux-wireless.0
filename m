Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38421 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760AbYFDPmu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 11:42:50 -0400
Subject: Re: mac80211 ad-hoc mode problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <1212589104.13676.17.camel@localhost.localdomain>
References: <1212543664.4237.14.camel@localhost.localdomain>
	 <1212570001.14371.16.camel@johannes.berg>  <20080604091656.GE580@jm.kir.nu>
	 <1212589104.13676.17.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Gdnn7mwOcdSduqogVk4U"
Date: Wed, 04 Jun 2008 17:41:45 +0200
Message-Id: <1212594106.14371.32.camel@johannes.berg> (sfid-20080604_174253_405816_FD8A8C3A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Gdnn7mwOcdSduqogVk4U
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Can't remember.. The only thing I can come up with is that 20 was the
> > next round number that is larger than IEEE80211_SCAN_INTERVAL_SLOW
> > defined on the previous line.. ;-) Anyway, I don't see why we would nee=
d
> > to wait that long. It should be enough to wait for a full scan of all
> > channels to be completed. It is of course nicer to avoid creating a new
> > IBSS if there is an existing one, but as long as merging works, it
> > should be fine to reduce this timeout.
>=20
> Ok, I'll drop it down to 5 seconds if that's OK with you.  That's still
> the same amount of time as the wpa_supplicant assoc_failed auth timeout
> in wpa_supplicant_associate() though, so they could still step on each
> other.  Not quite sure what to do about that except bump up the
> wpa_supplicant assoc_failed timeout by a few more seconds?

Fine with me either way. Like I said, I don't really care too much about
IBSS and appreciate the time you're investing to make it work.

johannes

--=-Gdnn7mwOcdSduqogVk4U
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEa3uKVg1VMiehFYAQI8HA/+Ndy7To/dboU5xIRqOjFaLHbWl6s3BPS1
kUcw4JFutav/K7yY+78q+DAsIqVxqmlBIp4+gdkkN1Q/rX+wtqvhiUEAUWML4XJi
A4fnHJAHXTeixGzPDe6b9j5vVWGXZcWMPZdkhYa6LSJENFTkDaIsh3WBOKvSM6ta
ymqfq6RI7aW87mfU8fz9SFF4O8x1C0PzTqapAUS5cqQMJY61TSssmkrUzICEf4+O
ytXsBh71q8hWwDHLeEHa16N8S4MsyyTJEaPwyHPiG8jsss2UEbtEM5/HiU9yiUYr
9rWm6jPhPKPTv/LLnDe0xov8xmmLgy4kNOLL/AjbhVMxz/BM5Oz03l5n2UmmrTUC
tG+4NS4pFVundqZx51eC6FIh/6ckUTSJy1A0UbwN7qWCF8B2foUuyAEhTxmIBQaM
WSBDeq8ggBK9uTKZce7SQCN3OhW01jHyhwlVIZtPgTkmVvklXpRX6lWNKdV/emWQ
SsxBaQNUxmBaSx6LsqOXYJ7/ej0gVyDlYZIHVUQ8D7S/YcDfRSELWJ+sX7m5xqb9
Ncbs9VhWGONyKWvIr41tdKoJhbacMdD0wN7R2gSJ2l31I9Od3tjJp0kS6CjhLu2J
Z/OuThc423eBjUyiDmUfZqFHQ/+3KpssMjMYOVouy9rJbtKb2SPlmVXSSZgv44/l
vN48O7/OHTk=
=ylNy
-----END PGP SIGNATURE-----

--=-Gdnn7mwOcdSduqogVk4U--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43977 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419AbXKWMQj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 07:16:39 -0500
Subject: Re: mac80211 regression: doesn't associate automatically
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200711221658.02233.hs4233@mail.mn-solutions.de>
References: <200711220912.10452.hs4233@mail.mn-solutions.de>
	 <1195746110.4149.23.camel@johannes.berg>
	 <1195746399.4149.26.camel@johannes.berg>
	 <200711221658.02233.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DNMrNOrrj4v/2Ls/t5QG"
Date: Fri, 23 Nov 2007 13:15:40 +0100
Message-Id: <1195820140.4149.106.camel@johannes.berg> (sfid-20071123_121650_303831_A5AE2376)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DNMrNOrrj4v/2Ls/t5QG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > In fact, the *ONLY* think wext defines (via iwconfig's man
> > page) is that setting an AP mac address forces association.
> > Everything else is being nice. Hence, to be absolutely
> > compatible you should *always* issue "iwconfig <dev> ap any"
> > after setting configuration.
>=20
> What you describe is the law, but not the life. Get a grip. It=20
> starts to be comical.
>=20
> In real life, "iwconfig XXX AP YYY" is VERY seldom used. For a=20
> start, it would disable roaming.

Nope. My command line said "any" for a reason.

joahnnes

--=-DNMrNOrrj4v/2Ls/t5QG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0bEa6Vg1VMiehFYAQL5ww/8DZ0s+xqVW3M8JGW5wAF7KoARHx4iI6VN
FjuxMoQbJcpDmd52C57LECfv6Kjr5VD3iRvd+Z/4kgqKgFTudOv+BuzcnHtfJ0KD
LmvidsBwmCOOsICkjgJaY5r9ZAJWpZuQUIwAyiljDw7dEROVdIWI50zon8uEGyGU
PQ2x065KaSIVu52d51BAoGkOhTlB7wdX/yA2O7n5SSbNPamswgWagYSGcRVAahB1
sALbWiBHzzHkztgiF8AKhIUoxNYOqJg75MwBmT8oIOy/5s1RG9PQq7rxkdGzU8dV
hscyIxJkKoc7hnEhcvu3TAyfCtcU4SVlYUROBbKnVzCSGVu0tLGbjJI1kekzGEQX
uA2cJy3aQg0HmpO1AMOFgX358RezB7hMPdi0nTmkOZnZO4CHamQgTqCGcsGCWsUe
cRyI1B6z4Ab8KgBh2ZH3W7GHy3Jx17/HohVQSBgL8KfwrCfqAq8ikdyfwp9Qp63W
eh0z3lTdm4I7F61YdsrHuXV44geJaap/i/7K2ZpUEK30j2x2xTMCtUUo6QcK7U4h
4e1AGEjd7h2XAkqSpSZB0xjsW1SMWmhEPNAyyzUDR2cda/RMJpfRP8RIuG5jq2dJ
PF5AiWzLM9oVaE1yC+e6V1FkcwA23wqXkvqBnRaCrhd4gbi3zJL+LnoeZrsQxmz2
qYxijzdFYuc=
=IBBm
-----END PGP SIGNATURE-----

--=-DNMrNOrrj4v/2Ls/t5QG--


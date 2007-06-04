Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43458 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbXFDMGf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2007 08:06:35 -0400
Subject: Re: AW: Drivers that do not honor regulatory restrictions
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <297494.10588.qm@web51404.mail.re2.yahoo.com>
References: <297494.10588.qm@web51404.mail.re2.yahoo.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-owRjNkVragfz7SZ8hXB/"
Date: Mon, 04 Jun 2007 14:06:56 +0200
Message-Id: <1180958816.11026.72.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-owRjNkVragfz7SZ8hXB/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-06-04 at 05:03 -0700, Joerg Pommnitz wrote:

> Actually it was mac80211.
[...]

Oh, ok.

> BTW: ieee80211_ioctl_set_regulatory_domain changes
> conf->regulatory_domain, but this seems not to change the selected
> frequency table (that one is selected solely based on the module
> parameter "ieee80211_regdom". Why are there two places to store the
> regdomain (that seem to be used from different places)?

Honestly, I have no clue. I've never even tried to understand the
regulatory domain code in mac80211.

johannes

--=-owRjNkVragfz7SZ8hXB/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGZABg/ETPhpq3jKURAkDqAJ9y5uwuaLqgGh7P8imSIOWLQytlegCfQbuJ
KUYX0VplbWmJ015EXqESejI=
=ddkd
-----END PGP SIGNATURE-----

--=-owRjNkVragfz7SZ8hXB/--


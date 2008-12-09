Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47520 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbYLIKYx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 05:24:53 -0500
Subject: Re: [RFC v2] mac80211: Fix HT channel selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	jouni.malinen@atheros.com, lrodriguez@atheros.com,
	tomas.winkler@intel.com
In-Reply-To: <18750.13163.213759.181839@localhost.localdomain> (sfid-20081209_100146_066280_ECCEC8C9)
References: <18750.13163.213759.181839@localhost.localdomain>
	 (sfid-20081209_100146_066280_ECCEC8C9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UoI+qoHXnfuDVAJqNvUM"
Date: Tue, 09 Dec 2008 11:24:17 +0100
Message-Id: <1228818258.22164.178.camel@johannes.berg> (sfid-20081209_112455_725383_E084BBF4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UoI+qoHXnfuDVAJqNvUM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-09 at 14:29 +0530, Sujith wrote:
> HT management is done differently for AP and STA modes, unify
> to just the ->config() callback since HT is fundamentally a
> PHY property and cannot be per-BSS.
>=20
> Rename enum nl80211_sec_chan_offset as nl80211_channel_type to denote
> the channel type ( NO_HT, HT20, HT40+, HT40- ).

Thanks, also for rebasing to the current tree. For all I care, we can
apply this, but should maybe test on Intel hw?

johannes

--=-UoI+qoHXnfuDVAJqNvUM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPkdMAAoJEKVg1VMiehFYdIUP/0+QPGByHaXsclmwAHyRZy3t
NN2r2zGoypibrdkHKOC+U7vZj4x2a6lqoyYdzdyzT11oJuCKCP3dlxdlslbx+YYF
4FMAh8rMZJWhvhXE0kqzuwrVoYciLnCnoTlqv6ck/fpLXOOnPF8l7nlp6NAVZE0L
Vmz5Vyz42kU3VYuGqFQgvmyJ0F8MOuBEs9OMX+o9vRFYwryD59fsAAMGolVFHMuZ
DwIaYKRhpAi8PX0rocXeOFqCDvaxvA58lciVygqxefq9oE7lhpfJHsq/HvvLPjf6
jVWHZsOA9Ke5Vs9UQXlgHRNamISIgKVP2WmofSeK6rCM0d5U0DuEbBtVfsx+GjZ7
qIsUeYjX8JIMBQEdz+oh5RwtPNpYwZ7GIuO250a5R8knNG4PgZK+0XZo9TCHJhl3
I5oDCc5uZp6q8twtx0rCtshDhyNuei4hNkd7rNH1k/tD9JcThetZCn1ZtxaR2bGO
c5Bt3LwkgSfSt+9TUn4Qgz8TyU8ZcqPelK/Uj5ubGGeVpVqDYcGYJXAdlXb7vMyf
S26aJTDo79K053Kk6CiExNakPsPInyfWYWgTBh3+ZOBlR3doJ5O9Rx8wC6gOjLjW
123NJSr+WqH3jZv3jy2/VcAM8nZXLs95M+QFOq+A9ZOir2WQeCyr7v11fCPQU/rH
Rdmgu4x0jRgt1ascWyW0
=kiKt
-----END PGP SIGNATURE-----

--=-UoI+qoHXnfuDVAJqNvUM--


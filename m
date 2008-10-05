Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53553 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbYJEIio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2008 04:38:44 -0400
Subject: Re: Infinite loop in sta_info_debugfs_add_work().
From: Johannes Berg <johannes@sipsolutions.net>
To: Robin Holt <holt@sgi.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <20081005023143.GJ8534@sgi.com>
References: <20081004103144.GI8534@sgi.com>
	 <1223165956.24551.76.camel@johannes.berg>  <20081005023143.GJ8534@sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9LV1kJFh3nRhvJ8Wf2JY"
Date: Sun, 05 Oct 2008 10:38:41 +0200
Message-Id: <1223195921.24551.79.camel@johannes.berg> (sfid-20081005_103929_421441_3920CD82)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9LV1kJFh3nRhvJ8Wf2JY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-10-04 at 21:31 -0500, Robin Holt wrote:
>=20
> Will try it.  To reproduce, suspend, wait 5 or so minutes, resume,
> repeat until your keyboard leds stop flashing (usually within 3 or so
> cycles).  I think this will kick us out of the loop.

Thanks; I cannot reproduce so far and I suspend pretty much all the
time.

> As for not configured correctly, I just took the standard Ubuntu config
> and answered the unconfigured items with their default settings.

Can you show me the DEBUG_FS and MAC80211 entries in your config?

johannes

--=-9LV1kJFh3nRhvJ8Wf2JY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6H0NAAoJEKVg1VMiehFYBeoP/3x/BI3wSbfmMOpnoRFtPk64
HTCxiUm/61PZKBr0dwRove1VwTX2xSFVf29TGdoXVaNuaUiNXqAZdh9s0U6LI3S0
h2hbiFgAtuKS9123A3Y80g/vE3q3QLogAiS8KylvXdhYGk1b4nkhUEL9ikXO1Fgk
T0WB9Fyg2yKbwvGjuM5wuaivYqFbK3F5JuysXYZ/h+YgUZBMiBHJNlUTC/N0Zh60
VLLpnSCwaw+2/q5s+tFFpJffg++KL9sZnCkXpubme0k8yXVj8D7X/KxI9DZRP+TT
EnMTwFDDu9NkV5q1tB2tBkQn2ZJcJ6VOPm0I5H3p+GLxwn12TnN6Y5M0gz3E5HJQ
0E1c37VKRdLix6kAvJb+TKXmaZfQUn1oVm40FZQCOFjxkWOwRRHGr2m7EVOfuif8
zqm6lptCKNQobG3XJNjtk/WU43Nv2h4znYZgaXLo/MZo4O3rY4dqwY9neAjH+hOA
ZrAt9jMzFMxN7BjueBzBmofEJlD41GNOAWS6V2qGWvzhuX547vf336VuxUOciGJ4
yX8O7k/py9ZdgoUrfntAxZGD+k4TRiTxNCu0juPHMCsrntn5CQXsev6lB040h1uk
rRmtoBlONZYcpmCaFSO0aJv2Wy/uOFf6OmmKhBWGihmmfX/W1ViX9cIp9/+bvD/F
BEsgjXWx360Bf3GEwXFA
=V2re
-----END PGP SIGNATURE-----

--=-9LV1kJFh3nRhvJ8Wf2JY--


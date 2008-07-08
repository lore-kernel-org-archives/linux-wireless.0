Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60376 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbYGHWG5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 18:06:57 -0400
Subject: Re: [PATCH 5/6] mac80211: rx.c/tx.c remove more users of
	tx/rx_data->fc
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1215553540.476.49.camel@brick> (sfid-20080708_234544_948979_2D1B0842)
References: <1215550044.476.43.camel@brick>
	 (sfid-20080708_224734_565441_65F98FD9)  <1215552534.3670.20.camel@johannes.berg>
	 <1215553540.476.49.camel@brick> (sfid-20080708_234544_948979_2D1B0842)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1vrgRYEzffxvitQNx4KF"
Date: Wed, 09 Jul 2008 00:06:08 +0200
Message-Id: <1215554768.3670.22.camel@johannes.berg> (sfid-20080709_000703_570030_AA9257F0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1vrgRYEzffxvitQNx4KF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-08 at 14:45 -0700, Harvey Harrison wrote:

> Well, I suppose I can also take another crack at getting my updated byteo=
rder
> patches in that allows cpu_to_le16, etc to be in a case statement, then t=
he
> switch could be preserved  and the byteswaps can be done at compile time.

I thought we had __constant_cpu_to_le16 or something like that for that?

johannes

--=-1vrgRYEzffxvitQNx4KF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIc+TNAAoJEKVg1VMiehFYZtsP/RhwYHpa9oVqes19AJKVDrgo
9ENPQBCvhSgytHJPPZeiDOhQ2RCH8HaSjmscGzbMFRtkTbanhNbxYBe00Lg7FUpL
hoVBpLhK8PCls0i9/Op3OEDNn3gwvk0TJWUMndf76iFkP9Ikceo4wzrIzMuNweEo
3LPjHo/8GYqmSrbez3OjrtJ5PVfBo6LcklFb99T52yf+69eaAkRxpSkpRHzBPZW5
Bff6toPol6i5bfk4++MjaIbd0l2+jwPFDkMZqpIgde79SFmwOOYfvtOHSkwSOFyy
PESrEbTUhGJFY19cd351bCIeQjRCRHX9uvSabI7FEe+LcvcBbx9sRuVEu3/VaMpc
5gv4K3TH/dbsg5Hu+dvnEKcKU0DlZYLHtHuR9CV+YCf9rVkEt5QbyDaJ8G1+DZcS
rVsSjpaWEfv2IxOhbq893r6FvIouC3LRH1RleKIC8GvKHmYHXUbeX6r6b39Zpa1v
SYgENKVIVbPfm1LpMpyVQ9Mbq9Ix+6iu+WGxEjufunvs5sg4jFUfW+vv5TEYIk0q
WGqF9FXBvVJ1JN17TJmkBvHaMh+49Kqsfy6uxO5R3ZvfObfW/C8Qn3Y9936vZ6AH
MCnYA2/bmySpReMyH+GjmAVkIF8rVV0d58iyRTBOrJsHala4LJIn5kh+kPm43fwi
Q6z6mdI3ygC1U75+qu3m
=UikK
-----END PGP SIGNATURE-----

--=-1vrgRYEzffxvitQNx4KF--


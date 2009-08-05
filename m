Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40555 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbZHEF6F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 01:58:05 -0400
Subject: Re: [PATCH 001/002] [MAC80211] Retry probe request few times
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <69e28c910908042253t67e5aa93j1db74dfe187a9bd1@mail.gmail.com>
References: <1249056817.20593.1.camel@maxim-laptop>
	 <1249056896.20593.3.camel@maxim-laptop>
	 <1249438947.3094.30.camel@localhost.localdomain>
	 <1249450153.6083.4.camel@maxim-laptop>
	 <1249450416.4168.22.camel@johannes.local>
	 <69e28c910908042250n1e0bf9c6v20b6301db9e3286b@mail.gmail.com>
	 <1249451506.6902.2.camel@johannes.local>
	 <69e28c910908042253t67e5aa93j1db74dfe187a9bd1@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Taa9X1T5A7L2hRExAM0T"
Date: Wed, 05 Aug 2009 07:58:03 +0200
Message-Id: <1249451883.6902.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Taa9X1T5A7L2hRExAM0T
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-05 at 07:53 +0200, G=C3=A1bor Stefanik wrote:

> It just feels illogical to me that the AP essentially has to respond
> to probes twice (it sends an ACK, then a probe response) - but if that
> is what the 802.11 spec calls for, then its fine.

You're just confused then. Think about it again, it's perfectly logical.

johannes

--=-Taa9X1T5A7L2hRExAM0T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKeR9oAAoJEODzc/N7+QmaAhcQAKgdu39Vtce8yUJwdJqHl04R
WgiiFowDKc5+75PuXkvtuR9GiDKWlxcEw/ws9wLLfISzMbImUppbykX/rOf+/hsi
2W5YsTQIB08WjjViug9I4qbDVT9NkeRS6kugTXEB2pwgskOkZXFXORimToQ/zDoR
1Y7uP7H4RPUujly72vfMSm0nfwnjLn6T6dZmRe1z7sbJ8PSAEBvyuZkwVUIdEBOE
pCAomAy6hOM24qj4g/8rhdiPTnB7e4mtvecDNdpmmCIb8ZqwgxDOOloMUL3FheIF
PGgBbI+/t4kixJhgT/PBFiEldmBIZ93O26tJeje29J9xxxaeMMAB03T+B9tEJfWv
5VYa9ytEHq26j84ydByFbgtnIJO0ZEQxpjO/Wj4dIZkvQeIsYBsUiXBymQEmFDd+
RqD3NwOhez4y7H3S6rzMU7jaAsVAGWc6AIpSbPfZw95rfftzNWu7lj2plSWDt5Jj
h1xkAUQpoOyEDH0oljJ42j8qH6UDeKPa58cp+LPFH3Kt+MX9gJ4YjLGK6a1X5/1A
qwaOBOS7tZhGXldPjDiET+7SowdxigZRoNpS0G5R4eY1lxiMkFa7KoZWw7DzQJmk
826/8UmgoP4SnMDey13c8KmKCuMA8doqz6oKrKHTAvNb3oJfPv0tF5OkiDh/Lf10
GKqAYjqTly4ynXfEPMj/
=x0Qr
-----END PGP SIGNATURE-----

--=-Taa9X1T5A7L2hRExAM0T--


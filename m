Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54913 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbYJFMay (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 08:30:54 -0400
Subject: Re: Crash with 2.6.27-rc6 with iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221185432.6695.0.camel@californication> (sfid-20080912_041007_653566_F8146EC3)
References: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com>
	 <1221123779.2513.88.camel@debian.sh.intel.com>
	 <1221184060.11498.3.camel@californication>
	 <1221185432.6695.0.camel@californication>
	 (sfid-20080912_041007_653566_F8146EC3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5zRwu/o7ztjVnIJioThQ"
Date: Mon, 06 Oct 2008 14:30:21 +0200
Message-Id: <1223296221.15196.6.camel@johannes.berg> (sfid-20081006_143057_986057_BC4A63C0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5zRwu/o7ztjVnIJioThQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-12 at 04:10 +0200, Marcel Holtmann wrote:

> I take this back. It took a couple of hours, but it crashed again.

Do you have 64k pages enabled? My issue goes away entirely when I
disable 64k pages.

johannes

--=-5zRwu/o7ztjVnIJioThQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6gTaAAoJEKVg1VMiehFYnKUP/AvKhQq4qkfzU8vjR1Ku3NKR
kaH1DNlhyki5DeRHyh0JAC2CgiF/MSpOS2v+qm38f0196sh6FdkJqC9mtrpPnmLq
trMn7AsnO1PZ1jfdY9N29Q0gnG9VOdfjOv1AoM9stJAfPdzZ2ltD+/IaiYIOW370
miVKpSaHjMugKE3tNpw9tMLBGFNdwJee907gevT6N2uU0UDiCAAh5rps6vfwtZWV
vEdZjtxyRyeJVOs/dNxD+qvoVQItNPdAn8g8QYv85yCFcpUMQJQ0sXCwdPS5JbkF
Hb6gX+IMe+WjPxZUXWl0+Dda1ZaydSp0WLPbRp+sGC15alvrqNormqjJt605p1r5
hqraj437/yP+5kWsx/RtkuJx0yt+6VcombZF+c64/gmgt6KxAXaPKnrDn45glVJt
DOa3783pbzpfgJ3khYAfkp2f1+M6QAzigcnaGUp0kWkx789U7EBZpG3bnKnyFY5/
0DHYlFb1ruYrsuAYrxzM+ezs3u/XBp6l9jI292c/yRf6lztP7EmNzD8TkJ2uIBzx
mXeC/QIiiweGM7tRgWehRP7Y3ZcJeNOMPqzMhvrJmZJrHv/fZdbNjyXHbEcMhZW4
yi/5HzvGDuZYq4oOXVPKqS+7PVzFjtiLI9JWpH0GAPpVX9c1UOlZgINy2MES/Ia/
c4KdJvRsbaCzN0If6WXy
=LYYh
-----END PGP SIGNATURE-----

--=-5zRwu/o7ztjVnIJioThQ--


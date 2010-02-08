Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51290 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab0BHNrv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 08:47:51 -0500
Subject: Re: [PATCH] nl80211: allow adding new station to devices in mesh
 mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
In-Reply-To: <c1545bb51002071151wb2cefa3mb03501e0d6b3fb4b@mail.gmail.com>
References: <1265331642-27773-1-git-send-email-cascardo@holoscopio.com>
	 <20100205165726.GA1496@holoscopio.com>
	 <c1545bb51002050947q707bb5ebud5ec7b4680f49ac5@mail.gmail.com>
	 <1265446793.4041.2.camel@johannes.local>
	 <c1545bb51002071151wb2cefa3mb03501e0d6b3fb4b@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qx8bIus4LTVc07RFFigE"
Date: Mon, 08 Feb 2010 10:08:09 +0100
Message-ID: <1265620089.3783.2.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qx8bIus4LTVc07RFFigE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-02-07 at 11:51 -0800, Andrey Yurovsky wrote:
> On Sat, Feb 6, 2010 at 12:59 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > I do wonder though, the commit (155cc9e4b1d60161ee53) I referenced was
> > yours, and now you're asking the same question as I am -- "why even
> > allow adding stations?"
>=20
> It was supported for automated testing and experimentation (you could
> then force certain topologies).  I can't think of any other reason to
> do it.  I suppose that the same thing goes for mpaths and the mesh
> portal tables.

So would you prefer to fix it (however we would do that, I don't think
that the patch here is correct since it leaves the station struct with
no usable rates afaict), or just disallow it?

johannes

--=-qx8bIus4LTVc07RFFigE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLb9R1AAoJEODzc/N7+QmaGLQQAMCXtloOTf/dsfOtE/pn6FnX
QS6mXh61WoRHYSE51gMXTloQKLOQr/0pXryfBTZHmYYE242F+qYM6NGp+oH9O364
GRNqgvMMEsLB239w4xLqTl/yFd+cpgxmg+j5dJyXu73oBdvBhBbVmdNBHQA/kCky
FglCVrspJwKe4QNAzYEqqThpYvNnhqNOrX9JiVGbqrqKLIjZwLo8BaJ9AiREJ23J
ARRO4Kjkdx2kln0btfaJVXP8OzQMTbBW5b69PmqTWMQmz3D0dkYEoBecoZeeUjJZ
lUPYX50kEoDcWxNcmmhM0OwQX6nhZsDtYhCm4pAYuXsG1/JpaGqWJHRR4DIAtVrK
8ZovXNnIDFECr+ISNkm8g7tApFBrkNs1B9XO3ua45VuaipeQPO+68OZv27wkmqlD
iu6cGF9Jt+XzMYx8Gpv8sYC9TCrS4ei1RwcclmE35QhoZWuU3XSgqiw7Jp7anPjr
KFiKp/qB7tgdsgNMYPQJd/Kq0MWvwpDXx4vucjwkXADmMAwE105KS3CTTz9EkGeV
tiUDojxybOGYz9drG5bKJHqO9R4E3ue0RgoJYe9QhBCMkzuZXE6cDw6Rcqsk7T/6
sp1opHt6sJa9AtUr9neAcB5i/ul1Ta+KdJXBQH81CeaApN3gx1Z90oUZA2T+TW6i
TGFu6aWimQMRYmoDkIQ4
=LKRZ
-----END PGP SIGNATURE-----

--=-qx8bIus4LTVc07RFFigE--


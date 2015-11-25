Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38004 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbbKYI1X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 03:27:23 -0500
Received: by wmec201 with SMTP id c201so59454496wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Nov 2015 00:27:22 -0800 (PST)
From: Sven Eckelmann <sven@open-mesh.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iw: add VHT80 support for 802.11s
Date: Wed, 25 Nov 2015 09:27:20 +0100
Message-ID: <1665268.sMoWlW2lMO@bentobox> (sfid-20151125_092728_586759_D0C3ABC9)
In-Reply-To: <CAGRGNgUzFuK=r4HTtC0VkBc-5rLEHA99GB3VuyA6T7Ch6nr2kw@mail.gmail.com>
References: <1448386927-25170-1-git-send-email-sven@open-mesh.com> <CAGRGNgUzFuK=r4HTtC0VkBc-5rLEHA99GB3VuyA6T7Ch6nr2kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1574987.x3xfMY8n79"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1574987.x3xfMY8n79
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Wednesday 25 November 2015 08:42:44 Julian Calaby wrote:
> > -COMMAND(mesh, join, "<mesh ID> [[freq <freq in MHz> <HT20|HT40+|HT40-|NOHT>]"
> > +COMMAND(mesh, join, "<mesh ID> [[freq <freq in MHz> <HT20|HT40+|HT40-|NOHT|80MHz>]"
> 
> Should NOHT remain last in the list?

This would be inconsistent. ibss join also has 80MHz as the last entry
in the usage text and NOHT is the entry after "HT20|HT40+|HT40-".

Kind regards,
	Sven
--nextPart1574987.x3xfMY8n79
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJWVXDoAAoJEF2HCgfBJntGjbEP/3B9k2ZhMHKoUZk5u7wNGmyj
p0UUuZzVHODza//pczuapHo/6RNpr2A23rHkjqFRH5l0Uu5EyQL43D0WXmOvOC73
tCudPlt8FT9UElyFkTFvkkCCd916uJMv1TNfhjyACJoqYH6G+JkAxYvx+yrS00YO
myMcmQaFqS9fh89WY+nJfheSIUt6qAs6qWDaqflgEKeGIBwZE2hNsC10A19Z/gee
IZKR/xqSfqR/0w8OBUDAzSwVxxd91gIRtvm+2mX0yZQetwuvExkStGr2QgHQ5H70
MEydUI2zQyiLgX4MVm7PL9m3+S8oRUM0JTU0ogZqBtnLaBG/LPrtGi0gadPPnotT
dVPIs2OYFQGweKt+fk+8mkejXOAPCB0i8pB3PXwvW93pY6309f+YGHuKqv4BDrYb
CwQWVCYN08GCnPVf2lLDcJ5X6gzGmoUCfg6vtAuUhOyGw7kvcdHdc86a2eHalb5Q
UErkJkI0joOnkY0mLUua7Vzq2jehtTGx9XFJghDOn28aLwl8AJ/ZGkYX3+YSu+DH
KkquLS5AkCqQ7g8yic3kfAMeWYlUMF8vbuTYoK9Z9Ggb5CAu8F+t9Jy4INBwANQV
OCS02zXPIWfuqpuWTj+yLwE8Loi+YIWkN4KLodlLCYKFfdPQIhJg7L3DWRCWp8kJ
QwPzcpPjAePrJUYH5OXR
=ZfCv
-----END PGP SIGNATURE-----

--nextPart1574987.x3xfMY8n79--


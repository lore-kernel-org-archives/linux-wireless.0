Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56626 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0ASRyB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 12:54:01 -0500
Subject: Re: [PATCH] mac80211: pass station instead of address to
 update_tkip_key
From: Johannes Berg <johannes@sipsolutions.net>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <646765f41001190606w389a7702ja5891fa60458c24a@mail.gmail.com>
References: <1263907302.12555.27.camel@johannes.local>
	 <646765f41001190606w389a7702ja5891fa60458c24a@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SspdZiSfPfG0FUd31NXI"
Date: Tue, 19 Jan 2010 18:53:57 +0100
Message-ID: <1263923637.25138.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SspdZiSfPfG0FUd31NXI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[please trim your quotes]

On Wed, 2010-01-20 at 01:06 +1100, Julian Calaby wrote:

> >        TP_PROTO(struct ieee80211_local *local,
> >                 struct ieee80211_key_conf *conf,
> > -                const u8 *address, u32 iv32),
> > +                struct sta_info *sta, u32 iv32),
> >
> >        TP_ARGS(local, conf, address, iv32),

Indeed, that needs a change, I had the tracing disabled in my build so
didn't notice.

johannes

--=-SspdZiSfPfG0FUd31NXI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLVfGxAAoJEODzc/N7+Qma0SAP/R45lyNjTOxFaNf+TlY6FgpZ
fS0aRPt2N+D0CUzIT5zPew3WUOYUxxmGnb15B1/HNaVNkmy0BMrB4xBAJTou71/c
ZXOHz12SVk5NkCS4aXDVprMrVadNMeNnJjZhS/X2BvGg5McUbQDIMQNefnz+Bbtz
rmK+nKXHphR+YM/idxl3+Kt4wjTevsgs6I9PCBLgaNRuSEpnGIzmEi5ElfiBIZu3
cHrUNum2BWMOi5rIuewMNp5pA8RMz8k5em7glyeIgsqrzQr4lMSInqYcP67DkuSj
klvEavh5sfpcKmGTEJEfiridwT4HwoTCGL1jlp56zMkTmTNJlTWL8Qb5wEb2nRR/
YErhlq5Jsl8vfXl5Uk068OQRJGZz0GXkSEDnlqS0RZMuah7qZlZrzx32A776be9I
OZhZOX+gmoO1Wc2c9MgZvq9omQVTqAM+dp89FS8eID5SVzOAk5vWgmuTUyqJGfP3
XNi16QvHt7hYhVHvi7BHEBzQ8Rmfg1EYgZdBeUpyHVMDGcPYQajJ1yhIRsOMGPD6
ojEOo9YFNDpyEUsA6z46N+AwFD/gsVCC274U7ytqwrZfVFgL95LbL/T6m7vq4F2h
wUbLyQKQWk31t0mYr16/fVlIq90YKpeEmMf3lRK29G7ig0moZIsDwP/Q2tKSDV8d
+tzUzM7sye53/Md7oUE6
=qgiZ
-----END PGP SIGNATURE-----

--=-SspdZiSfPfG0FUd31NXI--


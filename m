Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53494 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbYIZLGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 07:06:14 -0400
Subject: Re: [PATCH] mac80211: remove wme_tx_queue and wme_rx_queue from
	net/mac80211/sta_info.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <eb3ff54b0809251045m47949af5u6a1615f0d42d37a2@mail.gmail.com> (sfid-20080925_194506_775357_1469676E)
References: <eb3ff54b0809251045m47949af5u6a1615f0d42d37a2@mail.gmail.com>
	 (sfid-20080925_194506_775357_1469676E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zfYy9ZU0EhlKZGrw4KVT"
Date: Fri, 26 Sep 2008 13:06:08 +0200
Message-Id: <1222427168.10563.106.camel@johannes.berg> (sfid-20080926_130616_953634_2C165BB7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zfYy9ZU0EhlKZGrw4KVT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-25 at 20:45 +0300, Rami Rosen wrote:
> Hi,
>   This patch removes wme_tx_queue and wme_rx_queue from net/mac80211/sta_=
info.h
>   as they are not used. (These variable names in fact a double declaratio=
n; one
>   is a pointer to dentry struct (for DEBUGFS) and the second is an
> array of ints
>  (for Extra statistics for TX/RX debugging - when setting
>  CONFIG_MAC80211_DEBUG_COUNTERS); both are not used.

Not really a double declaration since one of them is in the debugfs
sub-structure, but yeah, useless.

>=20
> =09
> Regards,
> Rami Rosen
> =09
> Signed-off-by: Rami Rosen <ramirose@gmail.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

but you may need to resend with a patch description appropriate for the
changelog, I'll let John sort that out I guess.

johannes

--=-zfYy9ZU0EhlKZGrw4KVT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI3MIdAAoJEKVg1VMiehFYpEsQAL7gUAQbQ7BKUZoIvui5gyXz
05vxtH5mCJgCc+MeYlMzY+GqRWSqlMqhxFCJIN28BA6JnvVL4f8sGRsW/QGuqPSJ
7ebwDLfdzir5jf3z54V2HebxTWiXmyrtB0VskZpkynGMpb6I1lNmtniM6+FS0mzk
TxpB6tieOnfWABA8su52gJZay7taeqprtRrzXf4ZsBctp6QMp9ezVz5V9TMb0Ru0
FcFN3vpcTjrrvwGgyiXWrmyV2FbDe5J13TdPbdb+R7ZwSELEwIj+qttZU/2KEhiG
7edq2iZ18AuBKJwqXmtRd4D4HI4C+6D8+O2/Ssa2yLjhTY8GKbzRYDkB9pqMBlCg
P+ja1m1BRR2l1kPv6Th2KZquQVxb1+eNUE6bTZJDwnFroM+7j5dblKB/27ih+3fw
eZUfcGhQbET08eIuLtLI5EzPnOjUZE7qsu1YAut8gndSGNBbxlsgG9iQNMHIPr9R
Wc5VO4Yx6UEMEIcKk3SGK7ocIymlgBTMvQ8umiedGdXULwaxvBx3FUt+TcWwNDO4
j+MQWQHoELxUxncw6OxkI5niZWIbHulrzvMi1m2Pe9HQAg/VAKcI9gW78TEEP9qI
7OCxK6INHkXYf5pncsJH7hFzfnYHQLhEsToBLwEjyzuloWkKChiRPPppm4LPMYey
sEKXsWrCx7p1+x1NiKv6
=pbTW
-----END PGP SIGNATURE-----

--=-zfYy9ZU0EhlKZGrw4KVT--


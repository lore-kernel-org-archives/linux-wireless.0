Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41895 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbZAFNBg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 08:01:36 -0500
Subject: Re: [PATCH 5/6] mac80211: remove unused variable in
	ieee80211_local (dot11WEPUndecryptableCount).
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <eb3ff54b0901060051x67121996ib7b1471e1e585ccf@mail.gmail.com> (sfid-20090106_095126_324912_40C35CBE)
References: <eb3ff54b0901060051x67121996ib7b1471e1e585ccf@mail.gmail.com>
	 (sfid-20090106_095126_324912_40C35CBE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oFQ4Ckddwm6SqjaCFXtV"
Date: Tue, 06 Jan 2009 14:02:25 +0100
Message-Id: <1231246945.3503.2.camel@johannes> (sfid-20090106_140139_746615_83B9715B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oFQ4Ckddwm6SqjaCFXtV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-06 at 10:51 +0200, Rami Rosen wrote:
> This patch removes and unused declaration of dot11WEPUndecryptableCount (=
an
> snmp counter) in ieee80211_local structure ; this counter is not
> incremented/decremented
> anywhere.
>=20
>=20
> (wireless-testing).
>=20
> Signed-off-by: Rami Rosen <ramirose@gmail.com>
>=20
> diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
> index 2697a2f..39f00e1 100644
> --- a/net/mac80211/debugfs.c
> +++ b/net/mac80211/debugfs.c
> @@ -136,8 +136,6 @@ DEBUGFS_STATS_FILE(multicast_received_frame_count, 20=
, "%u",
>  		   local->dot11MulticastReceivedFrameCount);
>  DEBUGFS_STATS_FILE(transmitted_frame_count, 20, "%u",
>  		   local->dot11TransmittedFrameCount);
> -DEBUGFS_STATS_FILE(wep_undecryptable_count, 20, "%u",
> -		   local->dot11WEPUndecryptableCount);

this won't compile

johannes

--=-oFQ4Ckddwm6SqjaCFXtV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJY1ZfAAoJEKVg1VMiehFYcmgP/35Wyzcvicq8J9/G5e7zA4O1
fogGiquJU67CO1Fvqw82U7l3MN26qo5DQVHIuked+0zwsiTt60fBonmKzTSkkOoc
IeN1gn9b8lnXmbUBvFxU/cSZmA+igJw/c+4hEnp1m54IU2SwW38ljBmOu0zWs43y
UNO5klz0ZqL1vIOALJIx6B7pELnkp6yOw3ibV/xTk7j6K4WdrBh2uflNClyTLj+W
GWgqTsVRnJfD3hB+HekfNN2dyKYNJdH8JQmwkXMsQTbPH+k+JV8lIdZENRNX+myd
AblEYNyaZl3K/wr8VO/Kc/UnYY8/K6iNutb2TsdAvWo+4eTqcvBoWINi8LaTXiar
/Bw6fRSpYi0Ul75S5Uugy1wg6D5TVcb2PKsjqnXpojgddvLbitqYujRy0lrTYiEE
rALorRn87JPmstXuCkM+X6yUjkze2xiJSwVHpiMgNwhlxuRcgF+aBfSxb0x8qPZm
bFNMApTbvXrtXs9VVymVy8+wFNK972wLa4fWB8wkJwHt9bA356stzjN1/wup9bqS
WEqQDhxE5JcFl0mCqlrFQNoDMnAQ255zoYRZ04RHgw8aoXtyAUqHHwFenGi6HEVT
TdpkhL7SrlhWxjlpFB80xsXo+RW8kLuUgOYu1MNRcFA/zn2YnXhFK2978OyorTZZ
/e7siJbvgZbg0EV1mrpy
=MPmg
-----END PGP SIGNATURE-----

--=-oFQ4Ckddwm6SqjaCFXtV--


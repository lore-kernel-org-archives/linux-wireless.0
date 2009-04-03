Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35330 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbZDCJYz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 05:24:55 -0400
Subject: Re: [PATCH 5/5] mac80211: expose HT channel flags through debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1238711166-2208-6-git-send-email-lrodriguez@atheros.com>
References: <1238711166-2208-1-git-send-email-lrodriguez@atheros.com>
	 <1238711166-2208-6-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Wj2ZhQx3KMRXTo8Kd9Et"
Date: Fri, 03 Apr 2009 11:24:19 +0200
Message-Id: <1238750659.27712.15.camel@johannes.local> (sfid-20090403_112456_858030_14B63C0D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Wj2ZhQx3KMRXTo8Kd9Et
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-02 at 18:26 -0400, Luis R. Rodriguez wrote:

> +DEBUGFS_READONLY_FILE(ht40allowed, 20, "%d",
> +		      !(local->hw.conf.channel->flags &
> +		      IEEE80211_CHAN_NO_HT40));

Why don't you just expose
...FILE(flags, 20, "%#x", local->hw.conf.channel->flags))

?

johannes

--=-Wj2ZhQx3KMRXTo8Kd9Et
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ1dXAAAoJEKVg1VMiehFYWHIQAKynbKEWlBaPqNVDuYM+pnuU
AbzoR+uKZKHvfGTGh5hYaYBAzkk6bV4uUHYWt0dNChLmSi8D/acn9ITa1xzNevHt
n0Nj1zUxv/o/xIX0aZArw/55I0wFtLqa/R7GrVbuhuia3RN/FhNLxODvFKs1utur
SYIY7jVPOgraNszimi6Q5B4m7aLB54XvhUNvwAZxqyOl+UwY7GpDx8YAKq12vlWT
qozEBnpvQC6HITQlZNbTo9h7Zmmzdonh6MgzNXQm5OJGAgiTFM8/FOpENMr6YOfE
6e4HL/YET3jraWHFEEocVHNCFpsb96WmP0k8L8GNvuh986x9SW9eO0SjK3liMB6u
bVtVgxZp8DI/uG7feQvu3U8GWrOwOr9KawLtJo7w70g7fzoWJMAJFgl/xwK4kQjn
KpdwW4/3OzQEu9fZ0BZeLftglJy0UeLAEKtYJmsG/V+os3igon43KLCFoQc/XYnR
HTlcMUhe9TQi3gFNc5T11HLutequRsEJyZgiPZncVqKAjcWxCthFhZZeBpjnyMi8
kVgSrO5GPpiCj725gKPJbtqjjqDAGR1EOkM7yr5IokBm9MA2sppfeCa8T3Fq5SSJ
pRV3HHjEgZ9L8ndMmQ3jJdxQndwVNG2Nh7txmE1v4FXGxVj20+1mjt2v3tI11QwD
o1YAKOVeRJJqb1ToMSbr
=4ko0
-----END PGP SIGNATURE-----

--=-Wj2ZhQx3KMRXTo8Kd9Et--


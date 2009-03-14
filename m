Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57931 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbZCNRVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 13:21:18 -0400
Subject: Re: [RFC PATCH v2 2/4] mac80211: track beacons separately from the
	rx path activity
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <20090314171438.11126.30330.stgit@tikku>
References: <20090314171234.11126.21125.stgit@tikku>
	 <20090314171438.11126.30330.stgit@tikku>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-431/ymkip4UYd8dJ0Nyw"
Date: Sat, 14 Mar 2009 18:21:16 +0100
Message-Id: <1237051276.5235.99.camel@johannes.local> (sfid-20090314_182121_466342_F28C415E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-431/ymkip4UYd8dJ0Nyw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-14 at 19:14 +0200, Kalle Valo wrote:
> Separate beacon and rx path tracking in preparation for the beacon filter=
ing
> support. At the same time change ieee80211_associated() to look a bit sim=
pler.
>=20
> Probe requests are now sent only after IEEE80211_PROBE_IDLE_TIME, which
> is now set to 60 seconds.

Looks good.

>  	else
>  		mod_timer(&ifmgd->timer, jiffies +
> -				      IEEE80211_MONITORING_INTERVAL);
> +			  IEEE80211_MONITORING_INTERVAL);

That seems to be indented a little oddly though :)

johannes

--=-431/ymkip4UYd8dJ0Nyw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJu+eIAAoJEKVg1VMiehFYQa0QAK436R/BUq+JtY3O2/exVi9X
s7lvnVIdBsn3gU4rqAF3ed/O5zJsolkvimwgjkc6wXrWXf53qYnCHv3/5N6MH+QP
SFUgxLXYNWNrcEue3b0GOyuQjiind8hPVU96fQnU0EjEDgZ11O1VVl44qxtYS2xp
G2AlrCSjY7McIqZV8VzQhEWTJMTZp+onZ8nNUCxj2ALbMgRezjLK3ceE3IMr7WEt
jn08AVhPmxlVzrUVZDboarDX9mReHLmlIxcEVspZKFaxAK5q1eNzM4gV3ZYs4jNj
E6aLeEvsdg63ZMJ97+OJ25mft5eVyB4u7dhl4vH1+pt/o0PpGkuaTETJBh632O8i
/YJc5bgBlWOLSSpAaS6PAhDGuvmVoeIiMpQR87d4oehetqCEF7SQy/I5hLyyW2tQ
RVg6zKjkaV5+Muj+tmCCxfNksQLvQ0jnPYEoS4leld8USH/eCw9a/y8pJhNmkdMc
43KUn45wWHK29p9fUVbJCIK36wGI5rFm//9Jcf1JjuvyUFo8WWLN4NDtoMZ+tHxh
DHWKVRjqE/kAIUSTMHO99BNIQwtGPW/J+pUR668J96PGtm2vDjbJCFnpLCYAikeL
kOnHy3XA0f51KfPXDIJFK6u9GnsK8JY0ah6nfW1pBsXUfGHK78YLB95jSiWdVP6e
Oq9mhjNumCLqm7D8jc4b
=GUkd
-----END PGP SIGNATURE-----

--=-431/ymkip4UYd8dJ0Nyw--


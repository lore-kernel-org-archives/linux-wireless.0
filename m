Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51819 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbZCUMqz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 08:46:55 -0400
Subject: Re: [RFC PATCH v3 0/5] mac80211: beacon filtering
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	"Luis R.Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <20090321120558.11613.56299.stgit@tikku>
References: <20090321120558.11613.56299.stgit@tikku>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-dHjbzrl+2zEQavKgMswz"
Date: Sat, 21 Mar 2009 13:46:52 +0100
Message-Id: <1237639612.5100.183.camel@johannes.local> (sfid-20090321_134718_478981_02473A7E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dHjbzrl+2zEQavKgMswz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-21 at 14:08 +0200, Kalle Valo wrote:
> Here's my proposal how to implement beacon filtering in mac80211. The
> basic idea is simple, the driver enables filtering whenever mac80211
> enables power save and the driver calls ieee80211_beacon_loss()
> whenever hardware informs about beacon loss.
>=20
> I have tested this with stlc45xx (with beacon filtering) and iwl3945
> (without beacon filtering) and based on simple tests this seems to
> work. For reference I'll send the stlc45xx patch as a followup.

Looks good to me.

johannes

--=-dHjbzrl+2zEQavKgMswz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxOG4AAoJEKVg1VMiehFYtFQP/RJjiSvGKx7xJhEap0tCigiH
9ATH7iuXekAVpYpnwFLxB0N5/xU0SruRVpG+kFfE4RGh+ZmUod3goVlSigfKuV6W
gPKSmtfwdhtjgITL+248ReQF8gfEmfA0QzXGuCx/LKNIEnPdzR0j314LE/bGQgh/
YacwXzUX4Ob9ChiIBeDi2mnPkIYSItAf5ee6DMn6814Fuh5kstl3Ekr1DCzDRcgS
LygbghenIPVXatdnblZpO+kAL71QsASQTMGFlYgGBHNzqLtzPpICTta+rTkgqtiy
ef8Rt28kcDhQTqVHwnssOY7wVGPbhFOFtgP5I01qItTh8bwjgMZgAVBWwEAkgUa/
eGo8UEEf0CSF1J8omkM2dBPL+oC84pNlNKXeySvvkK33BvZZdd7hQdjcTH5Ksm6Z
CnUsoIikfW5aX4FwgyLkcV9BwLInk5xsIcljhSIYfrs/UfwS4zLMP3Z2g8MspCif
jhrEnkVpQ83EV5TFdZc486eSTQRCd2AEMSeURw/h1pv7iP+ywb3E+zWbyq0Ewvzq
n6YDuVBUX2narZTVvAhaZICiLqNql5/CaPUCqwae2lshf3cJELdcK60vpDUu+TVF
xM097xTG/pX/I0a7yr1Rx5T1jMCFXNIejt4JbALerkQMvJFYhU33iPY80+Z1Nmob
IgeB0uyTTzOhCcnoY4e0
=znWh
-----END PGP SIGNATURE-----

--=-dHjbzrl+2zEQavKgMswz--


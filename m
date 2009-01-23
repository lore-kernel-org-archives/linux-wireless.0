Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42443 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611AbZAWQhq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 11:37:46 -0500
Subject: Re: [PATCH v2] mac80211: Read the TSF via debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Alina Friedrichsen <x-alina@gmx.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <43e72e890901230547w1ca9b24cp632df359e619c980@mail.gmail.com> (sfid-20090123_144709_152691_CA350B1F)
References: <20090123043337.270720@gmx.net>
	 <43e72e890901230547w1ca9b24cp632df359e619c980@mail.gmail.com>
	 (sfid-20090123_144709_152691_CA350B1F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KTqE6dgci55lOCNQ64gB"
Date: Fri, 23 Jan 2009 17:37:41 +0100
Message-Id: <1232728661.4051.0.camel@johannes.local> (sfid-20090123_173751_206308_2A11553B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KTqE6dgci55lOCNQ64gB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-23 at 05:47 -0800, Luis R. Rodriguez wrote:

> Alina, a few notes on this series. I see you have used the mac80211
> ops get_tsf via debugfs, and then added one for ath5k and ath9k. It
> would seem a driver-specific get tsf from debugfs is not needed then.
> The set_tsf is the only one that seems to be driver specific and could
> probably go into their own debugfs.=20

agree

>  Anyway how about instead of all
> this just adding a new mac80211 ops for set_tsf for mac80211 as well
> and then just add nl80211 commands to be able to get/set/reset them?
> This way if the driver implements them it'll be through a generic
> interface and also we can start using it via iw.

disagree. who the hell needs that, except for debugging? Why allow
setting it anyway?

johannes

--=-KTqE6dgci55lOCNQ64gB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJefJSAAoJEKVg1VMiehFYE94P/0vei2B4GYtsCGl4ZGkx0EeY
1GWUVpgUxlUM9aagFisimw1cN0SfLcSlrmPQc+v1RihHdjrsFe6Cvb8EZEceRlRT
TNpwbdXhw+xKUeJcQ5sICFh7OSceNF5IOFGDKgUd+B9FnP6OZ9mAQzPTfNglC19g
Mw7g261eUugoqw7J8VecRBTO8s7LXk/qnTjv+HtazYH5YfmfEoHjGX57fwZ0EdaF
VJNnbglsb9XhusGqpslJ6DGGKXYi9pviAX1VnsDS+Ct3Lw5WF4P68deITmqETvT5
hhFISLSolE5SsI2tm/nVKURuiOj7gver9g5meEEBuEQ4kwq37nk8kkNCh9sSWJQU
dko552A4wsw1tfy35cE4elTPoggU6qt97N/t1hmOyhAhCp6iCoOAAqy/cdnky4PQ
xUdHppoLilYxYZK3/dl7dOEEFfdTmoddEC/Kbx0aaqk2dv/fmX/q6bIFjVpgE08E
S+wK3j7/wI3OnEN4zG4/e8JfExtfO7sW708nlfslL50jN81EiUEk5tT9toi75fJi
fPjZ+jKUcSnJiAQYYOgdECAf7sBQVCAltMOYL6cJbysAS2HBrw/7eZXrmfCD2QSi
XOXBe6tMkHyGyZ6Cgyypi1/tJ0cUiTNprP94D4e42iHqAnC50L38F6k5WvVj1kFE
aYCDnVJn3YJYKJl6mLtU
=YZMf
-----END PGP SIGNATURE-----

--=-KTqE6dgci55lOCNQ64gB--


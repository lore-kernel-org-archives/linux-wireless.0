Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44916 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057AbZHNVNy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 17:13:54 -0400
Subject: Re: [PATCH v4 28/34] wireless: update cfg80211 kconfig entry
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net
In-Reply-To: <1250281559-13041-29-git-send-email-lrodriguez@atheros.com>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
	 <1250281559-13041-29-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hn7XpkLG1ZBV8T6LfzwO"
Date: Fri, 14 Aug 2009 23:13:52 +0200
Message-Id: <1250284432.4411.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hn7XpkLG1ZBV8T6LfzwO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-14 at 16:25 -0400, Luis R. Rodriguez wrote:

>  config CFG80211
> -	tristate "Improved wireless configuration API"
> +	tristate "cfg80211 - wireless configuration API"
> +	---help---
> +	  cfg80211 is the Linux wireless LAN (802.11) configuration API.
> +	  Enable this if you have a wireless device or if you just want
> +	  to test the wireless subsystem (see mac80211_hwsim).

This is not really correct, hwsim depends on mac80211, not cfg80211 --
the latter only implicitly.

>  cfg80211
> +	  allows for device drivers to register themselves with the
> +	  networking subsystem and allows for userspace configuration
> +	  through a generic netlink family for wireless called nl80211.

Again, too much background information. Nobody cares at this point -- it
should answer the question "will this help get my hardware working?"

> +	  For more information refer to documentation on the wireless wiki:
> +
> +	  http://wireless.kernel.org/en/developers/Documentation/cfg80211
> +
> +	  When built as a module cfg80211 will be built as cfg80211.ko

Again -- don't mention .ko.

johannes

--=-hn7XpkLG1ZBV8T6LfzwO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKhdOJAAoJEODzc/N7+QmaboEQAJdjlXcCx1koKBBILl3iblcQ
SpxS6hrCjyRPe8Gq+cIqaQdDqC+U7nZnlYMLwgTViC16lVD+Hdt/0Z7Z0dQ6299m
xFXkFW8mcpYt9gXNOdRNcB5q3b925oRQafgZ3l6g5A4QLwYO9lsaZxeL/TkegvfK
YtpcnYCxAtBboWNUrjyntER1n7ElUW38tD7RrGg+14H9N1pN8XHfhmqnJlVILE8+
betLkOfRFi7uKsiU4c3HPdNL7eFcrbVE9tz2kpAumFbk/+8ZlMGVvqN1mHPZpOBR
RuTqPD2+7Ihxla0B1jXSx8S4EqDGyzQq/6IIuC89KpJbRGcOQXoGKxQdui0dkE6W
xf+TRW8B7nJkgP0BxqzwpdIrdTsdA7XFRd5aiF/Pd652pvjFsamfg55Qz3EdO5o3
D5E0T91E9gXcahpxS0JTcHZPOoQCzKXbipQp1b8njkgnTJUfxUFYK1SGJQtNize3
lNQ0bfcPPTtsUAW44RrzCdZOhKM8gpcNs9RHwckJitSiusDeKmiTemMyfUjhHWtY
MQiBkDedoQAyuyHFY2Ir7HgpH+lc1dv9szwQbUqIBtTkj2dOu6FZwmTTsQ5rdfS9
I+EpoAKmhZhRg4locfHDopwTAtMBBzNKfDY4oK49z6Rr7ZUd8E+3ghTu5iCs1ZEu
w3g8Ukz8522Zj08JOdSx
=PDQL
-----END PGP SIGNATURE-----

--=-hn7XpkLG1ZBV8T6LfzwO--


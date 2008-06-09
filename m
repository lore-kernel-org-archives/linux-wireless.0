Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58097 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582AbYFIJQk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 05:16:40 -0400
Subject: Re: [PATCH 3/7] mac80211: add utility function to get header length
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1212774672.6340.77.camel@brick> (sfid-20080606_195947_688739_5CB4541A)
References: <1212774672.6340.77.camel@brick>
	 (sfid-20080606_195947_688739_5CB4541A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-b5TqhNY+4XwPZmlEm8H2"
Date: Mon, 09 Jun 2008 11:16:04 +0200
Message-Id: <1213002964.698.67.camel@johannes.berg> (sfid-20080609_111642_741145_B7BE5266)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-b5TqhNY+4XwPZmlEm8H2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


>  /**
> + * ieee80211_hdrlen - get header length in bytes from frame control
> + * @fc: frame control field in little-endian format
> + */
> +unsigned int ieee80211_hdrlen(__le16 fc);
> +

> +EXPORT_SYMBOL(ieee80211_hdrlen);

Do we really need to export that?

johannes

--=-b5TqhNY+4XwPZmlEm8H2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJITPTQAAoJEKVg1VMiehFYwnwP/A98cxkVF2U0fshrEXbvkMss
crnjYkLg7/P19wXDsWwr3d2PqbIuCGu9C73QHbdOdZV/Dp1dfhb+3pBk71d2pOK0
T5U/18yE/kptJi/foanX/b0ewV5nNY96xOXRkzhZdksBuo6IOnM6itwAcxSWqdV6
xvdmkwJJOw144xrC6zn9mRX2wc8cJWX5BAna/8UYBwIBrTkYiYYDEt9BK0NhKamG
9+mSHJqVOC7Dz+9i+7LGWtFmGIUsd1tcih4clJ6nMxmlRNt2S5cYSq+uV94NwdFE
7QpTcEh/6hApshv+2sd0uH4LhHSWIDHh6cPrjWxPfxGUcBpfGTrdLXHvLnql41bN
xCAIGA2ogLXHLfaq+vIJnryTypCttMoS+En94HZ8IXSsvDbE/ZPHqYcMJl8Koazn
ESp6rJofCdlaGStw+Ffb58lMDz/dj3UWI21sz/eJubno7sOD/sGMLKqp0YMPUxgl
o20uaBvL0Z974PklQIQ0jCkYODw714LGGks89eIeaJE7GXcgQdNcxjJcfUQ1GJp4
aSIebZ5wi8JJixhhqP8pXBCJT8EGqrVXOABFVIl5bOYulbmwruSUqCqiedFdyfJ8
z02YyP2ljTpJkchTyEjQIykGlEPsAVnuZ5rBtNdVCxCR5A6i+CymfVCioag5qgS1
MmvnpwCLB755vvsFk887
=BMSl
-----END PGP SIGNATURE-----

--=-b5TqhNY+4XwPZmlEm8H2--


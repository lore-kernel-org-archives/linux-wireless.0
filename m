Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52279 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYFRRY0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 13:24:26 -0400
Subject: Re: [PATCH 2/2] mac80211: add spectrum capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240806180917i320fac4bxcfd7416349850bff@mail.gmail.com> (sfid-20080618_181759_104880_844104E9)
References: <1213800824-32107-1-git-send-email-tomas.winkler@intel.com>
	 <1213800824-32107-2-git-send-email-tomas.winkler@intel.com>
	 <1213803431.1312.24.camel@johannes.berg>
	 <1ba2fa240806180917i320fac4bxcfd7416349850bff@mail.gmail.com>
	 (sfid-20080618_181759_104880_844104E9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QmypTg06SHZzcVeRET7z"
Date: Wed, 18 Jun 2008 19:23:44 +0200
Message-Id: <1213809824.1312.34.camel@johannes.berg> (sfid-20080618_192430_046032_F821750C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QmypTg06SHZzcVeRET7z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> We need driver support mainly for quiet period and channel
> switch.(patches will follow)
> Not sure how the precise timing  will be handled in mac80211. So we
> don't advertise spectrum capability to AP if we cannot handle 11h
> actions.

Channel switch is interesting. Do you actually handle that in firmware?
Most drivers don't.

Also, does your firmware implement full radar detection? Broadcom and
Atheros hardware seem to only pass information about pulse edges up to
the driver (in different ways, obviously) and pulse/radar detection
needs to be done in software, I'd like that to be somehow shareable.

johannes

--=-QmypTg06SHZzcVeRET7z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWUSdAAoJEKVg1VMiehFYrzUP/if4ANO/JwQwnaWv8RK6jmcS
ClNViyrEc4dDQESir6P00QzXNiD4mY+x4ygu0r2LJWUihev1KIjeNxxxhY+U6pkB
Ox7DKeKNqVB0kBaMDIkagvLHUlJlD3jnqRoDsPuqk28V2r+rY/yxlAt6pTVSTGMl
mbUPnyPFmKcAIMM/K2hzg4j8uRdsF+ffo+/PNaeBbd70pYMcLgyobLKeUqYiUYO1
gouIX7OzPlghZCZlQlMUII2TrbVLZb/vIVnwy4YBQEyLobeqAF8oNM+RhBmF3LvB
q4f/IjDjtaOhEOax50m0Xm16svFJp1YUn6hEDMA43aEkQomofrKDDTLVjiDCAPQA
cFgtgu68F9uCVeqGqdksc2wbTYnNun/ElQIDtg/k76JjdF9b5UfMzzIwan/JX3Xj
/1KoK8vG2SfUKBUmTdPr9i3Efjk7dYFYJybDTa+VeyXMmj7ZPY5Ajl4QEI66AQ/+
XnrZYwxGKDoWZ2+1kdesnodxks1+jCOThHMTAHlqP+S4/x/QxdlFze4uhiXO9iTy
BKFIi+VbJqkFpOmTLZ2XV2KcKbVXEYxV5dN7A4BGUcC+Ft6TvJ0qyim82STVtgLQ
k31Ih3QaVSmOWYL6KX9PwPPX19vCZ+P1Bj01Z1HEt07AZQrsG3N3QqUBoVsoBFtB
e1rOYVmC6EdDTAB0YWo3
=Ccmz
-----END PGP SIGNATURE-----

--=-QmypTg06SHZzcVeRET7z--


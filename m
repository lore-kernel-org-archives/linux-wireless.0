Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42549 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbXIALDz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 07:03:55 -0400
Subject: Re: [PATCH 18/35] Only cancel correct timeouts for Auth and Assoc  replies
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1188644091.4146.12.camel@gx>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
	 <20070901043557.2498.6553.stgit@dv.roinet.com>
	 <1188638228.7585.124.camel@johannes.berg>  <1188644091.4146.12.camel@gx>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3oss13+7iRfXKJCigjUe"
Date: Sat, 01 Sep 2007 13:04:58 +0200
Message-Id: <1188644698.7585.144.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3oss13+7iRfXKJCigjUe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-09-01 at 06:54 -0400, Pavel Roskin wrote:

> I understand that.  But at the time I did it, I wasn't even sure that
> the mac80211 conversion is possible.  I wanted to have a solid base
> before starting the risky conversion.

[...]

> The patches I have sent were not meant to be reviewed in this list,
> since I expected the latest version to be imported as is.  But I think
> it's still better to send the patches separately rather than a single
> patch.  If nothing else, the separate patches could receive some useful
> comments.

Oh sure, it's fine to do this first, just wondered if you were now
spending time on it erroneously :)

johannes

--=-3oss13+7iRfXKJCigjUe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG2Uda/ETPhpq3jKURApBAAJ9FpOvlSl+NN/BoyGcVXvgblTlVlACfZlqO
vMS7yET3H2ZWNS5cfvv4kxg=
=T10m
-----END PGP SIGNATURE-----

--=-3oss13+7iRfXKJCigjUe--


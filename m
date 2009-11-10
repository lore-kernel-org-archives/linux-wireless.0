Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50115 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289AbZKJRLf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 12:11:35 -0500
Subject: Re: [RFC] mac80211: sample survey implementation for mac80211_hwsim
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200911101723.50859.holgerschurig@gmail.com>
References: <200911101723.50859.holgerschurig@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5GXrEW6aR/rBsJHY1mkx"
Date: Tue, 10 Nov 2009 18:11:09 +0100
Message-ID: <1257873069.7037.64.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5GXrEW6aR/rBsJHY1mkx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-10 at 17:23 +0100, Holger Schurig wrote:
> This adds the survey function to both mac80211 itself and to mac80211_hws=
im.
> For the latter driver, we simply invent some noise level.

I guess I'd prefer to keep that out for now until we have drivers that
do it and we know whether mac80211 should aggregate the information or
the driver needs to (like this patch requires).

johannes

--=-5GXrEW6aR/rBsJHY1mkx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK+Z6qAAoJEODzc/N7+QmaAYEQAMNRg5+7osS2hjO+wDU5Gljv
po9BoHIb9Ew7ysK6V5yxQC5ILGQS38tTaGTi/euZ8Vs2+0HGCeZQm4Y8uTrXVM8s
6EWZlluqtyeE70rJquMTEQ41EyHq4x4qDewKrNLurthZv49QFCfNmG77NoVMtEox
PXn4IWysEsuUENLDazNzSOC773Fr7SiqqgncAfdVX+dkNLcqnNebeI/z6oF1dBQw
V7fQCPWi2FM3bj3jvWee9PtMYhByzbOWyp0M8N+DuFa6BzzknFqMUHG5f9/No14r
9anh776s2VI4BAal6FaruNDVHNH8+zRjRAXvLtlr2G/kGZYN/1A4yTAM7A/FRfYb
zOjaz6DzgMttHS7dOsu6zb0rjHL6+H59f+WenoIqS2do3u147O6rbZ+J0bcCB0vf
GQdOWCVmWG+7ICsiL0fBGayT7aAsXbXAjXaFH/+AO3HyRIoz9Tiii6vQvzRClf5g
EeeWwEAjDcouOo3rP6kAXKt6IVAJvhjTAbwCP1TkGtaM5DdQmgeTc3ko+3sQ5WzD
WzqMGlIPYbARTrebOs+HkUwXr9E+S9I97Ra2PmhLBRbzdspEjGxijsTomgW1yuzP
KLORV6rdS1qZKQY6PQoJvyE4XZu1QzaGSfXd6821AzuhIHzNm6AVofZcyirwh3Cm
LlpxuWLvjPmu5cfAiXbq
=2gzU
-----END PGP SIGNATURE-----

--=-5GXrEW6aR/rBsJHY1mkx--


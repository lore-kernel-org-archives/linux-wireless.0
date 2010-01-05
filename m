Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60948 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab0AEKoL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 05:44:11 -0500
Subject: Re: [RFC PATCH v5 2/7] mac80211: add debugfs interface for U-APSD
 queue configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org, a.young.jason@gmail.com
In-Reply-To: <87vdfgvobq.fsf@purkki.valot.fi>
References: <20091231133626.29899.95683.stgit@tikku>
	 <20091231133720.29899.75214.stgit@tikku>
	 <1262684902.21956.1.camel@johannes.local>  <87vdfgvobq.fsf@purkki.valot.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3sWiR0Qr5S/fCjCbXHqo"
Date: Tue, 05 Jan 2010 11:44:08 +0100
Message-ID: <1262688248.23910.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3sWiR0Qr5S/fCjCbXHqo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-01-05 at 12:27 +0200, Kalle Valo wrote:

> I'll store the values shifted in local->uapsd_max_sp_len and do the
> conversion in debugfs.c.

Ok, but please add a comment then to the field that it's already
shifted, typically we store values as per spec (0,1,2,3) and then put
them into the right bitmap position when using them.

johannes


--=-3sWiR0Qr5S/fCjCbXHqo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLQxf0AAoJEODzc/N7+QmadIAP/i5x/XEY7REE8E73A1r96fqR
bibFNGwe/nyNTVbdubiBG8dGeeQlYsOdFhFAXX99KR1B0wl53r5MwMSTITIZ7+HH
4Ol2Veoeevtq2f1LDRUPoHqDLtbJbIy0wvWSlA9VJjBmhlt1xdNUNb5+ZhAwv2xg
8RHSpafe2qj5ZBjTY0CQdq/q3xInPTT4Hh3pTABzKg/8cSTN2G7JtvZiwFIMfDT8
ICVuhhMidrutaVka6w7pLMFiHho9JN86jDKUwS/dIke/tZ/s5vl/YonK2ZyhQSSU
3SREr6zqi6PgUL/8B9r5fPSIVjUzo44MMWHT/Y47KMva0ZkqzyCbEII4Yg6qu+h4
memEXR58w9UxdhaPOJGZqmukejpDdrGYIVmz+qZmAZbvOR5udcYTRlD6g7c847Cr
4o8BE+riQIwFoYHpC5NKY/T/UrwkOvUtifs/rL0NBa5nt/UI336q1Kpgrfh0lS46
ctRgFIHhCI01XrGyyIX8eMla9sa1ODb+RTpB00s3m1TfV3CiGJZNgGl+zOKzcPfu
Z7gIHEGuBVYS6fzfEA9HZg17ogCe6Mt8Kuts7Rq3rT0lv1xpD4YMccktahg1q9QN
UiNIO3PCxkOiD1sGYcgObiiSsjHEMtefJnHvc1wDQUHSQKN/x8FfMckL+ZY6Mcvp
ZNTiFXJqFgHh+vorlU3J
=71Zb
-----END PGP SIGNATURE-----

--=-3sWiR0Qr5S/fCjCbXHqo--


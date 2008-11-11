Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57770 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735AbYKKM5P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 07:57:15 -0500
Subject: Re: [RFC] mac80211 dynamic powersave
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: Vivek Natarajan <vivek.natraj@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <87k5babg4l.fsf@nokia.com> (sfid-20081111_133043_344251_5D49B0EF)
References: <1226245439-30329-1-git-send-email-kalle.valo@nokia.com>
	 <8e92b4100811102018q4a13568l625abf2c59dca253@mail.gmail.com>
	 <87k5babg4l.fsf@nokia.com> (sfid-20081111_133043_344251_5D49B0EF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aEAyG2UY3LwGsD2j5e0I"
Date: Tue, 11 Nov 2008 13:57:00 +0100
Message-Id: <1226408220.3890.40.camel@johannes.berg> (sfid-20081111_135719_070307_CF6DBAC9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aEAyG2UY3LwGsD2j5e0I
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-11-11 at 14:29 +0200, Kalle Valo wrote:

> Yes, that's how I have understood iwlwifi to work. Currently stlc45xx
> is the only hardware which requires the driver to create the null
> frames, but if we are more than one hardware I think we need to
> considering adding the feature to mac80211 (with a new HW flag, of
> course).

b43 will need that too, if we get PS mode working there.

johannes

--=-aEAyG2UY3LwGsD2j5e0I
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJGYEZAAoJEKVg1VMiehFYN0kP/AvNAC8E9AKa+zNtqFf6ViIf
OZRMGntHcmFcOPgVN/zCz2mjgFsxTqygOT9Qo3ekGA4BljixoCwTHeYa68Sjje2k
/23Rs6yjBRz1FrKRr+ySfpsGW7gzzKk8i66Rg5sOXzvIATHbo78u9kvKuUwm+HSN
D2VPkjhjWpEyUZDj8hCfIVtJNA8KcG+64ErJ4AyfO5GLNWU/3HuLHxiAXZl1bSkq
NETgMLHXQ62+fE7GIYDN9YK5loySZdb+mrjmvfrE0uegWs+9MaFUJhIgAbPU5a6T
ARqfDneA6TWAkJS7EmhVPdX/Bww51Fubvh+SH7jbwpMSvK8dA7Z+CTryidk0oR09
82vB3VR3t5LsrBqIMeyEzrL6UgxHLK1dRZ7hSW9u2SKjOevgh3CvtC368oLErCSc
1XaSc9/XbvHo+9+niIY6WlFS6w2hrdX1fo6m59VIp0UjRrMMA3OYROTfVy1pj5qr
KOsth9At3oEh7zNGHLOaGJvsSfQyEwsxVKRIxRJEIBLQvyy1fMRiuZThupT+uV2Y
WN5TSg+oCtT/CafqiXBHnmO4Qso8OVNOPEpKOokEkzDT74K6Wkjl3ZMjXEI6J/r2
Yd6rsfLPK0J4UXTMDCffgEcGmQBM8rNS1R86kOLnUG7K0CTlEQD+uPDe52cNANku
n6K87NvMNSseXfCGU+nz
=Lou2
-----END PGP SIGNATURE-----

--=-aEAyG2UY3LwGsD2j5e0I--


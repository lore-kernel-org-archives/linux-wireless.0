Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35903 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab0A3PmM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2010 10:42:12 -0500
Subject: Re: Multiple SSID on same phy
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: "Luis R.Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100129122718.73a6c877@nehalam>
References: <20100129122718.73a6c877@nehalam>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-IJPQfKFiAMB/fEUXq2jD"
Date: Sat, 30 Jan 2010 16:42:07 +0100
Message-ID: <1264866128.3546.185.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IJPQfKFiAMB/fEUXq2jD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-01-29 at 12:27 -0800, Stephen Hemminger wrote:
> What are the restrictions (on ath9k) for multiple SSID with hostap
> on same physical device. Should/will the following work:
>=20
> 1. Duplicate SSID's (different channels)=20

Not really/well, wouldn't go there right now.

> 2. Same channel but different SSID

Yes.

> 3. Duplicate SSID, same channel, but different encryption method

"Duplicate SSID"? If you mean the same SSID and different encryption, I
don't think that's supported. If you just meant two SSIDs with different
encryption, that's doable by using two (B)SSIDs.

johannes

--=-IJPQfKFiAMB/fEUXq2jD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLZFNMAAoJEODzc/N7+QmahNwQAIQT8JXJDHVYYOtDC9NtaI34
bTHlcLkBnQXWcCfWP6LmRv8htYnUOT2VdrMJPkAHCQ4Dr3CC1oFCIspqumQBWiYT
M1RrE+G/NXEdsyzBObl2+fP+WxaNswPaR1+QHo7l+sujdvVkTm8xy+8sJSDqFrjg
6bednsnacitALfaO+qaFPg87lYVp9nWILjbQYZAcnr/menHubhavO0O8B8zTberC
t6mavMs1T0+8IhreE6sfj1ZjLv1zEb91hLvou/rNAVG0xDq/+pxNBGYHCv+R72SP
RmN5tAyMAGpxGjtEdzbgC7CvNbETV/dsCavo6DtAZO34CHWzEAlh7m4VauXZYKu/
vpTwqcMSN5FBoT2b3A3ZZ5I/ABeEn6WlMTlQZl9TJGZkXkltir/Cof2QEer/31pL
YhXKolEh6dubjX7/A2NWEqG/HH1DLyrzoumDRjjPbPikaKltchdMRK/efYP6XfS+
cVewRGcSEDkwBUHx1ky0HvA8UZjPmVt2DOLMBbvnGYtyNvyLcOQAFURfROrWYTYR
JdoakXYgrYBny0V97Vq5byUeY02WvTxJBkqK9axbF1sAW7k87NkewZDu8HPpOk2z
eZH7qTKHQinlC/2S3H49SPL45WHlb2aSTJsvm1LBb/eXdFn7oHGeC+WMSFgnGy+I
UFTQCdh2CUzdpaE8vGrN
=HU8C
-----END PGP SIGNATURE-----

--=-IJPQfKFiAMB/fEUXq2jD--


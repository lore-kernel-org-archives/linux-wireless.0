Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40633 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbZEZN1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 09:27:47 -0400
Subject: Re: [PATCH v11] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Will Keaney <keaneyw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A1BDE51.7020009@gmail.com>
References: <1242942720.4212.19.camel@johannes.local>
	 <1243068246.4606.45.camel@johannes.local>  <4A1BDE51.7020009@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NZaBHNwK3pa2XcCr7She"
Date: Tue, 26 May 2009 15:27:13 +0200
Message-Id: <1243344434.5996.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NZaBHNwK3pa2XcCr7She
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-26 at 08:19 -0400, Will Keaney wrote:
> Johannes Berg wrote:
> > This patch completely rewrites the rfkill core to address
> > the following deficiencies:
> >  =20
> I applied this to a fresh pull of wireless-testing this morning, and
> haven't had any problems from it.  It looks like the soft lockup I
> reported earlier has been fixed.

Good to hear, thanks for testing and the report!

johannes

--=-NZaBHNwK3pa2XcCr7She
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKG+4uAAoJEODzc/N7+QmagsYQALVjrzAW10pjP4IkeVOB0Pli
rY6QVoyFc2QaKL2XkljXfi8+Tbq33wGbdOkhMIX6k6T6uFXbmncWYbHEuHnz278g
mV0UA8pxGoVLhDzjbeSCpJcS3bT53Gk0pWeesxPVYXwSYq09/xJrgRumMfsq0RpN
meDdpIU5vfx+LsD3iipN0377pMTN3iuGJs/Br0FRWWwCsm8FFF+0DmSi2dpvm9eC
w3vmJcAH0CGTsSynqcb/26CkIEntLo+RDHZYvGFE/Bay1p5kYmi+gjcQnte9itDj
mHrFX25Q7Lmk0TTCM6eupuYsWI0GUuCrw3KSeGxBCkjkB7my244a+HK0yJkfZPkI
JNFl+0YzAUYmBHOx5o9mKohEC23TI90u1vcyuDj3Uqus0qQL8FMsynYlaWX/OCKI
W2WjKMt1Ppg3/nCYyxrd9ee/U7xN0wFQI4RP3TapYlvBDqPHR0jlR3/yTf/YBgb+
54nq7GbQw6Qto/oXq7UNkEYxNxc6+v3Z1U2N/zqM5el6pX7OwGipTvyZQ3xUFTqb
v/TFMLIjHmdI27ifWCTQoVa6SR+C/GZ7zZCZ+CfUMeR9OiBBupnbIEDdk3WItNLf
OReihwuBxBNSbynQeQWxHBlS1bmyczLRs2J7ln41VQhXQq7TcEmT4flsNK40PqYq
542xw687buMfQO2U8wGz
=1asx
-----END PGP SIGNATURE-----

--=-NZaBHNwK3pa2XcCr7She--


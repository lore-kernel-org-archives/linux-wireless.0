Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44355 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbZLSKb7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Dec 2009 05:31:59 -0500
Subject: Re: [PATCH] ar9170: load firmware asynchronously
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890912181502u3610ac23qe2dfc09f1d337bf5@mail.gmail.com>
References: <1261176470.14206.23.camel@johannes.local>
	 <43e72e890912181502u3610ac23qe2dfc09f1d337bf5@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Z8uTYl8ilEqB54VAKQ3u"
Date: Sat, 19 Dec 2009 11:31:50 +0100
Message-ID: <1261218710.27718.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Z8uTYl8ilEqB54VAKQ3u
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-12-18 at 15:02 -0800, Luis R. Rodriguez wrote:

> Sweet -- we could also expose firmware load events if not done so
> already and let userspace propagate such nasty warnings, I think we'd
> need to pass the firmware expected and the driver the requested it so
> that once the firmware is in place (I guess through inotify maybe) the
> driver modprobe can be retried.

Actually, since the driver doesn't fail loading, the _bind_ has to be
retried. I'm not sure there's a way to trigger a re-probe though, which
would be easiest since userspace doesn't necessarily know what to bind.

johannes

--=-Z8uTYl8ilEqB54VAKQ3u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLLKuPAAoJEODzc/N7+QmaVgIP/A8OZzwa6eJecfwsBpPpbQVk
qi4wbP+/1AMMncoYBdr/ZvlS6O+30ua4Ri2uvsc2dVuBGADUoA8hdFcI3gJN9sg9
HDbmRa8X8x9XjKZsO83h13AJyGVSRopYDGJyQikPqhNFOQ4EmqhX1osUnDL+I+xn
1kvj4yP5wr11+WZoY44yC3l47tUDtDY1Ga00gsOtURH44WNIo9hkTGCUJqxhaHjg
IwuPYYRaiXEFYCqX8n6iL7RgYic0L2aTcxNBZdDx/4oyNxwFtJ7Ed+x9DO8a7S1H
TPf4wn+KroU124EUZukTMIZ6xoyWTlyNdcdcGVx0gO3WpUAV60qdeEkebe5XDjr2
mRsbc+vUh2B9ieE3+jdm5YIFU/3r1xowsx7C6K1dIMdaCpeKqQzP0lpE7ovHwLwn
NDrP/HqQX1Iwp3U+nraDvPsducOideA1Gew7yOd8zZOGw4lFGopmnW4bbgxz9Qbg
XTwHbUboSHzxiUHWqyg7nFk4DnEJn4F2YvGs/hpN5gKOFgcfdK2E4ukGqvqT3eyq
CjABzVbIT/YlKKNeCVintGNXjX2neiJvimVAZb2bC9Hnggbk6yq86H8Fp3D5a1KM
V7VteXCc1OrKreerIWhYlBhi4ZcLhsbFa9GXfltNW8G1Bb9kC05yRVDO5aABZcrU
4lpObK2EKqps+7bakrr7
=EUPJ
-----END PGP SIGNATURE-----

--=-Z8uTYl8ilEqB54VAKQ3u--


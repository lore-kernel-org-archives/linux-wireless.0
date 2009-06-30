Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56273 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbZF3LOF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 07:14:05 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1MLbHs-0002qX-1J
	for linux-wireless@vger.kernel.org; Tue, 30 Jun 2009 13:14:08 +0200
Subject: Re: [PATCH 0/7] connect API, wext conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <20090630104952.857270082@sipsolutions.net>
References: <20090630104952.857270082@sipsolutions.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KxPA8dx25pJefiI6CE8e"
Date: Tue, 30 Jun 2009 13:14:07 +0200
Message-Id: <1246360447.16643.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KxPA8dx25pJefiI6CE8e
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-30 at 12:49 +0200, Johannes Berg wrote:
> This set of patches implements the connect API and
> wext conversion for everything in mac80211. Other
> drivers can be converted piece by piece, and then
> later we can make wext more internal.

Oops, I forgot ASSOCREQIE.

johannes

--=-KxPA8dx25pJefiI6CE8e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKSfN6AAoJEODzc/N7+Qma854P/AvxQ4OTTMVc8hqUoMco0+Pv
Y9wuTZjS9ubE/FS3WJCAl3AQUcXEbHQ1rbw5Rvz8m298IBgR28vI/EeuBVy7/8Rv
WD8I5z605ZP6b/9ror4hoNyMyjWhWakvj5e+cpG+sf8vcgGO0Nk2iHarV7vITeJQ
C5N6zWSkjmADxPtXxOA/qVtiAFZne17vBma3oJlV9wch1py3DkHGZLDAmgpBDw8v
mcz/NuKkJ9lPfbEZdYr+WS9vdzOkApAQRj9ktc8zcLKcrx434G8cxwwH3Fw9dOSv
LFgDE1YvDbajQRbnGP86hdgK9kojQfGs0A9RyvqCZaEursJ23gyNpeqcfU8g9N7W
p93E6opD+GGlcgrtiGIjlDiKHpOUsIefQ5DxPUFDtMmrkwtZuAaXWNk5pd5svKyc
e1kfntiF9Mqckpiq/0kgd6ARoWKDV0Hrn5ZaNIW3cxtQm7GR6hdrhM0jFTeKlay7
gyTzd6+PM6ppKEB7Lxbkydap2JhbCQ2kLug6h3Vk6Ru4cHtIm5St5TFIRMhKlhJu
eXRCmNo7dildqPrbzsKIo/nh4aYSwQtRFRiBTK+gBuc/RiEYMadX7j+NBpR2/dzb
Hn5dIge48IoPDvjnbh7zWyCTf95KF9n7MOakgS/5EhNYymRM2/+5nyQxtOUPrPfR
9OXufnvFY/Xbo/dqTzAw
=XJnE
-----END PGP SIGNATURE-----

--=-KxPA8dx25pJefiI6CE8e--


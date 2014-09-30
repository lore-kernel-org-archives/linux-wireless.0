Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55518 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaI3W5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 18:57:04 -0400
Date: Tue, 30 Sep 2014 23:56:54 +0100
From: Mark Brown <broonie@kernel.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linaro-kernel@lists.linaro.org
Message-ID: <20140930225654.GP4273@sirena.org.uk> (sfid-20141001_005709_445177_BD5D7352)
References: <1410909415-11661-1-git-send-email-broonie@kernel.org>
 <20140930165626.GD11919@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OwXh6gFRjCd3qPCM"
In-Reply-To: <20140930165626.GD11919@tuxdriver.com>
Subject: Re: [PATCH] hostap: proc: Remove unused variable
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--OwXh6gFRjCd3qPCM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 30, 2014 at 12:56:26PM -0400, John W. Linville wrote:
> On Tue, Sep 16, 2014 at 04:16:55PM -0700, Mark Brown wrote:

> > Since "hostap: proc: substitute loops by %*phN" (62c5afb8e388) the
> > variable i has been unused in prism2_bss_list_proc_show() so remove it.

> What tree are you using?  In wireless-next, I still see a loop in
> that function using i as an index variable.

This was in -next for whatever day I sent that.

--OwXh6gFRjCd3qPCM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUKzU1AAoJECTWi3JdVIfQV44H/RGfyC3SpG7H537cvvMztvxw
2tpeunlU7NaU/wHoJMrTYmGSkb2sNaUoWnqHpIwMimxDhSKT9nDWza4p526SAmVH
YItabYObmpGIuSpdd3q3DmwLq3lCEPWM9QyiFPv6HoV1eozU1lfA2185AAIRc5u4
FR108GnKB2NI3lG3oOX4L20CeHbiM5cPiotXRDMtjvjIocuZvcDiOmQywWFkpbtD
2FMrX4lP9LqnLokkXfRYugQkeDd4h2T8V4RiHW0vZBnZC9mswPdzKxTVDHvoNrFF
zyzS2nOHsgCQsq0XoIWEtQtmN42kpsGsgH4RczExNyQpe0sbXkEE8iL/CXKTeK8=
=phRU
-----END PGP SIGNATURE-----

--OwXh6gFRjCd3qPCM--

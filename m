Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47983 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbZAGK1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 05:27:03 -0500
Subject: Re: [PATCH 04/11] ath9k: introduce bus specific cleanup routine
From: Johannes Berg <johannes@sipsolutions.net>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Christoph Hellwig <hch@infradead.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Imre Kaloz <kaloz@openwrt.org>
In-Reply-To: <1231322972-24094-5-git-send-email-juhosg@openwrt.org> (sfid-20090107_111132_955895_E4ACE8AD)
References: <1231322972-24094-1-git-send-email-juhosg@openwrt.org>
	 <1231322972-24094-5-git-send-email-juhosg@openwrt.org>
	 (sfid-20090107_111132_955895_E4ACE8AD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mK5TJh9mj9tPBLK7M/pY"
Date: Wed, 07 Jan 2009 11:27:22 +0100
Message-Id: <1231324042.3545.24.camel@johannes> (sfid-20090107_112706_827958_EACF1A9C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mK5TJh9mj9tPBLK7M/pY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-07 at 11:09 +0100, Gabor Juhos wrote:

> +	ath_detach(sc);
> +	if (pdev->irq)
> +		free_irq(pdev->irq, sc);

the irq stuff also need not be bus specific, if the bus specific code
tells the generic code which irq to use

johannes

--=-mK5TJh9mj9tPBLK7M/pY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZIOHAAoJEKVg1VMiehFYfTEQAJyfXttE1Ou6iPmYFF4SOPJM
NDpfXCVQ4+xREnT+FBx3XQPGDFrcxSurgUMFKpUUYjEqli5f9E9sWz3cxabqjesV
IbEcJiwF218Y35aUiKPEoPz5dyQ6XynonvoRsFJSVTGOu2/v1KBnIU4jjydwIK49
3IvtiC364wBsbIxZ/INCixKvDcsHU8O4VHq9bSwfrEEB7LdV/cLr3KQlORajG7yh
us3fi+rMwTvm6L4wPBRc15/X6FP0BLdiQVU9Ea2m7Sxj4DOkbg107MQ5bL5SP7oT
eyTfjPWjhmrP4N+0WB8e8hshGyYkyZXFhx1R8IMKS4OF0vDjESp4XXDSXA3XiWQK
XzE25VenfPDZpvqsXQOPBKlRVYhaXPHoWn0LxJC9Ek/4bZsdJCQSQiK3svaBxVUc
0BakqHHGizVZs18kTguI+F2QsDKG83v77tbDuCIIO0Taivnpgww0xXr9dv3lHqus
gej+1iexySrmNR2dmpxFHwSuRfQ5ux5r2XlayRdTwnBYxqvlOa9XRy541LvGLtAb
Jtn1fG4K+QMgnIlG7Y+rStAShIjJY1EiuZGrgvuYwp6CWr9GFP4/PJxHr2AriLVR
b7Uf7nb3H/wqd/v5UQ2JJLdhcdfNFQYHWDPFdkpI0H/8L06827SIt9dfZFl6Uyhu
ZZF4sDkXLzLhiEAIC2PB
=1F4L
-----END PGP SIGNATURE-----

--=-mK5TJh9mj9tPBLK7M/pY--


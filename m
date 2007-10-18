Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35380 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545AbXJRMcM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2007 08:32:12 -0400
Subject: Re: [ipw3945-devel] iwl3945 doesn't work
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen.Clark@seclark.us
Cc: Jens Axboe <jens.axboe@oracle.com>, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	Ismail =?ISO-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <47175033.1090709@seclark.us> (sfid-20071018_132320_921494_D70D5666)
References: <20071017135452.GJ5043@kernel.dk>
	 <200710171708.48654.ismail@pardus.org.tr> <20071017141111.GM5043@kernel.dk>
	 <1192630733.10567.37.camel@localhost.localdomain>
	 <20071017142246.GQ5043@kernel.dk>
	 <1192634183.11584.0.camel@localhost.localdomain>
	 <20071017163519.GC15552@kernel.dk> <47166B5F.1010804@seclark.us>
	 <20071018065746.GB5063@kernel.dk>  <47175033.1090709@seclark.us>
	 (sfid-20071018_132320_921494_D70D5666)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GVadZ4A/0zUVWAUZ+wOJ"
Date: Thu, 18 Oct 2007 14:33:08 +0200
Message-Id: <1192710788.15285.4.camel@johannes.berg> (sfid-20071018_133217_946506_9C631E3E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GVadZ4A/0zUVWAUZ+wOJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-10-18 at 08:23 -0400, Stephen Clark wrote:

> >>iwlist eth1 scan would report no scan results, I then switched to loadi=
ng=20
> >>the kernel module with
> >>the option that tells  iwl3945 to do software scanning and it works=20
> >>everytime now.

> In my modprobe.conf file:
> options iwl3945 disable_hw_scan=3D1

Hah. Told you it wasn't mac80211's problem. Can somebody remind me again
exactly why we have hardware scan offload when we parse each received
packet anyway and the hardware doesn't even batch them so the CPU could
wake up less?

johannes

--=-GVadZ4A/0zUVWAUZ+wOJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARxdSg6Vg1VMiehFYAQKEIQ/8CAQbLgqV99MdJPZjkJzoJOyQD8EhHv8j
6BfBhzXkjUMaT9cje+tO82vhM91sToSt0i7NX1qzBKgXLXC/ML+u++FzM0BTun1l
S8R263OU4fpxPNyGSfNaLGKuJwOj230sE5wBrIsIVEp6E7Fcb5m+MLTvRhf14Woq
27QZpABivEED8FwYP0ydsZh9xwu6zrHEC2DYxsVCDJTCWXHgWf+oAAbjEX1NkEV3
5+vpdGM0gv5ZsJP973EC8i9dPvTmr+020ImL+GgMhK2MskhjhAHEGdrp2k4Ch7sb
Phet6VNUyOVkjRA1eMrjqsE2RXewcZsdctYfk0MAEsG8qDLMLbk6YrRLS5MBlgfo
5kLe8oT3nNiQX9Vklesl+Jyb0nbfbz638+IsMpPTwvDhFc/iuu76qFiE+RaaTcRQ
Z/IkBfyySGaiqAb/Yy65oAke1U/dfcXdfyCik00YjhEyNg+FnBI4n5sxhwmBVo9G
bRmcyUQ0H6JqZIVUjRn9XJ5ND5Iwv9T2KEP8kcQlG56NoBHHK1uDImHdrfqRqX5q
jKBInJT2yt+3UOToMgW78yNiT1fDfUBrzDJdRl7z/NklzK4UqbEbZ8G4cwc+/zQq
OD8YFBopjNN99oJNIcNoYdKwYUVbUNRdjd7/IJr+FhbAyjm+dRaGaLtEeiCkuj1o
GW40aiIjR38=
=/0ri
-----END PGP SIGNATURE-----

--=-GVadZ4A/0zUVWAUZ+wOJ--


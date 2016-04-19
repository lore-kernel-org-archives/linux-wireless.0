Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54868 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933402AbcDSR1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 13:27:18 -0400
Date: Tue, 19 Apr 2016 18:27:06 +0100
From: Mark Brown <broonie@kernel.org>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	=?utf-8?B?77+977+977+977+9IO+/ve+/ve+/ve+/ve+/vQ==?=
	<eyalreizer@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>
Message-ID: <20160419172706.GD3217@sirena.org.uk> (sfid-20160419_192742_512008_314ECA3A)
References: <1460273570-12298-1-git-send-email-eyalr@ti.com>
 <14313437.cDJIgY3kzo@wuerfel>
 <8665E2433BC68541A24DFFCA87B70F5B360BF614@DFRE01.ent.ti.com>
 <1463330011.BhWEcYYuGD@wuerfel>
 <8665E2433BC68541A24DFFCA87B70F5B360C0745@DFRE01.ent.ti.com>
 <20160419171239.GC3217@sirena.org.uk>
 <sjdvun1fuj4nyi0bgf268g53.1461086401627@email.android.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="EP2pG3U7hXy67fX3"
In-Reply-To: <sjdvun1fuj4nyi0bgf268g53.1461086401627@email.android.com>
Subject: Re: [PATCHv2] wlcore: spi: add wl18xx support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--EP2pG3U7hXy67fX3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 19, 2016 at 05:21:01PM +0000, Reizer, Eyal wrote:

> The main quirk here is that i need to send extra clocks after the spi init command while the CS pin is "high" in order to put the wilink chip into SPI mode.
> So just sending an empty transfer wouldnt do the trick here.

A single byte transfer would result in extra clocks being sent so there
must be more to it than that...

> Do you have a recomendation on how to do it without changing the core logic. If it is possible it would be really great.

Please be explicit about what you're trying to do here.  I imagine you
may need to change the core logic but we need to know what it is that
the device needs.

--EP2pG3U7hXy67fX3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXFmppAAoJECTWi3JdVIfQ/oQH/j0MMWsgYKYzsuK4POtzTpyJ
lGSE/l5CDNo99oXISIKHARL8soJXUOOwUHXsVHlo5Hb8eFDrLe7c8hVfr7j7+iVx
8cH+PZZ6qxsTn7X5Lm3IjpqbiZV3aHGFMgxuCAh31++ZYYi1eS86mNqQLHxIH7Wi
iiImKWSJtBplg/9s1YHYcJtatgELI0jCsMsYjhKuMaYQrBMlKBd24dJx8UblzrSd
bLii2gUB96kitwJa7gVdEt4V3tCPg1KhcTRObkEemLZcKmI0pw4epoNt6xk/FDi7
LC2F55hrnaE9b2XUxB9PGejmD2bwasdumNB1Jy0aqEI+F/nhWgVhASSyxv7YNSc=
=ggS0
-----END PGP SIGNATURE-----

--EP2pG3U7hXy67fX3--

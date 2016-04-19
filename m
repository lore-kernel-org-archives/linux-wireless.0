Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55016 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872AbcDSSqg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 14:46:36 -0400
Date: Tue, 19 Apr 2016 19:46:27 +0100
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
Message-ID: <20160419184627.GG3217@sirena.org.uk> (sfid-20160419_204700_571178_7B2A0823)
References: <14313437.cDJIgY3kzo@wuerfel>
 <8665E2433BC68541A24DFFCA87B70F5B360BF614@DFRE01.ent.ti.com>
 <1463330011.BhWEcYYuGD@wuerfel>
 <8665E2433BC68541A24DFFCA87B70F5B360C0745@DFRE01.ent.ti.com>
 <20160419171239.GC3217@sirena.org.uk>
 <sjdvun1fuj4nyi0bgf268g53.1461086401627@email.android.com>
 <20160419172706.GD3217@sirena.org.uk>
 <oe8hqfknrcljrjawnrxlohvr.1461087275186@email.android.com>
 <20160419175402.GE3217@sirena.org.uk>
 <us0dopt1inbrt0x47njgc2vy.1461089085965@email.android.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="mEgWsss+US7fWyVR"
In-Reply-To: <us0dopt1inbrt0x47njgc2vy.1461089085965@email.android.com>
Subject: Re: [PATCHv2] wlcore: spi: add wl18xx support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--mEgWsss+US7fWyVR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 19, 2016 at 06:04:49PM +0000, Reizer, Eyal wrote:

> Thanks! Glad the illustration helped.
> I will try it out again as if i recall cotrectly, i did try that l, and it didnt produce the correct waveform, but perhaps i didnt understand the usage of .cs_change correctly.
> Will double check anyway.

It could also be a bug in your controller driver, it's common for them
to not handle cs_change correctly (at least those that open code the
message loop, obviously modern ones just factor this out into the core).

--mEgWsss+US7fWyVR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJXFn0CAAoJECTWi3JdVIfQKw0H/jOYdlXC0V/rFL8ZKhslFovs
ldUSdQfhkzvk7V5VBXP4hGnX+TwCXdNXSc/O7/gK1IUYBOmvsKISonGuIypTUVXu
ExgAsuR2JfUprjfCldeUhhIJIQryCP0gc1adis4IK4UrjoX6hSwqu3pK9OKHpdYT
0Q4WwnDAP07hFfWGJEM1Jeid8n2rnQRW1B/mCOteW1r85+XdtuiS/NVWZwj6SDUr
m135oFf9d0cVycKqcu4KXW+FBCHAp25I/XKGUg924jU0ZfSn5TB5HJpvLiiMq3d/
JppDWHOmfsNjLzBLb5Ciq2LQzSVHz4JuTK9n9Y5ezwsJ+MSX16XxnuL1RaQ7314=
=UEMr
-----END PGP SIGNATURE-----

--mEgWsss+US7fWyVR--

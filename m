Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34032 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756506Ab2FTKrq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 06:47:46 -0400
Date: Wed, 20 Jun 2012 11:47:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Wei Ni <wni@nvidia.com>, 'Philip Rakity' <prakity@marvell.com>,
	Rakesh Kumar <krakesh@nvidia.com>,
	"'frankyl@broadcom.com'" <frankyl@broadcom.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Mursalin Akon <makon@nvidia.com>,
	"'linux-mmc@vger.kernel.org'" <linux-mmc@vger.kernel.org>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	"'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: Where to power on the wifi device before loading the driver.
Message-ID: <20120620104744.GK3978@opensource.wolfsonmicro.com> (sfid-20120620_124752_841519_C01778B3)
References: <20120614121234.GC3913@opensource.wolfsonmicro.com>
 <4FDA092E.10301@wwwdotorg.org>
 <6B4D417B830BC44B8026029FD256F7F1C377BFFE8D@HKMAIL01.nvidia.com>
 <4FDB5976.20809@wwwdotorg.org>
 <6B4D417B830BC44B8026029FD256F7F1C6EE2DD61F@HKMAIL01.nvidia.com>
 <43E4817426ED174AA81263BCECB4351D138E8ACD6B@sc-vexch3.marvell.com>
 <6B4D417B830BC44B8026029FD256F7F1C6EE2DD622@HKMAIL01.nvidia.com>
 <20120619091719.GZ3974@opensource.wolfsonmicro.com>
 <6B4D417B830BC44B8026029FD256F7F1C6EE2DD626@HKMAIL01.nvidia.com>
 <4FE112F2.7000506@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="F55Y67F01HNW3AgB"
In-Reply-To: <4FE112F2.7000506@wwwdotorg.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--F55Y67F01HNW3AgB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 19, 2012 at 06:01:54PM -0600, Stephen Warren wrote:

> Unfortunately, it should be noted that the WiFi device socket on Cardhu
> apparently isn't some standardized thing (like PCIe) but something
> rather more custom, although there are apparently devices available to
> plug into it from multiple module vendors which contain WiFi chips from
> multiple chip vendors.

Right, and indeed someone may decide to plug in something that isn't a
WiFi device at all but some other SDIO attached device with totally
different uses for those GPIOs.  Really these boards are an example of
the sort of thing I was talking about with modular reference systems,
though a simpler case as given what's brought out you probably can just
do something like list all the options that are there and allow hotplug
to sort things out.

--F55Y67F01HNW3AgB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4apGAAoJEBus8iNuMP3dfD0P/2Xtd5aTLHDWOxvbicUix1CW
v+mfFEHoglO0I8GcC7QWEibEStlIlXDdXQ63CZLPia08XiCqyb9ls57ZWppTTpY8
CH049NpfmHRMHkPe865wYf62TcQd5oQf7qGVjEU6GF8WP/6Wajc+HwTUmhRGAarN
cuLNP4lF2qKqJAVORe5bLUdgChtNLSn0XQCReyC9aVtWJ7VrNZv+BLe55a5jAZpM
9Io+wIo+z40X3xVqAaNhdk2ZkEE+l2Ytd8bju8u1xl4gTMx2hS3g/Nyn2uHxng8R
HQgYvHX9hybf9njdbIgWAHm+6fz3JPE/Jass7iQ6V2+iqnX2HvEkbtaLBtxCTKc+
k2XdW4/IggN195pr3HMWU7ssjpkvrXwxi49dqWzvY0yCWGUSDaw8CKy6kGGtKvvd
W1TAVxmLlz6r4CcS0t9v2UF19bswuy8z22TKRIRsh3EO23X1OY/DTk0tMS16in3U
CcdvsXFPwa+xolqSkFGUf98Y3dr3G7q7zNF3EoebiXrsung7/lRo1psMFjasV6ur
5aluaQ4cvtYgdVAJf5hKmiAankNhvIAGK0HLnZNhK3Al/3jh/KML0WPZQAukXO4B
Cm8yVf2N5w9KW3NGajbVl5/AoyZZgU2sOl4jVKLPniWddZpTqj0DuGXNlg3qW26F
/j0HH7ZJPXBuLCBHM6rI
=RgVm
-----END PGP SIGNATURE-----

--F55Y67F01HNW3AgB--

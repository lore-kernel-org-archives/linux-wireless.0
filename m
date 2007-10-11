Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:32981 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbXJKImV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2007 04:42:21 -0400
Subject: Re: [PATCH 2.6.23.RC9] wpa_supplicant didn't work w/ wpa_secured
	hidden AP
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	linux-wireless@vger.kernel.org, Dana R <dana.r.ferguson@intel.com>,
	Dan Williams <dcbw@redhat.com>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20071010202422.GN5962@tuxdriver.com> (sfid-20071010_213845_637104_A2C288DF)
References: <1192040814.12399.4.camel@abhi-desktop>
	 <20071010202422.GN5962@tuxdriver.com>
	 (sfid-20071010_213845_637104_A2C288DF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/doTnFNISL2oFfo+aez5"
Date: Thu, 11 Oct 2007 10:42:21 +0200
Message-Id: <1192092141.4770.17.camel@johannes.berg> (sfid-20071011_094231_963142_8EBF4C28)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/doTnFNISL2oFfo+aez5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-10 at 16:24 -0400, John W. Linville wrote:

> P.S.  Is limiting this to STA mode correct?  Would wpa_supplicant
> ever set that flag for an IBSS?

Regardless of whether wpa_supplicant does, the user can always do that
with iwlist. I think it should be done regardless of mode.

johannes

--=-/doTnFNISL2oFfo+aez5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARw3h7KVg1VMiehFYAQLubw/+I0y+em/qEdT8bMNz6/fgBOd/A/WWh40j
kSMtpe97YfNhVGepxizVUMiI+l8bXXSe/0NiJ3o5dx/5lARGD1u5rEipO77jjnLf
nt3svSOCTKvf8TqhdSAXiv/rAVWeYbaLy1h1EHwxRyAs05wyCDZWb+Vm1HpFxWro
fNs/IRJSfEyzp5v3LpD6dz3QAIl681j0uZqzwfnlY/856RhreWcnfPHlyGxidD0J
f15zlN2nCiBzeGfGVpgjBPDmmc35RybzHxMv8ZZfpKyiO54LYDTdkSe9lNwLxn8J
+E4KQMFryyg62zySGFVrRkksolrc+gNHhbskVJV966Bueg1jXqjdXY0Jezyo0baP
XS9SAKLmif8eXRQ6rQEU3guhqfcRIIGHuCV9ddTa1nB7M16NX5nnv7t6u1nOQnv8
MxQ2+mE3/9+U14sEsw7es44Sd6mCHNxLK12aZfo8cF9fS9GUpvqVvXT3CfEKEaya
P2Ne3E0PcdFQW8OCcBr5r8+D+Lb8jy9RHGFNLWH3eQO001KY2vN7jfBmgBEjT26Y
PQ7mBqSO9gsBsvElEnTecS1aE/YorEVygWOtOBMAtCzNS1NYo+fTkKpPuN+6MRx6
2wLgSqWpzJrDmDqHAHTcpB3C6GzdzKYCfqP4WYG9h6TL4uzKox5DESw1YMxcBOU+
dEsbTw+/xxw=
=vNJX
-----END PGP SIGNATURE-----

--=-/doTnFNISL2oFfo+aez5--


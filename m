Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.188]:54171 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbYANWQ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 17:16:29 -0500
Date: Mon, 14 Jan 2008 23:16:10 +0100
From: Mario Guenterberg <mg@havelsoft.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi 1.2.23 vs. kernel 2.6.23.13
Message-ID: <20080114221610.GA9080@/bin/dnsdomainname> (sfid-20080114_221638_018741_CA6E3831)
Reply-To: mg@havelsoft.com
References: <20080113150536.GA27544@/bin/dnsdomainname> <D936D925018D154694D8A362EEB089200364DE52@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
In-Reply-To: <D936D925018D154694D8A362EEB089200364DE52@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 14, 2008 at 10:54:09AM -0800, Chatre, Reinette wrote:
> On , Mario Guenterberg [mg@havelsoft.com]  wrote:
>=20
> > I has tried to compile the latest stable kernel (2.6.23.13) with the
> > iwlwifi-1.2.23 driver and the mac80211-10.0.4 framework. I has
> > patched the kernel source tree and when I start menuconfig, it
> > was fine.
> > If I started to run make, nothing seems to be wrong, but the iwl3945
> > module was not build.=20
>=20
> At this point the new mac80211 module should be built. There is no
> iwl3945 in the 2.6.23 kernel so it will not be built as part of this
> (the kernel build) step. After you built mac80211 in the kernel you need
> to follow the installation instructions of iwl3945 to built it as a
> separate module outside the kernel. Details can be found in the INSTALL
> file that came with iwlwifi-1.2.23.

The built as external module works fine, but I wonder why the
patched kernel sources not works. If I use the old iwl3945-1.1.19
with the 2.6.23.13 tree, the built process works in the kernel.

I see the patch_kernel script in 1.2.23 have the deprecated state.
But when I do the patch_kernel after a make in the 1.2.23 source tree,
the files are in the kernel source tree under driver/net/wireless
including Kconfig and Makefile.=20
But the module wasn't built. This makes me wonder...

Thanks
Mario

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQIVAwUBR4vfKjUZahlMISn3AQJw+w//c+Q8BnrTw0A8+NM2hjNGUOxNyJggPk3N
v4CNjUUIFRrwtXiKYeGWNXBowqY4BF47c5dHMQ49CIMbHYx8OMKXpwY2RA1gPGTr
EV3Fw3hNqpAcEToMB+zujRkWBcnr80jYoW8Y3bvUc9tcZCJ5T2JK90EF9MujT/m2
ZX2itLscLPM5K++D3NmKT7a5yvbjSDc1v3oBD14d6C54c5ylMyQzzMRaWRZjg93c
eqttEEfVhwurCu8BwtZwkROqBlJlrqyAT2hIz3nvhEbH2hL6XDFaRtHfxPcU+bOJ
ei+DiZ13+QNTLy/zumcz1dI9I7qloNHCS73JjIhi2TtZ/m4xzDzYr+sQ5UD/yJiX
w5bWaVCKAPjqFhxGSD6iwv0xKTm5wN39fvHn81YJALNBh8HaHy9yi9SdZDVjQ3Sl
hikfeej2wHBITCXrPAcSu+k7ap54P3aTAFcknB/0pj2GbcF9i9msPZE3NySIgMRK
+5Ml03vPry4NDjFFQNgG1ElOg6XYRAE7x4bEBRVpvQPk+9hnfma5zrSYh/fQ3qc1
Fwrl3fB7XhCsxPJtYpKBLQPbc64plIzCHigsTBb6re5v2RqRg+7MrvpHilwbUR0R
mthdUlZyQeyRNnZTqfywffyBmOQhfMmSA0bmQD7NlwJ26eFKG8wjCYY5DGIwmgh9
DwcDuAFvDr0=
=i1jW
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--

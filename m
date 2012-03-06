Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:51823 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab2CFXcg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 18:32:36 -0500
Date: Wed, 7 Mar 2012 00:32:21 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, larry.finger@lwfinger.net,
	florian@openwrt.org
Subject: Re: [RFT][PATCH] b43: fix logic in GPIO configuration
Message-ID: <20120307003221.7664eb4a@milhouse> (sfid-20120307_003239_868541_D5D422ED)
In-Reply-To: <4F5695CC.3010206@hauke-m.de>
References: <1331071898-3651-1-git-send-email-zajec5@gmail.com>
	<4F5695CC.3010206@hauke-m.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.0Ze0s=_Mfc=J+K_g5NfDBX"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/.0Ze0s=_Mfc=J+K_g5NfDBX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 06 Mar 2012 23:55:08 +0100
Hauke Mehrtens <hauke@hauke-m.de> wrote:

> This patch did not helped fixing my problem. The ucode still takes over
> the GPIOs of the buttons with firmware version 666.2. I am getting the
> following messages:
>=20
> [   83.620000] b43-phy0: Loading firmware version 666.2 (2011-02-23
> 01:15:07)
> [   83.624000] Init value of B43_GPIO_CONTROL: 0x0


I think this is caused by b43_gpio_cleanup. Can you try removing that funct=
ion (or just returning early, for the time being.)

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/.0Ze0s=_Mfc=J+K_g5NfDBX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPVp6FAAoJEPUyvh2QjYsOgIgP/2QULepEOF8bNmkP8533NdGE
MvOnQWxBedUPYmgFbuKO186BaweooEUhJuFFql82YX4B60UjfGXQbBNQ/pm8ucbq
87kjbb/L+K+y0F0BQOcO4fdcnKREdu80JR4BGPdP2ZLMHQwCvizJwXgiM/hO0gE+
xEVsufwjzf1UNuewfSriCTPeTX6TYTDfn2CfSlIXkLchR5x4lpahpc3qMJ9spRGX
lumQpTW88c6/GvGSyNgEigByNruw1r4lj/mVpzMwq2DOiR7+UjuauStMyla3yS7W
TADgcrP3Ye2Tj4HKabZWZGYmbuLAANz7gzN+DNqBXwyjaUyUA1nhdf5RcAW6X3Si
OEJSBtJbaO19ycP3p00ugL0W7pALl8GX6Z8HAbvqm7YH1ViF9wQw/g7WxsciTxtg
4Q/RKj+IE7t2ROhbsOcwLB5eTx2enNoC0ASHS6YcuPUfubjjddkvN6s7JQBe+m0t
81zqzerpZc3iEPYm+cowTD1VsoZ/OA3HDj/YxMZhp78ksT+1AnvYBQ+Y/QaEoqMC
dRDBGPKBqVjAE2m4dyC6XXm44CyMY7iJDJ7HgdW5DZ929N9lsiLl79e2JuN++IeU
P8CJ1PWlol6Yvn1S/V0IJdNCC0JORsZSuWOsSEtO1xdgYD7tii8aZwtCCqAy1IHl
MlIglMEEyvyEu1s4Bns0
=NrbK
-----END PGP SIGNATURE-----

--Sig_/.0Ze0s=_Mfc=J+K_g5NfDBX--

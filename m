Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:56443 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbaKLGpZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 01:45:25 -0500
Message-ID: <546301B6.9090609@rempel-privat.de> (sfid-20141112_074528_820272_EE52F309)
Date: Wed, 12 Nov 2014 07:44:06 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: ath9k-devel@qca.qualcomm.com, nbd@openwrt.org, patro@cs.wisc.edu,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/21] make spectral code common for both ath9k drivers
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de> <21602.42365.82080.843506@gargle.gargle.HOWL>
In-Reply-To: <21602.42365.82080.843506@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="C7DBGjEMn12eFXMwFIgHMnh6goLPJ3lLi"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--C7DBGjEMn12eFXMwFIgHMnh6goLPJ3lLi
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 12.11.2014 um 01:10 schrieb Sujith Manoharan:
> Oleksij Rempel wrote:
>> - makes spectral scan code common for both ath9k and ath9k_htc.
>> - add spectral scan support to ath9k_htc.
>=20
> This has been merged, but I am getting a build error.
>=20
> ../drivers/net/wireless/ath/ath9k/common-spectral.c:40:5: error: redefi=
nition of =E2=80=98ath_cmn_process_fft=E2=80=99
>  int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct i=
eee80211_hdr *hdr,
>      ^
> In file included from ../drivers/net/wireless/ath/ath9k/common.h:27:0,
>                  from ../drivers/net/wireless/ath/ath9k/ath9k.h:27,
>                  from ../drivers/net/wireless/ath/ath9k/common-spectral=
=2Ec:18:
> ../drivers/net/wireless/ath/ath9k/common-spectral.h:146:19: note: previ=
ous definition of =E2=80=98ath_cmn_process_fft=E2=80=99 was here
>  static inline int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_=
priv,
>                    ^
> ../scripts/Makefile.build:257: recipe for target 'drivers/net/wireless/=
ath/ath9k/common-spectral.o' failed
> make[10]: *** [drivers/net/wireless/ath/ath9k/common-spectral.o] Error =
1
> make[10]: *** Waiting for unfinished jobs....
>   CC [M]  drivers/target/iscsi/iscsi_target_erl0.o
>   CC      drivers/thermal/thermal_core.o
> In file included from ../drivers/net/wireless/ath/ath9k/htc_hst.c:19:0:=

> ../drivers/net/wireless/ath/ath9k/htc.h: In function =E2=80=98ath9k_htc=
_deinit_debug=E2=80=99:
> ../drivers/net/wireless/ath/ath9k/htc.h:632:74: warning: =E2=80=98retur=
n=E2=80=99 with a value, in function returning void
>  static inline void ath9k_htc_deinit_debug(struct ath9k_htc_priv *priv)=
 { return 0; };
>                                                                        =
   ^
> ../scripts/Makefile.build:402: recipe for target 'drivers/net/wireless/=
ath/ath9k' failed
> make[9]: *** [drivers/net/wireless/ath/ath9k] Error 2
> ../scripts/Makefile.build:402: recipe for target 'drivers/net/wireless/=
ath' failed
> make[8]: *** [drivers/net/wireless/ath] Error 2
> make[8]: *** Waiting for unfinished jobs....

Hi,

thank you for testing.
John already provided patch for this.

--=20
Regards,
Oleksij


--C7DBGjEMn12eFXMwFIgHMnh6goLPJ3lLi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlRjAbYACgkQHwImuRkmbWncSgEAkM/rfZo/zwdPZ6HZsHqI7L8O
WaXFMFH2Yo06j2Mdbe0BAJOd3VarAwT0iSk61J6wvGaW83mOm7vE4NEQb27ZMekk
=64SI
-----END PGP SIGNATURE-----

--C7DBGjEMn12eFXMwFIgHMnh6goLPJ3lLi--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:33346 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932941AbbIUQli (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 12:41:38 -0400
Date: Mon, 21 Sep 2015 18:10:39 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH 1/3] ssb: unexport ssb_bus_pcibus_register
Message-ID: <20150921181039.69e601be@wiggum> (sfid-20150921_184145_425114_1018D8E5)
In-Reply-To: <1442821640-14582-1-git-send-email-zajec5@gmail.com>
References: <1442821640-14582-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/A_50QnTtdzzUD+AmEtZ=3D0"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/A_50QnTtdzzUD+AmEtZ=3D0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Sep 2015 09:47:18 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> It isn't used anywhere out of ssb code and we don't (plan to) build
> pcihost_wrapper.c as a separated module.
>=20
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
> ---
>  drivers/ssb/main.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
> index a48a743..8cf23a2 100644
> --- a/drivers/ssb/main.c
> +++ b/drivers/ssb/main.c
> @@ -876,7 +876,6 @@ int ssb_bus_pcibus_register(struct ssb_bus *bus, stru=
ct pci_dev *host_pci)
> =20
>  	return err;
>  }
> -EXPORT_SYMBOL(ssb_bus_pcibus_register);
>  #endif /* CONFIG_SSB_PCIHOST */
> =20
>  #ifdef CONFIG_SSB_PCMCIAHOST

Acked-by: Michael Buesch <m@bues.ch>


--=20
Michael

--Sig_/A_50QnTtdzzUD+AmEtZ=3D0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWACv/AAoJEPUyvh2QjYsO44EP/iRdcKqlWU48Mfql7Jh+y6DT
LYNa5y7TqP18ujQr3bNJAisNMEXMwYp1LcA7yOkmPtDW1Vlhm9kGJnrsAf8dbGRf
gGmm1Nb85vuZpZaTfWy5kmknGTqh9RiAL2ZnaNy/WsvUTo1siuRWfLJ1wXF1Yy8p
f3or9xokBrQhzUjqbB2lCDnBffSZldYEX8/nP3zG0iqG09qrzyXDyzOxWLzH3cvT
NLUdLMGuJgC14dfK3R6LcV7TTMDs1WjF6A/92RNsSHKOHhDXs3bDUZheYSUma1Kl
bF+wvml0CwfMZFR4chXTaFSwPpBmlytNuBNc0uuXNMbbutL97BYNqlSO8eEjkYIf
6uwFwsJsYYiGZ9DAyhoESoaED1HEU3nM4ZKmeo8vTCOm1soFjq61HZIPd0aZBS1o
O69OPq2AAcyNxtA2VqHPCuRIHQs46PItceQIZmhnQWi+9fNxWmVEBt+zKFzHVs6U
x+DqsVvS3/BS+tBw847SVqmJTUyW9MhDUIQteYJ6QN9LixSJ74CNvk48AN1tFOac
+xqrlssbBCULndPEMu5LNZc4rdlZZ9Tl9i/Cd+qCDc+5acGaOMUmTP6IqohYRM3P
AZoqIQeQuwhBlFN7zTWYOIgw6IXNBtYO9pZpwk0Rhw2GhigcxLnKyCm16jZCiCvf
xzDwE8Xpcgzc0Pk40YHk
=m7M6
-----END PGP SIGNATURE-----

--Sig_/A_50QnTtdzzUD+AmEtZ=3D0--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:37797 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751067AbdHUHLo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Aug 2017 03:11:44 -0400
Received: by mail-wr0-f177.google.com with SMTP id z91so89253393wrc.4
        for <linux-wireless@vger.kernel.org>; Mon, 21 Aug 2017 00:11:43 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: kvalo@codeaurora.org
Cc: Christian Lamparter <chunkeey@googlemail.com>,
        ext.waldemar.rymarkiewicz@tieto.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Aeolus Yang <aeolus@qti.qualcomm.com>,
        Adrian Chadd <adrian@freebsd.org>
Subject: Re: [PATCH 2/2] ath10k: search DT for qcom,ath10k-calibration-variant
Date: Mon, 21 Aug 2017 09:11:40 +0200
Message-ID: <3114796.44GtYcDsBs@bentobox> (sfid-20170821_091154_048582_E499CF3D)
In-Reply-To: <3853747.Q0JJmSnsYM@debian64>
References: <20170310080615.22958-1-sven.eckelmann@openmesh.com> <20170310080615.22958-2-sven.eckelmann@openmesh.com> <3853747.Q0JJmSnsYM@debian64>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart12028771.XzEh3oFhZC"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart12028771.XzEh3oFhZC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Freitag, 10. M=E4rz 2017 19:20:54 CEST Christian Lamparter wrote:
[...]
> @Aeolus Yang / Kalle / QCA: Would it be possible to assign a variant stri=
ng to
> the Asus RT-AC58U?
>=20
> I've attached the necessary bmi-board-id=3D16 and bmi-board-id=3D17 board=
=20
> files to this mail as well. So, all that needs to be done is to add
> them to the board-2.bin on your codeaurora / ath10k-firmware project.
>=20
> Kalle: Can you please update the board-2.bin for the IPQ40XX on your
> ath10k-firmware project on github?
>=20
> https://source.codeaurora.org/quic/qsdk/oss/firmware/ath10k-firmware/plai=
n/ath10k/QCA40XX/hw1.0/board-2.bin
> It looks like this board-2.bin has support for a few more boards.

Any updates on that?

Kind regards,
	Sven
--nextPart12028771.XzEh3oFhZC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlmah6wACgkQXYcKB8Em
e0a5fA/7BWyQh0lltWysUHy37ocXfu6fLIzEop3yiJAx1FMPVVYbrDR3dMbYLvE8
02RPipu5O7W1+VV5ugnyGUJ/DaJCrN5SngrWrjGT7GGZX5Kkpk3fqb1/UArpTAlD
xb5/ubbwK59rXUqsa1AkOC+UP1ltm9HcPkVVROA4FcMcjZXvCVKOfLd+spW5uGXc
5o5mPHG7pTpfCR+qIcOrjM72vT5mdyvZtVg5UTb/2Tuq2qyLWEcCs/H0/NXWzp9x
O6R9L0cr68JuSoUhee+20SZ8KvsNAliAEqskvlzD+5GFyNTNNxOdSo5NaPeTUs1n
Ik+X3Ie3hH1qTUrf7ue4hpvCmvyfg5wJZnF3hoYJLCI9y0HXRmEgjAoBpCD0ENP5
Nrjg03ETJ2sDCDuG3lSAtcEVB7qerowkd4RRk2tObTXshoPFLAGXUrevMnS6qouj
mAdDhpY6/VZ8MhiDFTcYg5rf5qxY553Q19V65GVKwGXJNUN+iO2H/P4SFeKutVpv
xFobADPor9NXL+rWwHrIlqdRnZFu+byE0D/o9WhO/p/MbfDSXJs9s6XuToNkBK0d
hpqKbkFfMVNwvDRtW8zo7Toa4pQrygyoLga1UgRwDSoEQznnXOFtcYJoWjGaxuBT
Bn5iyQMD4r6nYHoVoqkyqWDHTBh+p2fKrsyFiarjluiz821jnRY=
=NqWy
-----END PGP SIGNATURE-----

--nextPart12028771.XzEh3oFhZC--

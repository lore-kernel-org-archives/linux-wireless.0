Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38506 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933919AbdCVHVF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 03:21:05 -0400
Received: by mail-wm0-f52.google.com with SMTP id t189so28842892wmt.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Mar 2017 00:20:31 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: Rob Herring <robh@kernel.org>
Cc: ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        ext.waldemar.rymarkiewicz@tieto.com,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 1/2] dt: bindings: add new dt entry for ath10k calibration variant
Date: Wed, 22 Mar 2017 08:20:25 +0100
Message-ID: <5711518.JB9VTipMpE@bentobox> (sfid-20170322_084019_803846_D501FBA1)
In-Reply-To: <CAL_JsqKSBA8WcR9Q8+6+kVfYoPggZ83yQ_47LWf971Aegqv4yA@mail.gmail.com>
References: <20170310080615.22958-1-sven.eckelmann@openmesh.com> <5158144.BXJK97egUR@bentobox> <CAL_JsqKSBA8WcR9Q8+6+kVfYoPggZ83yQ_47LWf971Aegqv4yA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3699751.HZgdfZs6TO"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3699751.HZgdfZs6TO
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Dienstag, 21. M=E4rz 2017 21:56:54 CET Rob Herring wrote:
[...]
> Is this always the case? There's never some variation beyond the
> reference design that a BDF difference can't handle?

I have no knowledge about anything which isn't handled directly by the BDF
variants. But maybe Kalle can correct me here.

[...]
> > They are basically "qcom,ipq4019-wifi" + a product specific string. The=
 first
> > part is therefore the string which identifies the wifi device(s) in the
> > QCA4018/4019 SoC. The product specific string is simply the part (or a
> > variation of it) which would been used before in
> > "qcom,ath10k-calibration-variant" - just to make it "use a more specific
> > compatible string".
>=20
> It would probably be more like: "asus,rt-ac58u-wifi", "qcom,ipq4019-wifi"
>=20
> A more specific compatible is insurance that at some later point in
> time you can distinguish between 2 boards due to some difference even
> if now you believe they are "the same".
[...]
> I think the separate property is fine if this is the only one you
> envision needing to add. If there's 10 more properties, then I'd feel
> more strongly towards a board specific compatible string.

Thank you. Let's wait a little bit in case someone from QCA/Codeaurora
has some additional input.

But your comments were really helpful.

Kind regards,
	Sven
--nextPart3699751.HZgdfZs6TO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAljSJbkACgkQXYcKB8Em
e0YAtw/+JLz5VKGHwT9O6oee8MuqnlBySVGeANdvMn3FwArtMZJj0SMG2qmGd7tm
evKgmYWjzGo7ipyVbSm6d8DxmMpVmW++EPj27Tr8SqyWBkgkcI0d2Zy5/3GQGXBM
JN/sc9IbbaiSdRuKTudL9OgugtDstDnahpeYVVajEutgjFi8+ctg1x4LNy7cnia3
B+BQCtU1Z8ZHNotaTQfFt/+a9Opf88T3zz/OvVg8e5ToGL2wSympcEsKU+5elLYk
b7Kli4IKoSSGG4NQyC3/rufOm5bDCor9xO6HI8GX6cxZKI+JqfjUlQ2fcEg1JpOp
2LSPcisHaEM/B3hBPD/Er2tOCwiA93uiaIiW8QV/Jth56FDi5zH4ssUEKrdVmlfV
wmkyYXQeAZJjRU93CulTStl+XFXa3kyvIH/8StnqkwVMqxUW0vkE5+xgJdNmaiZc
sMRlss77gCzBFrJKdtakVztrnVVDIRMrLLDTdMqfjOOnxOSSJO4J7eN0ef2SSkYd
m3xgSf6PXh4qm/1M6HoMEXJb2W66ybhoYjCYm7FqqJiZN9E+Vcnj2rC/N4EyQhbz
zjHsgR3Kbp+qCTuZz1PBKRqEfdtmDYrO9c1RsAxTWDucAnusl10g89Ud+xdTJiOT
WdayFuu7glJ8DJ1K9dgAFkCfGSy7QzLy2+mgskdJafpJ8J7GjDU=
=un15
-----END PGP SIGNATURE-----

--nextPart3699751.HZgdfZs6TO--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:38674 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753279AbdCUHaG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Mar 2017 03:30:06 -0400
Received: by mail-wm0-f44.google.com with SMTP id t189so5494905wmt.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Mar 2017 00:30:05 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Rob Herring <robh@kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Waldemar Rymarkiewicz <ext.waldemar.rymarkiewicz@tieto.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 1/2] dt: bindings: add new dt entry for ath10k calibration variant
Date: Tue, 21 Mar 2017 08:29:59 +0100
Message-ID: <6837301.TG6zjU3t3l@bentobox> (sfid-20170321_083133_996829_47DFCFAE)
In-Reply-To: <CAJ-Vmok=6Tcvr4NE9+KMSQ4OSd80e1DSkgbOqFcWnFT3A1ikgw@mail.gmail.com>
References: <20170310080615.22958-1-sven.eckelmann@openmesh.com> <1919994.musG4GLznX@bentobox> <CAJ-Vmok=6Tcvr4NE9+KMSQ4OSd80e1DSkgbOqFcWnFT3A1ikgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2648746.l4ldfDgSrg"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2648746.l4ldfDgSrg
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Montag, 20. M=E4rz 2017 09:42:05 CET Adrian Chadd wrote:
> Vendors using ath10k will like this. I mean, I'm using ath10k, and I
> really like this moving forward. This will make life so much easier in
> the long run.
>=20
> Everyone else isn't using board-2.bin; they're just copying
> calibration/board data files over so the reference driver can assemble
> a board data file based on wifi0/wifi1/etc probe order, and use that.

Thanks for the feedback. But I am not sure what you mean by "this". Do you=
=20
mean the "qcom,ath10k-calibration-variant" entry or the "qcom,ipq4019-
$vendorstring" compatiblity string?

Kind regards,
	Sven

--nextPart2648746.l4ldfDgSrg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAljQ1ncACgkQXYcKB8Em
e0YWsBAA1o4nuHYUsT1JZ47Ds/vFNYPVEUh3eFvny7tyZemXxDDrGJbKfs/agMsa
f7F3GT94iR2lN67PiGhm4VbegPqOpGjEvjh0l2uKyE7Rxp8NpjC+XbdGGhsqzFNw
Dj38JlZKiMzzma0ZI8hMoxy3aTbljP/HforzZmicASvy5iq3dypEuDBZdJ8aIkrq
JaOwBxlauQniZ3EXNwim6+s3DWdk0uwJhtB+GITSONyv8sd5j6RdxQH7y2o8zqpx
ALhdx58iRr03kaQP4nPkQ+aBIs+oBCOdPR1ShAdYGryhqM3ij+DVwtjGjNk/3m0U
XDPW1T7c9Xvqf7pzKGpf8efgwDVyBriEDzLQo9oSubvFc15aLSiuqU5twnJAIjBA
IBYPlRilF8WNz2RM3o8JnVUkjIWb5JJbgCYRe2/qolOuZOxpUOjYUdr5cV7AZNVu
gWehm+ZYtIZf5ywaM8PHJsu9n7CUUHEIfowoM2igJTa1ihgr5heHUZqhctW7AZRA
bmXS39Cfc3x1XDDmLDZN3Y+9/sSQL359LBNo9pHG/un6qMM7RpFLu8sAVfDMvJsp
Zyf2eIQP/kvvVd6R9P3VFdSBIDwHCF30H7lho8gQqSl8s9XFm7RegkzZyOOy0972
hlq1tZw+HCu4pzqhejYqisVPf7Dcmn5ClQ2i6QBEPheg9LVPgvc=
=W0EM
-----END PGP SIGNATURE-----

--nextPart2648746.l4ldfDgSrg--

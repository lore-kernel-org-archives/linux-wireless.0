Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35364 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbcFGQzB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2016 12:55:01 -0400
Received: by mail-wm0-f47.google.com with SMTP id v199so28431858wmv.0
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jun 2016 09:55:01 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@open-mesh.com>
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
Cc: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	marek.lindner@open-mesh.com
Subject: Re: [PATCH 0/2] ath10k: Add support for QCA9887
Date: Tue, 07 Jun 2016 18:54:54 +0200
Message-ID: <2104766.hdzL6bzVNd@bentobox> (sfid-20160607_185509_149483_11D59CA7)
In-Reply-To: <20160607145002.GB11250@atheros-ThinkPad-T61>
References: <1568876.Six5hABE57@bentobox> <2262792.6VVL0Htyzj@bentobox> <20160607145002.GB11250@atheros-ThinkPad-T61>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1690598.lr2dr8jvs6"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1690598.lr2dr8jvs6
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Tuesday 07 June 2016 20:20:02 Mohammed Shafi Shajakhan wrote:
[...]
> [shafi] it would be helpful if you can share your basic test results (if its
> possible to share). Have you tried to bring up the card in 5ghz (or) 2ghz.
> Or both of them were tried ?

* 5GHz-only (I have no 2.4GHz capable card)
* card is able to scan
* card is able to create an AP
* data can be transferred via AP and client (bidirectional connection)
* performance was more like 15 Mibit/s for 1x1 HT20 11n devices instead of
  something like 35-40 Mibit/s

I cannot give you any more detailed, current performance test results because
they were done months ago and are most likely not relevant to describe the
current state. Please ask Kalle if you want to know why the old tests were
done many, many months ago.

Please ask Marek when you want to have tests done with the current
mac8011+ath10k.

Kind regards,
	Sven
--nextPart1690598.lr2dr8jvs6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXVvxeAAoJEF2HCgfBJntG5IYP/15UcX6SJtsbEQzdOGJB0G5z
crajFnzIw/bku25/8YLCuCeYul70M3fJfBnIpLx/cZPHO7Y8v00DFAYAXNM9saJm
V2xWavS7T3NwfIHwSlf7Qad4n51aaV8s8AZpQukolWF9bTZ5E4mA5vzohIsVBPxM
w3uyUBIxN2wJc442rmMMIP/31tFaHESTBxFhcdAQUuQ/PbSMHdNZCtUlf+8Xs4LP
a8io7tgWVUyEKofwvcJLkNJ/Y0vFMjRF+Ak+JdxBWoWOwkRbKpg9dIEu3UDbhY7P
hsmcvpIKPfSwsQwxc3g/X4MNaZhBWDwJ1jqq09qIVpUhV803CD7xkCrSZ+BUNv3H
Ic06/j6TA35YJUBEhZGEcokPYocXiL2yRkHuJPn26FCcmVhZ4uYqApm2Y23pJCRc
WOXusuTl4KQUN+5q+8LR476RmdqvMv3BgCt3+wHXg2+yrpR+nfOlX/nUnSTDZ1N/
qm0Rp6f5pjKdMQVb+wNQIj0lDCIgblL29pfSVP3EPxiMttXfOgwaErfwnvCf+2d8
XQlhb3bMLb2zGdbl9PAmSt6ft+MlFwFoVW36J+SUVvLXjeZ+c4JrvqVoBylva/Ey
AWkqaeheTzsXGXJOgjo+PpRQwwnKB1Nz3Pjlb9Xy8aN61YtzqHcu05KWdcmbXpZg
EvajAwl4FJyv0v+yBA8D
=3zJk
-----END PGP SIGNATURE-----

--nextPart1690598.lr2dr8jvs6--


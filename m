Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:54754 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751841AbeFTLeT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 07:34:19 -0400
From: Sven Eckelmann <sven@narfation.org>
To: b.a.t.m.a.n@lists.open-mesh.org
Cc: Omer Efrat <omer.efrat@tandemg.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [B.A.T.M.A.N.] [PATCH v4 3/5] batman-adv: use BIT_ULL for NL80211_STA_INFO_* attribute types
Date: Wed, 20 Jun 2018 13:34:09 +0200
Message-ID: <2698334.cOteLZxmq0@bentobox> (sfid-20180620_133428_925593_027D4883)
In-Reply-To: <1529491616-23222-1-git-send-email-omer.efrat@tandemg.com>
References: <1529491616-23222-1-git-send-email-omer.efrat@tandemg.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart14042354.XY0V1bUi97"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart14042354.XY0V1bUi97
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Mittwoch, 20. Juni 2018 13:46:56 CEST Omer Efrat wrote:
> -               if (!(sinfo.filled & BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT)))
> +               if (!(sinfo.filled &
> +                         BIT_ULL(NL80211_STA_INFO_EXPECTED_THROUGHPUT)))
>                         goto default_throughput;

Please fix the alignment:

* Found wrong alignment at net/batman-adv/bat_v_elp.c:118, was 27 but expected 23

Kind regards,
	Sven
--nextPart14042354.XY0V1bUi97
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlsqO7EACgkQXYcKB8Em
e0b8lRAApAL2fVCO1fnV4c7k9WdwjsL/zCSnhCTnfrp6LO4yQg9aMDlnxySsmDlM
UKFBMmPogfSzNlU8etLsD6BAs9GjGSwo11aynCud15JNzdr1BRWNBWAUvF6Xkavj
6x8JRk+dl3wOR8wads6X343YorA/xsv/ycwXz1Ao3cM6FQsguvhjwzZJbuoBucNc
JMRx1ClP/rEt3DQAj78Adpb7kxz3XBLrl3oF04qEasNlrwBJPUhIN1qYAUR+yt10
lwRNXp3RSSz7S/HN2uMqQC3hM06NM5CwyvnvbfeFCssZi0mhLJJ8ZUku1R180g3i
wOt4DXqNnnds2jL+47B5tU4N7JUeEKtcJr1Rni0DiWiS2MnEUKWU9uqz4/aNS/Rf
VQfik2PfRHAp/g+bWQ1XdLsV9bqOoHJcpmVqQws+pSX3ufXrdT7fJ+/k0z6wWjbG
fsq3oYkjEVGja/KHz9QMOFCKLahKP5cFMAzfvGrtFy3EwD617AQtUWpnQjBIi1n7
JpM9unkb0hUo0GQhiG73hs1Ah7rGR2cJpeFhFV6noS1//7zBVf6tVg5IBYVkSbgh
QOSNWrKwJxgUXT9aXyqeIwler6ylZp+lD9P2NWkWrHwdCKSRBxIt2ixyK2tWUzbQ
FVp3xby6N46PdMV4kX4wu+G/3gAj1OaFz/kYyJc1lCgCwEJZHRo=
=hxXo
-----END PGP SIGNATURE-----

--nextPart14042354.XY0V1bUi97--

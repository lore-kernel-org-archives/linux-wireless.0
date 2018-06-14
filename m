Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:52582 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754888AbeFNKxQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 06:53:16 -0400
From: Sven Eckelmann <sven@narfation.org>
To: b.a.t.m.a.n@lists.open-mesh.org
Cc: Omer Efrat <omer.efrat@tandemg.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [B.A.T.M.A.N.] [PATCH v2 3/5] batman: use BIT_ULL for NL80211_STA_INFO_* attribute types
Date: Thu, 14 Jun 2018 12:53:13 +0200
Message-ID: <1567584.jbsRn7ofiA@bentobox> (sfid-20180614_125324_149221_2D722F3B)
In-Reply-To: <32533954.9n15W0HXMB@bentobox>
References: <1528971137-432-1-git-send-email-omer.efrat@tandemg.com> <32533954.9n15W0HXMB@bentobox>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3740938.nihP6Ej3nQ"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3740938.nihP6Ej3nQ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi,

here are the infos which were missing and which should be included in the 
commit message

> > Since 'filled' member in station_info changed to u64

in commit 739960f128e5 ("cfg80211/nl80211: Add support for 
NL80211_STA_INFO_RX_DURATION")

[...]

Fixes: d62890885efb ("batman-adv: Accept only filled wifi station info")

> > Signed-off-by: Omer Efrat <omer.efrat@tandemg.com>


Kind regards,
	Sven
--nextPart3740938.nihP6Ej3nQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlsiSRkACgkQXYcKB8Em
e0Y4ZxAAytrpWBIfkoZ02P4q1NCrvrbhIZYhTgtAycArHZVWHIRJ3JfuXjFNTbN5
Owhhwe8wnfsNjCaB17dbkb696CCfIGJLfIOxQFkjHTMRb9SoS2fY8ELLJSGvQRrm
/mjcyY/xvQ2T8nTmN78voKEHFuemYP66qiYRKIsFu1mYHEvkoIWFrH7/rXQw7spM
hiw3H45IYn6ykASRRDX3S67fahdd/YgYj0sjrROygbbqaZqlZgiJcrJ0EsG/mT6Y
R3c+LlfQJyA/N4x3sQCzygYgPpiIXOYJ+Q92a6R6b+FEM5EAhQIsF5EaG1IT6ckW
/1a/dpmxLxi3Iu1lIZ2JFiPvV+xaxsd0i+OzMIj5GBsytzlYptLYKhk+VMadLrXK
8f1t3ONJvyzmE49OOrPjMqtBwHMqiXK6b8HImFZ13YxuixRM8zdv7BsEqTZMNxqG
F876sGLBGajzol1MjcUQL3jxKssEHv7uHsq1ndfsQ3KnjbL5X3MFTCRDAMPK1S+8
zrHDUIG04Ut/jYCoOxVdt7j46bFNCRgaUADGfnFcsI0T4qehHQcRmbL6z/E4NxaD
CMmWDBT0BIlz9u9LiYh6I1i0sYiphEkjpVMiWuSaFVQHjQfSuBjZWp1DEAHgqquz
IxEhFoi1cfw6mnRX1kGybECOc1R8vB9iP/Fn2FYoYLP0UPqh0FM=
=8VwQ
-----END PGP SIGNATURE-----

--nextPart3740938.nihP6Ej3nQ--

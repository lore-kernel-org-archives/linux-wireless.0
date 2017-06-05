Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:53066 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751321AbdFEHWQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 03:22:16 -0400
Date: Mon, 5 Jun 2017 09:22:12 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: "Tobin C. Harding" <me@tobin.cc>
Cc: linux-wireless@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org,
        kernelnewbies@kernelnewbies.org
Subject: Re: ks7010 firmware upload fail
Message-ID: <20170605072212.GB1495@katana> (sfid-20170605_092220_616978_801A5EE5)
References: <20170605025637.GA23011@eros>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0eh6TmSyL6TZE2Uz"
In-Reply-To: <20170605025637.GA23011@eros>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Tobin,

> My question is should I be digging further into the MMC code or be doing
> something else with the driver code?

So, you haven't found any branch that worked? No plain v4.9 or the
gen3-sdio branch from my tree?

Regards,

   Wolfram


--0eh6TmSyL6TZE2Uz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlk1BqQACgkQFA3kzBSg
KbZ/0w/9Ft1TYBRvHU0nitPFE6Dvi/6zITP8CReGP+B+MI/NsXeNtqrsefYCqV0l
WLDb/vO+AjNKhPy4fvpTVIyeJrQ5TWd+zRyewhos61M1zYWYbxZ0PuNyj/AL5Zer
RnVRTYHBOB3HzY+xTxidqPhER6vBAIa8Xq0DGa4gai320KhctDH4pdRa1p0Pk+nX
Y6J/VclJImYrsvRPlWhlPOFjlFe+KOJdn2vHAB8Op/WSQnH/jW9v25zUSxVj+OGw
QUJzOLbndHMM9eYVRj6EuTj2CbU22FIfF8T+jkcd5aoelYOPed4WnM9UCHJQ9KhL
QYGb1K6dO2GpKVLYpm958lIX56W8uqYphCKZbh/XKOcKktmdcRudXRCjNqwonJ6z
G978wbKrcQ8q1n93TLab/5SUCYs3th4WQVjuA7rshSRsDY5VcY+f7n5rvIsJTvLl
L2vZG9n58km1eNcKlFBKge4QI1xkV+BuMGmA1HAdEnxm/rMaJsYIzBEV4v+4HjW1
ZX6wHrwV1t+Oytfc5AIknp5BT/yBrLHS/cld7T+xL/reM+prd9glkESeAPTSWEZd
/mdJavC8vIdksXqcISZS9zDdv9h7C0O2JGnQC5Ny77NpKczsET4W29UDTHc8DkV9
ck8puuIslXhly5QOr17ekaBPvpiJTW19YAVChhuws5wgoMVjxoc=
=XKQc
-----END PGP SIGNATURE-----

--0eh6TmSyL6TZE2Uz--

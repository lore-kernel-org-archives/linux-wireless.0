Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45813 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728376AbeIQNKY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Sep 2018 09:10:24 -0400
Received: by mail-qk1-f196.google.com with SMTP id z125-v6so8495035qkb.12
        for <linux-wireless@vger.kernel.org>; Mon, 17 Sep 2018 00:44:12 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: seth.forshee@canonical.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
        Simon Wunderlich <simon.wunderlich@openmesh.com>,
        Shashidhar Lakkavalli <shashidhar.lakkavalli@openmesh.com>
Subject: Re: [PATCH 2/2] wireless-regdb: Sync DE with ETSI EN 301 893 V2.1.1 (2017-05)
Date: Mon, 17 Sep 2018 09:44:05 +0200
Message-ID: <1800591.rykpzNG4et@bentobox> (sfid-20180917_094415_321361_B37856A2)
In-Reply-To: <20180917074212.6739-2-sven.eckelmann@openmesh.com>
References: <20180917074212.6739-1-sven.eckelmann@openmesh.com> <20180917074212.6739-2-sven.eckelmann@openmesh.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6461430.fRXuHVCLLc"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart6461430.fRXuHVCLLc
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Montag, 17. September 2018 09:42:12 CEST Sven Eckelmann wrote:
[...]
> diff --git a/db.txt b/db.txt
> index 7f978e1..f406ac0 100644
> --- a/db.txt
> +++ b/db.txt
> @@ -379,7 +379,7 @@ country CZ: DFS-ETSI
>  country DE: DFS-ETSI
>  	(2400 - 2483.5 @ 40), (100 mW)
>  	(5150 - 5250 @ 80), (100 mW), NO-OUTDOOR, AUTO-BW, wmmrule=ETSI
> -	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=ETSI
> +	(5250 - 5350 @ 80), (200 mW), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=ETSI
>  	(5470 - 5725 @ 160), (500 mW), DFS, wmmrule=ETSI
>  	# short range devices (ETSI EN 300 440-1)
>  	(5725 - 5875 @ 80), (25 mW)

Grml, I had only one task.... still copied it to the wrong line

Kind regards,
	Sven
--nextPart6461430.fRXuHVCLLc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlufW0UACgkQXYcKB8Em
e0ZB4A//dEdwTK2Jpa+lIuiup4LNIh3yf9inmr+AB5ueTfdiWScjoomuKu6xHaKw
nFBg4Q1pr1lLYxR+GjZafLTvCdniMUPwnBwjJRKyeTFlK8dCu4tsOq9QPRRsGaQf
xeroN8IY8l6umyHIOWJ+qEY+rdWWeUB+nQjbjyx9zPTIs+CUROgjn4wB0joRgesL
BZJmcYVPGJCBGJwSrf2DVj2YnHVuLSuV77PFVhToZ8maAx/vEmYoj3AlNyYbfXwm
BE0BQq66tCPCnyStSdwY9Xyojy4cm5JoXfYECGphmaSdfaAW/t5LWd2AK82tmtPN
fSG25gKDIW+d4sJ3CafwL/XnQ2HQDYD+Cgkf+ZBjT7w64GlX/NXQ+omwOVfO9Edb
ehnrB0W7EUF5VowyAeqk/YWg1qgre16ao2THGU5/KFlap/L1NjPLaqGH+w7yBDe/
HOWMX3oaSOtgd785p8pN8TDM+vn00kAM7zut76pWZSPmT44W53Q5yMtkJKE2Zho/
TcIsiwCUJFrWm1J7WrQ2GDcAE5IrWnm+6fbx1xXy7fFsdfAjFw0bUMKsX82lZR7U
regpS7xhJO4SgjHMQBPAJ/VHEqgGtQAdWsFpsjAH78ZDAo6udfmCduDLBKM/hTkO
xrYd6Ubgk1K9HXeMFOyJERqtVJfkzsiXngq7yYvmT+bzDadOqIo=
=5m2m
-----END PGP SIGNATURE-----

--nextPart6461430.fRXuHVCLLc--

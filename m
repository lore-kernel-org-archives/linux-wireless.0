Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:52408 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754504AbdCWJAa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Mar 2017 05:00:30 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: ath10k@lists.infradead.org
Cc: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        ath9k-devel@qca.qualcomm.com,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] ath10k: add support for channels in licensed bands
Date: Thu, 23 Mar 2017 10:00:00 +0100
Message-ID: <1665455.SGOqsfShXJ@prime> (sfid-20170323_100200_115570_A531ED3C)
In-Reply-To: <327a5fe1-a4f2-6252-9dee-e4b6e79aa5ac@dd-wrt.com>
References: <20170316151337.24163-1-sw@simonwunderlich.de> <20170316151337.24163-3-sw@simonwunderlich.de> <327a5fe1-a4f2-6252-9dee-e4b6e79aa5ac@dd-wrt.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2035315.s67eRDaNyR"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2035315.s67eRDaNyR
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday, March 17, 2017 7:49:55 PM CET Sebastian Gottschall wrote:
> you may quickly realize that this patch cannot be a solution
> example:
> 
> -	if (channel >= 1 && channel <= 14) {
> +	if (channel >= 1 && channel <= 7) {
>   		status->band = NL80211_BAND_2GHZ;
> 
> 
> do you you really want to limit the 2.4 channels for all users?

Hi Sebastian,

you are right, this seems to be too limiting. I'll rework this part.

Cheers,
     Simon

--nextPart2035315.s67eRDaNyR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE1ilQI7G+y+fdhnrfoSvjmEKSnqEFAljTjpAACgkQoSvjmEKS
nqEx2w//Rt8uPSRTwU+sBOh9zLWPG3lzB15SjJCWE9ai3ESd2MRaDl+cGrwY2pfP
5scWcFCLpafcX4/AurXAKkpJnRx6fymT/3WEH9vp1f5D7etFvXOCf3gk89SJJPSH
lVmE8m9kbuhl1reG3y/FOAf7BlfQnaOHt/ywnrNMSfmgb51fdeFPaaoibfEfTFad
f7jSK0y2L9Qf28WW6yAzYOvnvYILikfYhdmTuBg1ZgIDHJur1n2QFgU0BUrUsAgJ
X93v+/OZYavCRJsOdOb/kbgHga60XR7eXdJwFBmSP1p+jUWGvz9RWnkgSK3CUG4d
nvl71BwwJTEydkIVLro9JJqtGMqG5sFQ5gzsrCD0JxEDYpHDOJv+7XETsqxz5dlg
F1sZDDnwbtx1uMxeruHHvnREfDqiJKZ3gl7mOLKfkicxQf4vQ1+9RDXiU2YtxjRu
vbgzx4J9gOorigCOUNLLJN14VWtCfFzjatDFykV1Tiv0xgI5j/pvmiN1fLByGf+W
gszCs5msflGabtlc36e0VJMvdjKVOWsnYLan77YuMRXrneD2Hll5kIxFjKEFlWXu
Rh/2v+y/p0EzWbaS1dj9b76OZD+qhEER5GvXxSIi9Sgt4lwXgFZzsEN/64pKDF30
4kzuBoU3KG7lTH5BmMgjS1YHpVq2wMqDRBNLb7nXdYfRIWHWjd4=
=kzqC
-----END PGP SIGNATURE-----

--nextPart2035315.s67eRDaNyR--

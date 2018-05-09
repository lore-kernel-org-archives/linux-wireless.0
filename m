Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:37986 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933383AbeEIHkt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 03:40:49 -0400
Received: by mail-lf0-f65.google.com with SMTP id z142-v6so6278614lff.5
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2018 00:40:48 -0700 (PDT)
Date: Wed, 9 May 2018 09:40:42 +0200
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Govind Singh <govinds@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Replace bit shifts with the BIT() macro for rx
 desc bits
Message-ID: <20180509074042.GA768@gmail.com> (sfid-20180509_094052_982041_42BE9CD7)
References: <20180509044804.13751-1-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
In-Reply-To: <20180509044804.13751-1-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Govind,

On Wed, May 09, 2018 at 10:18:04AM +0530, Govind Singh wrote:
> Use the BIT() macro from 'linux/bitops.h' to define the rx desc
> bit flags to have consistency with new definitions.
>=20
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/rx_desc.h | 134 +++++++++++-----------
>  1 file changed, 67 insertions(+), 67 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath10k/rx_desc.h b/drivers/net/wire=
less/ath/ath10k/rx_desc.h
> index 545deb6d7af1..b3d7c6e7ac90 100644
> --- a/drivers/net/wireless/ath/ath10k/rx_desc.h
> +++ b/drivers/net/wireless/ath/ath10k/rx_desc.h

Looks good, but please include linux/bitops.h as well.

=46rom the documentation [1]:

If you use a facility then #include the file that defines/declares
 that facility.  Don't depend on other header files pulling in ones
 that you use.


[1] Documentation/process/submit-checklist.rst


Best regards
Marcus Folkesson

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEBVGi6LZstU1kwSxliIBOb1ldUjIFAlrypfYACgkQiIBOb1ld
UjLXFhAAv7glnIKqCqkjfiSJTGRWa2Nw+lu/63edMYxlBXbWSaBpwRSLOXndMJeH
IjLhUXqHR9fKfl7/AE6Cj7YuzldpWK2l4faCeIoQ2o4HXhz03Z/cgOhAA9dMf/r8
XsGEEK8ELPOFdi8h/2BeHPcGQe6+NGv2heAPaXCRI93pdyXq0wVkIgHntG7RVX2T
SX0oYY9ZBsSo3phkMxWK3E1JXovcuy0pTVXcnqBdGEnjZodQCVe9biy15yc62T66
048wrDNOPHifN1te35VWPlw0PFLpzuFFGhiy1/966bVZgx2MGEdRdkWHjRhDS1lL
pkqm/Ce3qUGXjvAe5LPw4lhlZsqaD2uDSCBWrujrwbTIiTDrhgesDf1N2Ebnwb/S
LG+hcZpixx95bp1AJ7pzMWfstnwg2sVNpwCWa1Q21M7oV5ZPVI2mzde0nEsMxgTR
fyQHxf23rce5FifVKYFbNqDBTO6YeJ/udCaBpcLzhENBy5mVqaEbd9RBcCCr3oRE
dGyihJNIm/YX0fco7OFW2UTjWaJ3x/kL+7jicI5L/IsGBl0SlT5H0qRr3X1yqcCR
S5VIOezVznXaI/BDVl+RhDjXaEiFd6c5FptFLvu/OV/xHjcWZUdIVTB/OvW7Zaby
r7sWHWrHGBzTi5ycsKDgeDQnnqkE8ZaBO6lJHQHKikiHy1miAG4=
=1zIr
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--

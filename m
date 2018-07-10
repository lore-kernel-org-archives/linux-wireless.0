Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:39694 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933145AbeGJNlA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jul 2018 09:41:00 -0400
Received: by mail-qk0-f193.google.com with SMTP id b5-v6so9525796qkg.6
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2018 06:41:00 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc: Toke =?ISO-8859-1?Q?H=F8iland=2DJ=F8rgensen?= <toke@toke.dk>,
        simon.wunderlich@openmesh.com,
        Daniel Bailey <daniel.bailey@openmesh.com>,
        Shashidhar Lakkavalli <shashidhar.lakkavalli@openmesh.com>,
        linux-wireless@vger.kernel.org
Subject: Re: mac80211: AQM and block_tx
Date: Tue, 10 Jul 2018 15:40:53 +0200
Message-ID: <127626548.T5BRAgXPx7@bentobox> (sfid-20180710_154104_248449_31D462DC)
In-Reply-To: <51cebb7e-52cf-0421-a4c9-cad7a6f30035@codeaurora.org>
References: <2846230.fHgAC8qB8Q@bentobox> <4554238.GrJkgPgAWi@bentobox> <51cebb7e-52cf-0421-a4c9-cad7a6f30035@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1926193.0W6Nl0yShc"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1926193.0W6Nl0yShc
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Dienstag, 10. Juli 2018 18:09:37 CEST Manikanta Pubbisetty wrote:
[...]
> I am working on a patch which takes care of stopping the iTXQs after 
> detecting a radar(covering other scenarios where stopping iTXQs is 
> important)
> and there by making sure packets are not transmitted.
[...]
> https://patchwork.kernel.org/patch/10516887/

Thanks for telling me about this patch. It indeed prevents the unwanted TX 
during CSA (and thanks for the explanation in the commit message about the 
underlying problem).

Kind regards,
	Sven
--nextPart1926193.0W6Nl0yShc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAltEt2UACgkQXYcKB8Em
e0YINA//T9aU+y+f1xvonZVVLZSYUeOvOLGLbY/o/xvDKcBJiOIyt+bLFsUobUUo
7RG6qne3rsl9kbxJ7dg0sfvbJu2ElEXrhDA6qiiYf6mV6T9Y6/fvrp7oEgpNpXPc
5j3HYvnEarBhwQS71GKNY4ICe16e2OqgPFe6rnWsJ5FdaP1vib5jWfg6rAKYDDaA
9YE1xlpQGuQa4w4MNw1i05g/ejuAyrqv511sXT5oW0Ehs7czdgXGylEbZOenYYax
me0m/Ewi9pUpI1wkAYCIouzUdp6C+8un87Gre5QlMPIH7q4YPhaMaVnQl0Hfqecp
L/zPbH9IjKT4t6RafPLeu4+6l6XS47Qh1b3KtHY+EH33+izbVs0HpCwd6GReuzqa
E+0d/ZPUTKcklEhXU3SCYDGQHnJOAdihEty5uvBiQvjGHg/aYace/CKW6ew59wiL
Ice+3bsTzht6aQ9zQnyvT9ym5cy/VbqWm1DU23dpdLQ48K6uyuNh+gWQrVl1cJIh
i2eQlCEairWUTFh/TDlq9lk+jnqoB3LxHch6Fnd0vGXSOUHHXcnwNXLf339XQYPZ
jszNLQrOfK0Q0tl1jJBH7bGNBRhuwYs+FcafPCXDrljW13bI/x1wHG53hs0HC3a3
ieuiP0thcnoDLldfTGXVFIpqdWmCtJuzIinliXfVOj9qW5v1q78=
=RZQT
-----END PGP SIGNATURE-----

--nextPart1926193.0W6Nl0yShc--

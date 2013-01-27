Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:48740 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab3A0Vsv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2013 16:48:51 -0500
Received: by mail-we0-f171.google.com with SMTP id u54so1145977wey.16
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jan 2013 13:48:49 -0800 (PST)
From: Maciek Zarzycki <zarzych@gmail.com>
To: sedat.dilek@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: Possible bug in iwlwifi
Date: Sun, 27 Jan 2013 22:49:20 +0100
Message-ID: <5643712.YXEVgUjzFG@zarzych> (sfid-20130127_224855_085473_B142D295)
In-Reply-To: <CA+icZUWfjE4CWU9k9DRyQhDxB1MbgaL5WfR_B=viTLKWN5YCxg@mail.gmail.com>
References: <2709103.3nEV2q8lKr@zarzych> <97097679.G4cU4YgE3z@zarzych> <CA+icZUWfjE4CWU9k9DRyQhDxB1MbgaL5WfR_B=viTLKWN5YCxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3647665.K9a0eT7nuN"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart3647665.K9a0eT7nuN
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Sunday 27 of January 2013 22:25:16 Sedat Dilek wrote:

> I can't say much to the call-traces, but in general you should add
> your kernel-config and dmesg at least.
> An 'lspci -nnvv' (or lsusb) wouldn't hurt, too.
> 
> Check <wireless.kernel.org> on how to debug iwlwifi driver
> (documentation websites).
> 
> If you are fit in kernel-building you can try the pending patches in
> Greg's linux-stable GIT [2].
> Before that I would try the pending patch from iwlwifi-fixes GIT [1],
> it's for 3.7-stable as well.
> 
> Can you try and report?
> 
> Regards,
> - Sedat -
> 
> P.S.: IIRC iwlwifi folks have an own mailing-list?

Thanks for your answer. The iwlwifi page mentions this mailing list for bug reports. 

I'm using arch kernel. I'll compile a vanilla kernel tomorrow and also check it with the two sets of patches that you mentioned and report back. I've also just stumbled upon docs on how to report wireless related bugs. Sorry for not following them with my first email.

-- 
Maciek Zarzycki
--nextPart3647665.K9a0eT7nuN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJRBaDlAAoJELQoTSk9p7WNWIIH+wUFdAtF5MIZR1BhTKPsDyLk
87RLNH+0zhZ1AxF1FrojJNIfBGAjIY++FhcqNa4lTACI5q0NuIWfLcK6fxuQLSrx
RPuJtSAwbfgTGwZU4GuyP4i43BN/Gp9SEaoYWFKaZRco/aoWUkSjhRO6ZOtcNrLc
hf6bNMs0BmVy2XM+ZPrsECuDvqecIfjaa0YKv93UXN7n//nOITqmoNYhDB5esm9a
8O2zbqI+oVWI6GZPdOcDMqZPhNcnR2fMCsnZvpqpznRvTbbWNEzY4tuAG4l2C5CJ
iyX+MkKJUDsfsZ1RfKJQHS7ocgS3j+6EqqPT+V7yXvI5VfvpV2PXXwmoFPnniC4=
=TKK1
-----END PGP SIGNATURE-----

--nextPart3647665.K9a0eT7nuN--


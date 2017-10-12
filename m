Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:40404 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbdJLSfK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 14:35:10 -0400
Date: Thu, 12 Oct 2017 19:35:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Wireless <linux-wireless@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the wireless-drivers-next tree with
 the wireless-drivers tree
Message-ID: <20171012183505.oo77lgdbmqjevsuo@sirena.co.uk> (sfid-20171012_203600_168442_0C2857C9)
References: <20171012172512.tlsdjhppfz2hu4vr@sirena.co.uk>
 <1507832196.5497.1.camel@intel.com>
 <20171012182114.fdeiv67ebx7c63te@sirena.co.uk>
 <1507832866.5497.2.camel@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="asnvqr4utlul26yr"
In-Reply-To: <1507832866.5497.2.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--asnvqr4utlul26yr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 12, 2017 at 09:27:46PM +0300, Luciano Coelho wrote:
> On Thu, 2017-10-12 at 19:21 +0100, Mark Brown wrote:

> > I may have confused the trees when I was pasting things in, the
> > commits
> > are filled in by hand.

> Ah, okay.  But still, if the same patches conflicted twice, why wasn't
> there only one occurrence with both conflicts at once?

With trees like this that don't coordinate with their fixes branch there
are frequently multiple conflicts introduced so I generally report
things file by file without even looking at the new ones.

--asnvqr4utlul26yr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlnftdgACgkQJNaLcl1U
h9AfLgf/aduXqP0wdS/yJxXiRI1tNUgfZbHv/WtnL/W7momqW/sF/MdEUlW/MSoD
5UcW5jqGhOZgJjzIJPG5cqMk+9r7DscGEuLOINnb92PM53XBn9BzFGJJnSW52ox4
3PegkyVJHiyeJYSqhEfgh4r1/Y78SX0wl+fc28/GFM5C+DqSuMG95ByxKHjX2hSc
LxuV//HC4nqidznHHoH4AL95ablja81j8JVvmlfByfG8WTkH9mvav5Jr8FqVJkUw
+FmuJEybX0LeRQaVRTklkc4R1CQQTUfs+KX1Jl3NyzADmxx7x9FLrsBe3ODcadII
dhgs1pxwRuurpZ4a0VRTBf2SUgJhsA==
=GPh8
-----END PGP SIGNATURE-----

--asnvqr4utlul26yr--

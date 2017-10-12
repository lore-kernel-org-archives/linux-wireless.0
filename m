Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:46508 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752452AbdJLTMZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 15:12:25 -0400
Date: Thu, 12 Oct 2017 20:12:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Luca Coelho <luca@coelho.fi>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Wireless <linux-wireless@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the wireless-drivers-next tree with
 the wireless-drivers tree
Message-ID: <20171012191215.hstb7oapb7gcemsf@sirena.co.uk> (sfid-20171012_211259_766937_618D4A44)
References: <20171012172512.tlsdjhppfz2hu4vr@sirena.co.uk>
 <1507832979.5497.4.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mmucsx4ii4livhqa"
In-Reply-To: <1507832979.5497.4.camel@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--mmucsx4ii4livhqa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 12, 2017 at 09:29:39PM +0300, Luca Coelho wrote:
> On Thu, 2017-10-12 at 18:25 +0100, Mark Brown wrote:

> > @@@ -382,7 -371,9 +384,8 @@@ struct iwl_cfg=20
> >   	    use_tfh:1,
> >   	    gen2:1,
> >   	    cdb:1,
> >  -	    ext_nvm:1,

> nvm_type seems to be missing from here?

Oh bother.  Either my error or git's...  but it does seem to be
building so I'm a bit confused about what's going on there.

--mmucsx4ii4livhqa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlnfvo4ACgkQJNaLcl1U
h9BJ8wf/ZXUID+Vz81/XckoSgZCc15JQqd2rTmIy8IPcb/BNam6fmle6Z0zT9sZf
4580E2jIePjzHT+k2D874e9FMkEZ/mFOzzvcf1E2BxUeEglOgdux5UR6w71lQu5h
lATnbBInyzB53z7FuF7dtr570Xzx74sOxu7zzLXBGegcE1bbH6r1faqMHHVpPqP2
nOowtvNlJaVZVFHueQmU4Uj5n46mYPCituCHBUc/l95bok5L/1e+uVGG6x4q4Ir8
2RJ91MaVF5N1qH1ODbJFWvSHddA5rstnC+2IxpLx96FJbOkXl3+RbXXOmMFWycLT
5APpSuk+/atc/Qmzb5shG8sXRWyfcA==
=3k+x
-----END PGP SIGNATURE-----

--mmucsx4ii4livhqa--

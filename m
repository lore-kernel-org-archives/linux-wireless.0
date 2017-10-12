Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:53702 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753089AbdJLS7w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 14:59:52 -0400
Date: Thu, 12 Oct 2017 19:59:44 +0100
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
Message-ID: <20171012185944.bip4cdk7bd4d6mpc@sirena.co.uk> (sfid-20171012_210103_189042_2B12FC7F)
References: <20171012172512.tlsdjhppfz2hu4vr@sirena.co.uk>
 <1507832196.5497.1.camel@intel.com>
 <20171012182114.fdeiv67ebx7c63te@sirena.co.uk>
 <1507832866.5497.2.camel@intel.com>
 <20171012183505.oo77lgdbmqjevsuo@sirena.co.uk>
 <1507834251.5497.7.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dxkv6zku46djjjwh"
In-Reply-To: <1507834251.5497.7.camel@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--dxkv6zku46djjjwh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 12, 2017 at 09:50:51PM +0300, Luca Coelho wrote:
> On Thu, 2017-10-12 at 19:35 +0100, Mark Brown wrote:

> > With trees like this that don't coordinate with their fixes branch
> > there
> > are frequently multiple conflicts introduced so I generally report
> > things file by file without even looking at the new ones.

> Sorry for the trouble.  But how do you suggest that we "coordinate our
> fixes branch"? Merge fixes into the main tree?

That'd be easiest for me!  It's not of necessity a problem if the
conflicts are easy enough to resolve if you just let things get merged
in -next, it's just more an observation that that's a thing that happens
and that this is how I cope with it.  Stephen may do things a bit
differently.

--dxkv6zku46djjjwh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlnfu58ACgkQJNaLcl1U
h9Agbgf+JCTiMdJFZkbB40TESlxuDud49U0BFuEeE+xV/YerWgNPficqlgExH1Hp
vKhP9StPFWO/ixt7NnPp+D3cuHE3XSFbVRL4kN79uZRDh1QFRDib8yfMlUMm5/be
hgSYcHlwwb0oum8J2h7aNQrTbqx/CpyHP0vB47ARf2dJhxKD+OArg9PZ1lfpdzW9
ZQ7WVtF7LfEvqMGRhdycctczmn8jZgCMxAKwIjDIqcEutBFGbSwPge2JPRt5MZD9
YRvhUGHyuvQ5LWT0YIJn0zuKJGH9S6+uLZVO6RExd5D4M+TOy0iZcFqo7ooJFxUI
XRg0MOSFMveqtW6jCK+8XybuEybv0g==
=s2NH
-----END PGP SIGNATURE-----

--dxkv6zku46djjjwh--

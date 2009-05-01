Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:56707 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbZEAHLj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 May 2009 03:11:39 -0400
Date: Fri, 1 May 2009 17:11:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: linux-next: driver-core tree build warning
Message-Id: <20090501171134.f8fa430a.sfr@canb.auug.org.au>
In-Reply-To: <20090501061118.GA19234@kroah.com>
References: <20090501152144.500e619a.sfr@canb.auug.org.au>
	<20090501054727.GB19020@kroah.com>
	<20090501061118.GA19234@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__1_May_2009_17_11_34_+1000_JE8j+fNDRYVdbdiC"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Signature=_Fri__1_May_2009_17_11_34_+1000_JE8j+fNDRYVdbdiC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, 30 Apr 2009 23:11:18 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Thu, Apr 30, 2009 at 10:47:27PM -0700, Greg KH wrote:
> > Ah crap, my bad.  I'll go fix this up, it passed my build tests, I
> > wonder why this isn't an error, I missed the warning.

I assume it is actually valid C (just not good C :-)).

> I've sent an updated version of the patch that fixes this to John and
> the wireless mailing list and updated my tree as well.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__1_May_2009_17_11_34_+1000_JE8j+fNDRYVdbdiC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn6oKYACgkQjjKRsyhoI8wKNQCfUHPGuqXD1opzCdrWiGZcweJd
sq0AnjM2yrZmKsX4LjfyEWx4TjB1O8xG
=5gJR
-----END PGP SIGNATURE-----

--Signature=_Fri__1_May_2009_17_11_34_+1000_JE8j+fNDRYVdbdiC--

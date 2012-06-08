Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:41591 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933124Ab2FHSbl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 14:31:41 -0400
Date: Fri, 8 Jun 2012 20:31:31 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Andre Heider <a.heider@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >=
 n_queues))
Message-ID: <20120608203131.01dce8e3@milhouse> (sfid-20120608_203150_358304_AEE9C0FC)
In-Reply-To: <4FD24332.3010202@lwfinger.net>
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com>
	<CAHsu+b-p1aTUG8L=5SCNB8Gqzwsm7_VA53Qf-ENPHmM5Z5C8hg@mail.gmail.com>
	<1339168452.5748.0.camel@jlt3.sipsolutions.net>
	<1339168600.5748.2.camel@jlt3.sipsolutions.net>
	<CAHsu+b_Dp-A_kC-MSofJko3hr4dYxreYQ7rrq7wzsJXVoY_5yw@mail.gmail.com>
	<4FD21C6B.5000402@lwfinger.net>
	<1339170182.5748.7.camel@jlt3.sipsolutions.net>
	<1339170287.5748.8.camel@jlt3.sipsolutions.net>
	<1339170510.5748.9.camel@jlt3.sipsolutions.net>
	<1339170742.5748.10.camel@jlt3.sipsolutions.net>
	<CAHsu+b8ZGPN3iQNGH1mdzMO6kH+F1n+qZ5cT4KMcx8bh_BP1qg@mail.gmail.com>
	<1339171159.5748.11.camel@jlt3.sipsolutions.net>
	<CAHsu+b9EgAfq6_G8xqRzf0qHkmyQnvs7j=g4wWcSVJXstAz4mw@mail.gmail.com>
	<4FD22727.7000500@lwfinger.net>
	<1339172904.5748.18.camel@jlt3.sipsolutions.net>
	<20120608183339.78a7fcbd@milhouse>
	<4FD239AA.9090708@lwfinger.net>
	<20120608201053.48548a11@milhouse>
	<4FD24332.3010202@lwfinger.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4Ae_gD3iPOpWmrUayqsW0GU"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/4Ae_gD3iPOpWmrUayqsW0GU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 08 Jun 2012 13:23:46 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> On 06/08/2012 01:10 PM, Michael B=C3=BCsch wrote:
> > On Fri, 08 Jun 2012 12:43:06 -0500
> > Larry Finger <Larry.Finger@lwfinger.net> wrote:
> >
> >> On 06/08/2012 11:33 AM, Michael B=C3=BCsch wrote:
> >>>
> >>> Larry, did you check with PIO?
> >>
> >> No, I only used DMA. With the latest patch, compilation is Ok, and DMA=
 works for
> >> both kinds of firmware, while PIO fails for both.
> >
> > Does PIO even work without that patch and with prop-firmware?
>=20
> No. That seems to be a different bug.

That's nice. Could you probably bisect it? It used to work at some point.

PS:
I'm sorry that I'm not of much help these days, because I currently
don't have a working b43 device around :)

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/4Ae_gD3iPOpWmrUayqsW0GU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP0kUDAAoJEPUyvh2QjYsO99wQANdCz5Y3Z08IDNqvxPKa5cJ+
92eOGw7PrQW84+smTszyjEUgn6mKu871h0b05XFVKL+N4LqOJiMFBE/c5f7AbxWo
g/HzkC3vh4fB+Af6LzdJvjNGXHC6TTEcFaDK9g1V8az2+ap9fvwEdmK+3aVxRFoJ
4L6COSijRcFiXa99UsbvTRYkX28zajxVn4JL1bhxDHdxauTlCAmAoYGpJTA7HRRi
t1ZtoEZqfG8/vEfJECje22noIL+bdlyN9qde2C5jZOJ8TagQW8TGVeBxbJTAIShr
KSS4/9gv+9rwNUjUtWkU4EXFD5Agg9YwlRz9QVXhTxBCrMtjrhBiXKJCjYY0iRKL
tXXnSqu0QoBZWfWg0P8ugjqgEegZ2BSdZU7woNnucwpRmR7qTtUBpfZNpNbpl3Af
NlrgCDCKqNWfiWQvFRxSTpMeMcSlTCsK4VTjbzoFm5BIfw+vRPe/n7+bRPSgdazy
iN3GqNaOSLeJ/Ptr31YIIqDeqlnYiuTYU5Cc+NfrBCHXH2kbfDVHQPBFKErbT13h
h9z7UN38WfFZhPjPbP0Y3asKiZ6YQuounpU1xoRyUOld9QtgCLBCixrrW4V39DxD
JLhYHwFzlaADRhDNgydC8/9dzVW+Mo2dhFHRsX5EidKNjJlvdnQuurMF4a5qzuwV
wsPjg5/Koqm8uC/jCEvn
=jDFC
-----END PGP SIGNATURE-----

--Sig_/4Ae_gD3iPOpWmrUayqsW0GU--

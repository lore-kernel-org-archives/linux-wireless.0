Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43030 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbXF0N5T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2007 09:57:19 -0400
Subject: Re: libertas warnings on ppc64
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1182949470.22423.5.camel@xo-13-A4-25.localdomain>
References: <1182870019.3703.10.camel@johannes.berg>
	 <1182949470.22423.5.camel@xo-13-A4-25.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+yoY+0vsytYHBYlNFo+b"
Date: Wed, 27 Jun 2007 15:57:28 +0200
Message-Id: <1182952648.4769.14.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+yoY+0vsytYHBYlNFo+b
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-06-27 at 09:04 -0400, Dan Williams wrote:
> On Tue, 2007-06-26 at 17:00 +0200, Johannes Berg wrote:
> > drivers/net/wireless/libertas/debugfs.c: In function
> > =E2=80=98libertas_getscantable=E2=80=99:
> > drivers/net/wireless/libertas/debugfs.c:85: warning: format =E2=80=98%0=
8llx=E2=80=99
> > expects type =E2=80=98long long unsigned int=E2=80=99, but argument 4 h=
as type =E2=80=98u64=E2=80=99
> > drivers/net/wireless/libertas/debugfs.c:85: warning: format =E2=80=98%0=
8llx=E2=80=99
> > expects type =E2=80=98long long unsigned int=E2=80=99, but argument 4 h=
as type =E2=80=98u64=E2=80=99
> >=20
> > Maybe these were addressed by the current pull request? Thought I'd let
> > you know in any case.
>=20
> Are you using 'upstream-fixes' or 'libertas'?  I just built
> 'upstream-fixes' Monday on a 64-bit machine and came up with no such
> warnings when setting KBUILD_VERBOSE=3D1 before doing the build.

I thought I was using wireless-dev but I was actually using Linus's
tree, confusion about my build here :)
I guess you fixed these then. I also saw another warning about a
constant that was too large but I forgot what it was. I'll report back
whenever your new code makes it in.

johannes

--=-+yoY+0vsytYHBYlNFo+b
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGgmzI/ETPhpq3jKURAjeRAJ96/C/nxMWSlI/+5TXb3Kei/qLs2QCfZnYS
INnH9xDgdK8ceOve51rcGGg=
=Sv71
-----END PGP SIGNATURE-----

--=-+yoY+0vsytYHBYlNFo+b--


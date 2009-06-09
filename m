Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50807 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759032AbZFIJbI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 05:31:08 -0400
Subject: Re: [PATCH] sony-laptop: no need to unblock rfkill on load
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattia Dongili <malattia@linux.it>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux acpi <linux-acpi@vger.kernel.org>
In-Reply-To: <20090609092112.GE7682@kamineko.org>
References: <4A2CE86F.9040209@tuffmail.co.uk>
	 <1244457418.18863.8.camel@johannes.local>
	 <20090608224915.GA4583@kamineko.org> <4A2E1DE3.4020509@tuffmail.co.uk>
	 <20090609092112.GE7682@kamineko.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NlYtVYRFLe8IqeYQ4aWp"
Date: Tue, 09 Jun 2009 11:30:34 +0200
Message-Id: <1244539834.4672.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NlYtVYRFLe8IqeYQ4aWp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-09 at 18:21 +0900, Mattia Dongili wrote:

> > It just bothered me because I was effectively reverting a recent commit=
. =20
> > I figuired I should let you know.  In case it didn't work, when it was=20
> > merged you'd know why I did it and who to blame.  But there is always G=
it=20
> > history for that :-).
>=20
> Errm... now that I look at that patch more closely, the code you're
> modifying is not upstream either.
> Anyway thanks for the ping, I'll take a look at what's going on in the
> wireless-testing tree ;)

Sorry, I guess I forgot to copy you on the rfkill rewrite. Basically
I've rewritten the rfkill APIs and ported sony. Bug
http://bugzilla.kernel.org/show_bug.cgi?id=3D13458 is related to that too.

johannes

--=-NlYtVYRFLe8IqeYQ4aWp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKLiu3AAoJEODzc/N7+Qma9f8QALSo7jV5bLOworPnSP8+vaVM
y+VtSv5USPstYTaI+J4tictJfAQbZOQmekWhE+sklq5BclfXYt/6pkVtBkm74F9C
ll2SRBoDb6Kw1PGfSt3Wflcq5aU5WiMWkRWzzn6pDj1QiI28Des3jffLFj4/hAZl
9fBgyFdI+V8j3zkBBgFcNx2wkTJIp9gUG3J8dzXvY6+AdkzjHKPcaIxu3VPwMajy
XEAPX4T6Ga6KxsTc91EIdgrnn3sdG+9w9j0ddeNg+mdDFo5tcG+qTNwIvEhAoAFE
nqjQwCF6VVm1sM+faEqtgNWsLQ7SySAuuFaQ+DbgpbmEoi9Y1mIkxlzT1B2Uc5p5
jnTdCNDcUt6fMdSYpAw9D1E22aTcENu0FheuZZ0v4NTQvMM13DIOaiL4K+CJ3DBa
kj/+8MeWoO7kGI/bIK+iO/td+SRt91bnPkumqH5kpab2nrbmAci5ON6araxCktiZ
VQtHgBs18okYSh21ewOU2FvhmOYG9FIco4cqg+o8WukYobBeT8RxY1L1W01n5Qg8
o4DBhS2CKQg4Ea/Jbr9rkYtazQ6axU/JoGDQqsk13ODHfX+4ysxbhr8qDzhmnZma
te6QeVjodRTPg/Tiz8/0W+RDdoedirdO/dkUm2NoUT9L0II8zlKP8Rio25jUcGkF
AL8OmP09ReXRLrCmtAKI
=rVdO
-----END PGP SIGNATURE-----

--=-NlYtVYRFLe8IqeYQ4aWp--


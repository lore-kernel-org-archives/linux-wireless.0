Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p15132773.pureserver.info ([217.160.209.225]:36367 "EHLO
	smtp.chost.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932345Ab1EMN0c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 09:26:32 -0400
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	devel <devel@lists.laptop.org>, Dan Williams <dcbw@redhat.com>,
	John@xo15-sascha.sascha.silbe.org,
	W.Linville@xo15-sascha.sascha.silbe.org, <linville@tuxdriver.com>,
	libertas-dev <libertas-dev@lists.infradead.org>,
	netdev <netdev@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add libertas_disablemesh module parameter to disable mesh interface
To: Randy Dunlap <rdunlap@xenotime.net>
In-reply-to: <20110511100030.cad34893.rdunlap@xenotime.net>
References: <1305118354-17337-1-git-send-email-silbe@activitycentral.com> <20110511100030.cad34893.rdunlap@xenotime.net>
Date: Fri, 13 May 2011 15:26:24 +0200
Message-Id: <1305292756-sup-4842@xo15-sascha.sascha.silbe.org> (sfid-20110513_152636_492231_8B023F84)
MIME-Version: 1.0
From: Sascha Silbe <sascha-ml-reply-to-2011-2@silbe.org>
Content-Type: multipart/signed; boundary="=-1305293187-827477-1562-6606-12-="; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1305293187-827477-1562-6606-12-=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Excerpts from Randy Dunlap's message of Wed May 11 19:00:30 +0200 2011:
> On Wed, 11 May 2011 14:52:34 +0200 Sascha Silbe wrote:
> =

> > This allows individual users and deployments to disable mesh support =
at
> > runtime, i.e. without having to build and maintain a custom kernel.
> =

> I guess a user could want to do this on a per-driver basis, but ISTM th=
at
> it would be better to be something like a sysctl that applies to all (w=
ireless)
> drivers.

AFAIK libertas is the only driver with a mesh implementation based on an
outdated 802.11s draft. To clarify, we could rename the parameter to
lbs_disable_olpcmesh (or just disable_olpcmesh).
Disabling 802.11s (latest draft) based mesh support is a separate
matter.

Sascha

-- =

http://sascha.silbe.org/
http://www.infra-silbe.de/

--=-1305293187-827477-1562-6606-12-=
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.1.0beta1 (GNU/Linux)

iQEcBAEBCgAGBQJNzTGAAAoJELpz82VMF3DaJHYH+gMFPvB8brmrYbDVbteoIl+5
aUQ43A9MxtJKDFXr/51azfBFxAVu7JSxhHA+I1U/lY3xjubqyslOObZ7sOnEh9iP
lAP1nyjNNLNqZblwu5uPh7Z81Kz7cl4RLF4Li7dHc9Xq7Ewy/o6TQeOCPhHt/QAm
eBlNEWXIbZSc5yRYD7HfTp+3enDKE6I/Wmj+bB+vL6mOq23yisx5E93tifZaNeNx
etFGiOq35kUBZUjm7ibYcDgx+kDN01IbKynodHSFE4PPC64nmYRv02amR+bpl2QF
67j4YNZCnAsqHdWcivHHfJ1j11c35TTmX4tQqOSu02qSfoWTxvoJxvMJjIhRd9o=
=SSLj
-----END PGP SIGNATURE-----

--=-1305293187-827477-1562-6606-12-=--

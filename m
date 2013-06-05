Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht1.myhostedexchange.com ([69.50.2.37]:38844 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753339Ab3FEKKj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 06:10:39 -0400
Date: Wed, 5 Jun 2013 12:08:42 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: Antonio Quartulli <ordex@autistici.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] nl80211: allow sending CMD_FRAME without specifying
 any frequency
Message-ID: <20130605100842.GC2349@open-mesh.com> (sfid-20130605_121043_248833_4EF2EE3E)
References: <1370241587-2609-1-git-send-email-ordex@autistici.org>
 <877gi8khyi.fsf@kamboji.qca.qualcomm.com>
 <20130605095311.GA2349@open-mesh.com>
 <87y5aoj2ji.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="z4+8/lEcDcG5Ke9S"
In-Reply-To: <87y5aoj2ji.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--z4+8/lEcDcG5Ke9S
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 05, 2013 at 03:05:21AM -0700, Kalle Valo wrote:
> Antonio Quartulli <antonio@open-mesh.com> writes:
>=20
> > On Wed, Jun 05, 2013 at 02:47:01AM -0700, Kalle Valo wrote:
> >> Antonio Quartulli <ordex@autistici.org> writes:
> >>=20
> >> > From: Antonio Quartulli <antonio@open-mesh.com>
> >> >
> >> > Users may want to send a frame on the current channel
> >> > without specifying it.
> >> >
> >> > Make mgmt_tx pass a NULL channel to mac80211 if none has
> >> > been specified by the user.
> >> >
> >> > Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
> >>=20
> >> Why? And what users are we talking about here? It would be nice if the
> >> commit log would give some context here for use who nothing about this
> >> patch. "Users may want" is not very informative :)
> >
> > Hello Kalle,
> > thanks for your feedback.
> >
> > Sure, I can change the commit log.
> >
> > However, I already wrote a couple of (userspace) applications which wan=
ted to
> > send a message on the current channel and the only way to do it was to =
first get
> > the current channel and then pass it when sending a CMD_FRAME via nl802=
11. Of
> > course this approach is just a bit racy :-)
> >
> > Moreover, I'm currently working on improving IBSS/RSN support in wpa_su=
pplicant
> > and sending frames on the current channel is needed.
> >
> > Do you think it is worth mentioning userspace applications like wpa_s i=
n the
> > kernel commit message?
>=20
> I don't know what others think, but to me it is. It makes it easier to
> understand why the change is made. And also do we really need the change
> or not.

Oky. Then I'll change the commit message and add these details in the next
version.

Thanks!


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--z4+8/lEcDcG5Ke9S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRrw4qAAoJEADl0hg6qKeOz5AP/0bXVaiM4VvzJXUnV/GEbU6N
fozvfviTAEkXRcA1IZz9LeYEEYnFDQH4NCj2Bohm2L7bh9Au5ptw1rZNB7RkXrjb
lYX5mU4LBmP1QfAitUpT3+L/eQuTozdosrQIdnwcVIpmdgbr5dNoSazrt79h5t9s
a9bIY6Bk/T7D6eFL9zPdfU1qVFE07di0chzcR+WFTZ6ffOmjtdEsyQ3zzp5dfJDz
pJQqFuOL3/O4RJrq3QxCmDbDQEFhnqp3MDII7HxzTtesV9/0UVgZAYLWXOqISEtc
QToJOsQzVqP8jzbDOju1gsiwVcaprU6dKU+6/5g8RdqRygU/K6mhA4XoFvnLlWZm
QokZAmPIqIsMPjM++lhwW066iDW2lSTYFXvvO+M1n4FP+dCyeEH6w7J3bui0XQvc
NQPGzgCvAxF4SpFCjDU+BYhW5mw5zySzxOFDu59MsoElzxqO44Y9yFauoJ2HWVmg
2/5tKB0YRfBnGaGrdGuII91c9dv8MJz6Qri+irSzN/jJGzSl8XWK3u88bFvqYDFh
/7YobYcjLG1RHpS/4fhHhdgLLpLkeFptjD8lRbaWKhzZC36aHpwIVGpaTqYSfLJ6
mkPh8XtqHCoaXkxaqPAVjn6tqTsVewoFv8LKXX+FtA6mzQALmqGnuAEukryyNvwY
o4D2MGPghbu3aft439yP
=nXJD
-----END PGP SIGNATURE-----

--z4+8/lEcDcG5Ke9S--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:34428 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab2H0Gna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 02:43:30 -0400
Date: Mon, 27 Aug 2012 08:42:48 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 2/2] ath9k_htc: advertise allowed VIFs combination
Message-ID: <20120827064248.GA22073@ritirata.org> (sfid-20120827_084335_998055_A5175438)
References: <1346014505-7554-1-git-send-email-ordex@autistici.org>
 <1346014505-7554-2-git-send-email-ordex@autistici.org>
 <CAGRGNgUoNnuh_23qzULJyJcvMUgNpUxFnZjaAcGj26_jrTHdeA@mail.gmail.com>
 <1346045881.3746.0.camel@jlt4.sipsolutions.net>
 <CAGRGNgXy3t5TJqY=VwKjPEH=K4XKR_Dm5qVKkmYxStYoAP3fvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
In-Reply-To: <CAGRGNgXy3t5TJqY=VwKjPEH=K4XKR_Dm5qVKkmYxStYoAP3fvQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 27, 2012 at 03:41:09 +1000, Julian Calaby wrote:
> Hi Johannes,
>=20
> On Mon, Aug 27, 2012 at 3:38 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Mon, 2012-08-27 at 09:48 +1000, Julian Calaby wrote:
> >> Antonio,
> >>
> >> On Mon, Aug 27, 2012 at 6:55 AM, Antonio Quartulli <ordex@autistici.or=
g> wrote:
> >> > This driver now advertises its allowed VIFs combinations to the mac8=
0211
> >> > sublayer.
> >> >
> >> > Other than that, practical tests shown that ath9k_htc devices allow =
an IBSS VIF
> >> > to coexist with VIF set up on other modes. This patch removes the ch=
eck which
> >> > block the creation of any other VIF whenever an IBSS one is already =
present.
> >>
> >> These two patches should really be applied in the opposite order:
> >>
> >> You should add the interface combination data (this patch) then remove
> >> the old checking code.
> >>
> >> This way there's not a window (admittedly only one patch) where the
> >> interface combinations aren't enforced.
> >
> > FWIW, it's the other way around, in that window no combinations would be
> > permitted at all...
>=20
> It's still a problem for bisection then =3D)

Shall I merge the two patches and do both the changes in one shot?

Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlA7FugACgkQpGgxIkP9cwf91gCgjiVbArfZt8CGu3DM7iL2AcJe
1XYAnA0JxN9ryK2/M93jq6OCQB37rj5V
=kpsC
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:58942 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab3FCOvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 10:51:54 -0400
Date: Mon, 3 Jun 2013 16:25:45 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] nl80211: allow sending CMD_FRAME without specifying
 any frequency
Message-ID: <20130603142545.GA1226@ritirata.org> (sfid-20130603_165156_761885_16068719)
References: <1370241587-2609-1-git-send-email-ordex@autistici.org>
 <51ACA309.60904@lri.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
In-Reply-To: <51ACA309.60904@lri.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 03, 2013 at 04:07:05PM +0200, Nicolas Cavallari wrote:
> On 03/06/2013 08:39, Antonio Quartulli wrote:
> > From: Antonio Quartulli <antonio@open-mesh.com>
> >=20
> > Users may want to send a frame on the current channel
> > without specifying it.
> >=20
> > Make mgmt_tx pass a NULL channel to mac80211 if none has
> > been specified by the user.
> >=20
> > Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
> > ---
> >  net/wireless/nl80211.c | 17 +++++++++++++----
> >  1 file changed, 13 insertions(+), 4 deletions(-)
> >=20
>=20
> Have you tested tracing or ath6kl ?

no.
For tracing I think I totally forgot to update the "prototype". For ath6kl I
have no possibility since I have no hw using that driver :/

The concern about ath6kl comes from the fact that it is a fullMAC driver?


Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRrKdpAAoJEADl0hg6qKeOeQ4P/2mBLGs+AFpp8jePiAP7CPs9
PP9/uFrmRa0PJsATdAY4XdAohmMyt5zM6r0wDoTfuQ/WGvF4xm+xBZa79Ju2o14h
qz6I0RJm0HJbijmowj9pczkFbxK292a5ylbMgbUMfLdHeoxQoFXlKWeN/fGtTl3I
1Eof14ciYPed/v46WJflWahlgGURMmOwndh3v7W0/nZb2wr1WGrUkCGi+Gh+cbny
zWfiJWmUQBGlrPgr7oNMVbGGmfEoerlB0YOs5tVLYlii/nRTTj7VI7vO1AZVHZAS
0++l/+Z2YKWLzQHGa9jove6JSfCpB7dVhL0FOvhY+5HGeuLnjB1CXV/j4SmbhuWj
70s+SyWSmqb33qQIf9sks+swOFb+wsOdGG58ctuSgK5IDaxzk02nBByt2NavOnL7
KqWnXU9qs9NzOY/Nhc50g0wAHPzdTRFae1y/40MLs7AidC8+AS8WZsqoqV+vbTcJ
7X9JGd7S9uy+DQ4qWpZcT+fwLZWzNGbcZjHIhY0d/qiVUbh7EO0B0RJ6QBA+S8SY
ecfGB0EsGkgCqHBYfX0az3OqAG6Yx64P1DUIKSiaAwwLb+l4EpM904iZWYTcvxoO
yqKGWu4wkstQa9W6EeIvxcIEyEFzf7iFkG24rGU7yX7tY0+IRBQtqvVtdfcoY+t2
Uzdufy3Be7zC2sMJ73+/
=hKmH
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--

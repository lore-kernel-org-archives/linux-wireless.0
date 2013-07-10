Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:33496 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab3GJNdp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jul 2013 09:33:45 -0400
Date: Wed, 10 Jul 2013 15:33:37 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv4 4/5] mac80211: add channel switch command and beacon
 callbacks
Message-ID: <20130710133337.GA29831@pandem0nium> (sfid-20130710_153349_246651_0FE563EA)
References: <1373394424-23298-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1373394424-23298-5-git-send-email-siwu@hrz.tu-chemnitz.de>
 <CA+BoTQniF+b0JAjiKyRApttz8Or+urYB+XCxsNFA4y87Cbry-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
In-Reply-To: <CA+BoTQniF+b0JAjiKyRApttz8Or+urYB+XCxsNFA4y87Cbry-w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2013 at 12:52:00PM +0200, Michal Kazior wrote:
> On 9 July 2013 20:27, Simon Wunderlich
> <simon.wunderlich@s2003.tu-chemnitz.de> wrote:
> > (...)
> > +       /* don't handle if chanctx is used */
> > +       if (local->use_chanctx)
> > +               return -EINVAL;
> > (...)
>=20
> This check doesn't seem to be necessary anymore (since you verify if
> the number of channel contexts is 1), or is it?

Yeah, I forgot to remove this check (same for the patch 3).

I'll wait a few days for any further comments, and resend it without this
check.

Thanks,
	Simon

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlHdYrEACgkQrzg/fFk7axbwIACbBJp+4lw4nUfBsaHA9xJ6s0Bt
xIoAoLDi0MzTug+/8w21MLh+7Z3usyY+
=zQTk
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--

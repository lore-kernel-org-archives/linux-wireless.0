Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:40434 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab1KUUhQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 15:37:16 -0500
Date: Mon, 21 Nov 2011 21:37:13 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@adurom.com>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [PATCHv3 3/3] mac80211: Add NoAck per tid Support
Message-ID: <20111121203713.GB13116@pandem0nium> (sfid-20111121_213721_187619_B27EBA8D)
References: <1321614110-32392-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1321614110-32392-4-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1321614744.10266.37.camel@jlt3.sipsolutions.net>
 <20111118123054.GA32175@pandem0nium>
 <87mxbpie8o.fsf@purkki.adurom.net>
 <1321896393.3999.53.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
In-Reply-To: <1321896393.3999.53.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 21, 2011 at 06:26:33PM +0100, Johannes Berg wrote:
> On Mon, 2011-11-21 at 19:20 +0200, Kalle Valo wrote:
> > Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de> writes:
> >=20
> > >> Isn't this missing an update to ieee80211_duration() now?
> > >
> > > Yep, I silently dropped that modification - I rather don't mess with =
stuff I
> > > don't completly understand. Keeping the duration too long shouldn't h=
urt
> > > (only performance), having it too short will have much worse effects =
=2E..
> >=20
> > Still a comment in the function about this issue would be nice. Just to
> > make sure that it's not forgotten.
>=20
> I think it should be added back -- it doesn't seem that hard? Just check
> if (qos_data && no-ack)? It's on my list but I haven't gotten around ...

Very well, I've sent another patch in reply to the PATCHv4 set - please have
a look at this one.

Thanks
        Simon

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7KtnkACgkQrzg/fFk7axYuagCgqikaXO3KJ7SfliNSZdnaK7Xk
UJgAn1aDNG/+OqD8ndxt3DdfexDjKcgm
=dV/C
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--

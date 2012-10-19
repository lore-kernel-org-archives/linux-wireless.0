Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:31686 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758580Ab2JSL2z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 07:28:55 -0400
Date: Fri, 19 Oct 2012 13:28:21 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 2/2] mac80211: implement set_mcast_rate() callback
Message-ID: <20121019112821.GD7023@ritirata.org> (sfid-20121019_132911_753724_96D4FECC)
References: <CAEFj987U5sjk-ze3Tn8bh3OFD8j=p8=ffDS8zwtWO=R3UMi6iw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="95nVhCDQCgPWiQqT"
In-Reply-To: <CAEFj987U5sjk-ze3Tn8bh3OFD8j=p8=ffDS8zwtWO=R3UMi6iw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--95nVhCDQCgPWiQqT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 19, 2012 at 07:24:34PM +0800, Yeoh Chun-Yeow wrote:
> Hi, Antonio
>=20
> > +	memcpy(sdata->vif.bss_conf.mcast_rate, &rate, sizeof(rate));
>=20
> I think that the second argument should be "rate" instead of "&rate".

Hi Yeoh,

correct. Thanks a lot!

>=20
> ---
> Chun-Yeow

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--95nVhCDQCgPWiQqT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlCBOVUACgkQpGgxIkP9cwf1dACbBOY2+4VVRjWm/YNCzNpuKFlI
MvoAni/b/rMO2HixB7nGwyrP1q2ZPOvC
=emC7
-----END PGP SIGNATURE-----

--95nVhCDQCgPWiQqT--

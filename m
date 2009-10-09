Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39367 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbZJIIGc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 04:06:32 -0400
Subject: Re: NULL pointer deref at wext ioctl (Re: [PATCH] compat-2.6:
 adding  ethtool.h to compat-2.6.31.h)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890910081714u7e1d2168u98c0ccb74915c94c@mail.gmail.com>
References: <3ace41890910071216y69b8bc9la67b8f0ce5890cd8@mail.gmail.com>
	 <3ace41890910071228i786d4097w69dc7a3dfeb64afe@mail.gmail.com>
	 <1254952886.3713.4.camel@johannes.local>
	 <3ace41890910072328n1460ee34v1fe7ca9b78eb646f@mail.gmail.com>
	 <1254995514.3713.22.camel@johannes.local>
	 <1255002647.3713.25.camel@johannes.local>
	 <43e72e890910080643h282c4bf1xf972f15f13eae755@mail.gmail.com>
	 <3ace41890910081622k7c86453dm72e5584f4adbb763@mail.gmail.com>
	 <43e72e890910081714u7e1d2168u98c0ccb74915c94c@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kDgxoEXYJENjLA3ptDOR"
Date: Fri, 09 Oct 2009 10:05:19 +0200
Message-Id: <1255075519.3713.34.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kDgxoEXYJENjLA3ptDOR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-10-08 at 20:14 -0400, Luis R. Rodriguez wrote:

> > There are some harmless warnings from using the old header, but
> > otherwise it is working as it should:
> >  CC [M]  /home/Hin-Tak/tmp-git/compat-wireless-2.6/net/wireless/sme.o
> > /home/Hin-Tak/tmp-git/compat-wireless-2.6/net/wireless/sme.c: In
> > function =E2=80=98__cfg80211_connect_result=E2=80=99:
> > /home/Hin-Tak/tmp-git/compat-wireless-2.6/net/wireless/sme.c:370:
> > warning: passing argument 4 of =E2=80=98wireless_send_event=E2=80=99 di=
scards
> > qualifiers from pointer target type
> > include/net/iw_handler.h:443: note: expected =E2=80=98char *=E2=80=99 b=
ut argument is
> > of type =E2=80=98const u8 *=E2=80=99

> The last argument to wireless_send_event() was changed to be const on
> 2.6.32, cant think of a way to avoid this warning.

Yeah, it was never modified though so the warning is harmless.

johannes

--=-kDgxoEXYJENjLA3ptDOR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKzu68AAoJEODzc/N7+Qma6NAQAL0by46YCXc4pUqx84QM6WsF
8zGNkqJ4TKIaej71brG/ZVzyvxTeHcAbVQDM1eDK4JV+3lI93wGfPG6Q0LPnSYcr
Bx/2VYZOHswYITGU4d+S2WzCq+Eek3yFdm/DNSnbBtnvJVvtU1YFPQjLChQ+LivO
FnXYt1WDZD3tDU1DNvsHtL3ePnd4qCAjXVO3R3i7KWM99RjstNSH/qbpv+AngoqG
RKdJxQzl+s5PTVqucjB2ldMucLCWxRGO5H8ljc+pL6+VHYC8KMPtqCZ58x52mlwO
AUXs9eE3PV6eYS6fD8th9RqDqBj+vg73xaf6tpyTMlJ59r40nKaBRBRpgq13s7B+
caB4xskX3RO8Jo3UDemD3Ugc1dfUX6vCuClR+E527c0YoXg5eZFiQjQ0n+JryZ+y
fExkIOEk1OJe71GByY/v4t760DpHCofyY+NpMy4z+D/h3wgMoSAYEjwVXhA+yNG5
4ekRxDpQlnrHqrtFBQRkWhOj83EOtLE6tNwloutsfLAPu57C3LKIvl4+E/+7CQdd
Oc4tQQ2uer5wPXykmfKlY4Br+20WqzGYfSpqxhTFf4rCCu1SVcSnHFPu+DHCJLzG
hYm+l94oIvDL0iLx1CYQojAd3HNSVVKfjPpM7WJPLXwBlcsiCcd+BmvAdc3fupyk
Ui1uxvjCb9fd7F/Io54t
=r4rV
-----END PGP SIGNATURE-----

--=-kDgxoEXYJENjLA3ptDOR--


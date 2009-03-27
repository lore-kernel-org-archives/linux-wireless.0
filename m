Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33696 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771AbZC0VKx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 17:10:53 -0400
Subject: Re: [PATCH] rfkill-input: remove unused code
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090327143608.GB24288@khazad-dum.debian.net> (sfid-20090327_153635_512916_55398CA9)
References: <1238159804.4452.4.camel@johannes.local>
	 <20090327143608.GB24288@khazad-dum.debian.net>
	 (sfid-20090327_153635_512916_55398CA9)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/FgvBbVEXxuyj2L+9yIm"
Date: Fri, 27 Mar 2009 16:11:52 +0100
Message-Id: <1238166712.4452.11.camel@johannes.local> (sfid-20090327_221100_026294_389029D4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/FgvBbVEXxuyj2L+9yIm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-27 at 11:36 -0300, Henrique de Moraes Holschuh wrote:
> On Fri, 27 Mar 2009, Johannes Berg wrote:
> > There's a lot of rfkill-input code that cannot ever be
> > compiled and is useless until somebody needs and tests
> > it -- therefore remove it.
>=20
> Just so that you guys know, that code *is* tested :-)

At some point :)

> I'd suggest that the code removal be done leaving a comment in place, lik=
e this:
>=20
> /* Currently, code to implement EV_SW SW_WLAN/WWAN/BLUETOOTH/etc is not
>  * in place since it was unused and was therefore removed.  Please look
>  * at past history to check how it was supposed to be done, if you need
>  * to implement handling for EV_SW.
>  */
>=20
> Because that codepath is _not_ the most obvious thing in the world to
> reimplement without hitting a pitfall, so people better look how it was d=
one
> once in time...

Works for me. Do we expect it to be needed though?

johannes

--=-/FgvBbVEXxuyj2L+9yIm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJzOy1AAoJEKVg1VMiehFYiNYQAKqOOyk5WPBshM1XfdUehBEE
TIB1twRPon4xKG7dZNYlczb0cckvRnmgURDs47fiCTWeI6V7ggYSLOKxwRNA0KpB
APzf09UMuN4Xq4sNXHdWS6ZZxG0AW5LTRqQw3yzORIYTY37svdes7BjlfilNILOi
MIvKw/mZn15lUMOZhPBNZTe0mODMmXYhSuyMDBzwJqeoT4Zd3AwpmcOeZhDwCA0D
6sa76Dw9wKolnW0WeadXjfCG5HYce5IObZTWwGAjKl0KF+xBwsfCjImWDc7vLJlZ
vzT9Vvfl33rlAqzhRLQ5d0ctqLfNbNX1q8FV08rN8Fd0u9zuWfk85i9JgaABrmdG
OJV/ikJrTz8u45OKGm9t+ZhPb5vgCc2wuhWABm7QiO21hT/NzInGhqsSQpjDsMq7
Ec42/t11UJr78FnmoxaERBCPSs6rOO7eiiu8DdjhXJ33AcnjLn8JlObrq5vf2ZdO
eHCQDBpsHStlWxhf0U0nitA8XFPd+p/jRVlCN7Uqa8ddPnEBOwvXrKyzUx8qnNHt
aru/01OnAPKZthSGb5Bk79utscrPeQl2ZTfsji4/iTpYFbKEmlzr3UKv/PJAAqN2
PORHndP8SwwFlick5068+3DxjvBhIgsg4AUO1keNptttlO74gjcEeZBSZ2nuXUps
h8kfdQAwBlwMRf04AGXj
=VYeG
-----END PGP SIGNATURE-----

--=-/FgvBbVEXxuyj2L+9yIm--


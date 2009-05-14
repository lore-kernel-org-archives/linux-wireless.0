Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48351 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbZENKBY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 06:01:24 -0400
Subject: Re: [RFT v9] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	Easwar Krishnan <Easwar.Krishnan@atheros.com>,
	Nataraj Sadasivam <Nataraj.Sadasivam@atheros.com>,
	Kathir Ganapthy <Kathir.Ganapthy@atheros.com>,
	Ponmudi Ramachandran <Ponmudi.Ramachandran@atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@atheros.com>
In-Reply-To: <9b2b86520905140258t7c169ec7k254deea5d01b6254@mail.gmail.com>
References: <1242030669.6930.10.camel@johannes.local>
	 <9b2b86520905120709v4bd00e1eo4da26e6c5f75c4ba@mail.gmail.com>
	 <43e72e890905131445s5583481bgb556a925247368db@mail.gmail.com>
	 <9b2b86520905140202y539f8b93m9669e2c8c7ffbdcd@mail.gmail.com>
	 <1242292128.10076.38.camel@johannes.local>
	 <9b2b86520905140258t7c169ec7k254deea5d01b6254@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tKN2PrOBjvNxkNnyRAGe"
Date: Thu, 14 May 2009 12:00:52 +0200
Message-Id: <1242295252.500.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tKN2PrOBjvNxkNnyRAGe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-05-14 at 10:58 +0100, Alan Jenkins wrote:

> > Very good, thank you! That means I don't have to fix anything in
> > rfkill :)
>=20
> Yep, seems so.  I'm now able to test the rfkill functionality and it
> all seems fine.  The new resume code successfully fixes the
> hibernation corner-case I brought up.  So I'm happy and you can add my
>=20
> Tested-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

Thanks.

> You should probably drop my Signed-off-by though, seeing as it no
> longer includes the eeepc-laptop resume handler I wrote.

Ok.

> Oh, and don't forget the "whitespace error" flagged by git-apply.
> scripts/checkpatch.pl will flag it up as well.   Checkpatch also says
> you shouldn't initialize "rfkill_no =3D 0" because it's a static (and
> therefore will default to zero in the absence of an initializer).

Good plan, I'll fix those, thanks.

johannes

--=-tKN2PrOBjvNxkNnyRAGe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKC+vRAAoJEODzc/N7+QmaYokP/3KeVoKBSSbRBlPNnSOzlR0z
3632qgP2o9utxR1qA3LgB7yDTwhCzO7RPmGzt9IJ+MS4a73M329cVQpieW8P/hSH
uRlJz4fZlvXd0HVf6lqGDxoNtPP9aKM2ZvGuy/R7EtgW6WlOqp9Gch10Bkgp6acm
5IKJuE1fqAMnTvBYkQBaJ/LNMYYW+qoVn7rf5JzoJDIFHVcqtF0aUkcurMqymGi+
CMjiIy4MfDhCTH+QNka9CjBLwYScyGISanrBvP4Y/YyXhdhH861lQcMedG1DyB+P
EOYexOEXYuRkx5qsSlDDtJhURq7f6ds2d5F5BEOTqw3t8KADVacTtuA0rXYYkW4f
1NUZYArTd9i+CNuuDa2o9udV6jNZArCxmybY+7jyzT6UmFKTBAg8M1Cogwq79fV+
LsKdHA24Xi6iv3D30je1bR3GDDTVtnH/j1dVr+zRB3gxGKSgDqt34zJXuOkbM6kQ
Fbx4s/Fq7Jpo8M979ypvWejkf01SHFwerXvdB7t4i8bG9P5SkMh68IxRZEQTJ723
j4i1ONzSLMplKN2/f3XES4R+9PrOCsqBusMK0reecVTQarkGszZ3WzFxy2WW0oJR
st31unj8CnsVhhZU0NyEboe09Mq71LZC+xWT1DxcpoVBeJYIvxM7xxYAtCAEOzBg
hXqJZR+j8bPrbo0bPMfY
=4YMc
-----END PGP SIGNATURE-----

--=-tKN2PrOBjvNxkNnyRAGe--


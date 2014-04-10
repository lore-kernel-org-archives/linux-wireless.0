Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55483 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758633AbaDJUNf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 16:13:35 -0400
Date: Thu, 10 Apr 2014 22:13:22 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: Andev <debiandev@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linville@tuxdriver.com,
	fariyaf@gmail.com, dan.carpenter@oracle.com, joe@perches.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] rsi: Fix a potential memory leak in
 rsi_set_channel()
Message-ID: <20140410221322.547b9888@spike> (sfid-20140410_221421_912061_8C879FC0)
In-Reply-To: <CAJUuVQ7xgRLDzwojDCdb3yhTm3HygypMLXyaRiErnVveNVz+sQ@mail.gmail.com>
References: <20140410203146.767149e7@spike>
	<CAJUuVQ5KW3v0DgwotDMow=rBvxoZKfYYD2misXbsMD6c1UaShw@mail.gmail.com>
	<20140410195402.GA17308@kroah.com>
	<CAJUuVQ7xgRLDzwojDCdb3yhTm3HygypMLXyaRiErnVveNVz+sQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/h+yLX4qGYraNGswgcq3+mcG"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/h+yLX4qGYraNGswgcq3+mcG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Apr 2014 16:01:35 -0400, Andev <debiandev@gmail.com> wrote:
> On Thu, Apr 10, 2014 at 3:54 PM, Greg Kroah-Hartman <greg@kroah.com> wrot=
e:
> > On Thu, Apr 10, 2014 at 03:46:12PM -0400, Andev wrote:
> >> Adding Greg KH,
> >
> > Why do I care about this?
> >
>=20
> I am not sure if this needs to be applied to stable too. Should I have
> cc'ed stable@?
>=20

Besides what Dan pointed out, this driver has just been pulled recently and=
 afaik
is not included in v3.14. see http://www.spinics.net/lists/netdev/msg276519=
.html

Regards,
Christian

--Sig_/h+yLX4qGYraNGswgcq3+mcG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTRvtiAAoJEKssnEpaPQKEsxQQAIgoSlR290JYz5vhF4XbqdBP
GG4cmE4ChZVoXjMtKOfUXUQhYHrk6JcieVsSFNEu96uZVORGVscO5b/v9h8ZnZFG
+NTp9AE1A56nc51VxL5mWMDuF8OVTrCOF567H6anKszg7EO6XcexeJ7eaA9qoGzM
pBID2hBCpNmNFtqUI7H9XhlFnocWU/c0AhJM7NzIqzutEctMp3/WK608nDurRRaO
7jpEVnBZX2PJIyIuMRv9fCLMbpX6zzY8TR3l3EosHfjmoZL9dDKAbIC1M2z/YALv
hsQarepssoNCB9uSpNYRrZfm9pesUlZBiBSjTAPwZlbMPoJsNbCZpT/A6jmharLR
fZkPrdMeRJrxUza/wEZAGpb9kbYZfsZrGOmVCSQZDoBWRYlW1HQS0xLXeyE6TzVX
DXlbsNHY0E8EixH/NeLvrQ5tzv1EHW47A9AKIGZwTE5aJlqveA3FSuWkwr/X1NfL
nZdpLR8XDf5HxQzQvFcmJbu7z7VdvCIz7meXdjrURfgNS1Go7DyGYsbqVtz+eCZi
61ejs3eDdiwRqOoM19I4Qjfa8vSmKTlMa2PSe9YLNtzm7Ko9A64A5K0sLQPkilJO
Ah4p67UZ4rY94aaKpeG3L4xB2iC9d1tCbSvQgMfm+BcH55ETaMI2KNcIjqr6pwmC
E1ctxUETdgQgNpPa5JRK
=++yE
-----END PGP SIGNATURE-----

--Sig_/h+yLX4qGYraNGswgcq3+mcG--

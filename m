Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44623 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbZJTAcI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 20:32:08 -0400
Subject: Re: How do you set the rate algorithm from the command line
From: Johannes Berg <johannes@sipsolutions.net>
To: Charles Gordon <digigordo@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <86201b3f0910190850g3f014abbi9e2fa3f89463e7c6@mail.gmail.com>
References: <86201b3f0910190850g3f014abbi9e2fa3f89463e7c6@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4ex1RoasDHeDctug7hGt"
Date: Tue, 20 Oct 2009 09:31:26 +0900
Message-Id: <1255998686.4475.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4ex1RoasDHeDctug7hGt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-10-19 at 11:50 -0400, Charles Gordon wrote:
> Hi,
>=20
> I'm using mac80211 in an embedded system.  I can build the driver so
> that more than one wifi rate algorithm is included, and one is set as
> the default.  It is not clear to me how to set the rate algorithm at
> run time.  Is there a command line utility that does this?
>=20
> Suppose I build the driver so that both the PID and Mistrel algorithms
> are included, and the Minstrel algorithm is the default.  How can I
> switch to the PID algorithm at run time?

You cannot (yet).

johannes

--=-4ex1RoasDHeDctug7hGt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK3QTbAAoJEODzc/N7+QmaCKcP/RenqL6V2wUh8Z/n2buSXmcB
Au2yRjAe8vcX7ia7Rzh+18LAgsdOwxMvsX2MnUO5Y0iqf68WBKSv+f2R9PHcXtqI
N9IcxorudYCfxfZYwJWMCqkKFnX670mo+NftMb+4P4g3aVROkhIk2TvVYaD1Lsiv
PvHndVHxwSrAsEwy26tZDNcrk5rVr+sT64V2vMAadpw/uCYzhje+6MDCOQVm8EnB
3Y5K7tQ0HG3gpMeHIe9i21c/FBZ8OckF+HXLPbQBhSjlEqRSgUsmPYWcvzb5P8ql
db18PT47veJ2uqOlaAd7BOnrBiPfo4cFSIwwBFwe7nXQcmMoaE96WNQoAAZNeWb8
7O4RFQR8v7m5LkfGEH426U6cRc5u2ZeVueObO0FQMXLwnHYBs0I4LtkBlZ9MYusQ
7I/1FdUvpzwcp58QWeZYMbp6rTSErhk4f97PlQQIF2nZ4jPrA7cC/7kSrn+5KNoN
sYTw7XkQTWKT48rMxAOhSU4GopZtLbDjMx3VWhhW+xaZQ5e7w7yHTGVxKqoCfaip
fRhoWs2KK62eCIDjEvJmTQ1xGVYxRUJqxl3UUJKLMAyo/ADizSmqMwSyqBvRMeRl
5HtNAw6QOOO6QxjV4PB2hj2M6PpTugfCcgGhn6VSuzr9PhDK8pwURP+ygrmoJsIb
hGUmLA3U+LNF5/zKMKGc
=M4Da
-----END PGP SIGNATURE-----

--=-4ex1RoasDHeDctug7hGt--


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:33984 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689Ab2AJS32 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 13:29:28 -0500
Date: Tue, 10 Jan 2012 19:29:24 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [PATCH 2/2] iw: remove ifdefs for mcs mask
Message-ID: <20120110182924.GD19790@pandem0nium> (sfid-20120110_192943_970070_6AF88F34)
References: <1325793490-21501-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1325793490-21501-5-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1326114339.3451.26.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fOHHtNG4YXGJ0yqR"
In-Reply-To: <1326114339.3451.26.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--fOHHtNG4YXGJ0yqR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Johannes,

On Mon, Jan 09, 2012 at 02:05:39PM +0100, Johannes Berg wrote:
> On Thu, 2012-01-05 at 20:58 +0100, Simon Wunderlich wrote:
> > These are enums, not defines. Therefore the ifdef check can never be
> > true.
>=20
> The original idea was that in nl80211.h you do
>=20
> #define FOO FOO

Oh, ok, sorry, that's right, I haven't thought about this.
>=20
> (like we already have for a few things) to trigger the ifdef, but I
> don't really care.

I could as well add it into nl80211.h, and we skip this patch, or we remove
these ifdefs - your choice. :)=20

However, I don't think we really need the ifdefs as a copy of the nl80211.h
seems to be delivered with the iw source code anyway ...?

Cheers,
	Simon

--fOHHtNG4YXGJ0yqR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8Mg4QACgkQrzg/fFk7axaC4ACeOGqdjaLPh0nXPB1HqPCKWAwA
szoAnit3xm0QSWGV1Dc2cKz8MbXwtvPv
=yLx7
-----END PGP SIGNATURE-----

--fOHHtNG4YXGJ0yqR--

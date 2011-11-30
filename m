Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:54045 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab1K3Mm5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 07:42:57 -0500
Date: Wed, 30 Nov 2011 13:42:48 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Alexander Simon <an.alexsimon@googlemail.com>,
	Marek Lindner <lindner_marek@yahoo.de>,
	Felix Fietkau <nbd@openwrt.org>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH 4/4] mac80211: handle protection mode, RIFS and ADDBA
 for HT IBSS
Message-ID: <20111130124248.GB14283@pandem0nium> (sfid-20111130_134301_775185_33D9C540)
References: <1322502917-28205-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1322502917-28205-5-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1322655375.3982.11.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p4qYPpj5QlsIQJ0K"
In-Reply-To: <1322655375.3982.11.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 30, 2011 at 01:16:15PM +0100, Johannes Berg wrote:
> On Mon, 2011-11-28 at 18:55 +0100, Simon Wunderlich wrote:
>=20
> > +	/*
> > +	 * 11.5.1.1: If the initiating STA is an HT STA, is a member of an
>=20
> 802.11-2012 will renumber clauses, please add new references as
> "802.11-2007 11.5.1.1"

Ok, I will change the references but will use 802.11n-2009 instead of 802.1=
1-2007.
This stuff is not written in 802.11-2007 after all.

>=20
> Other than that I have a feeling this patch should come before patch 3?
>=20

OK, will change the order in the next resend.

Thanks!
	Simon

--p4qYPpj5QlsIQJ0K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7WJMgACgkQrzg/fFk7axZqggCcCXHSZ+6XHMQGWnKCGri8K0ze
fW8AnA9+kmcCIk66k5edd46+7xz7hqHq
=DKJF
-----END PGP SIGNATURE-----

--p4qYPpj5QlsIQJ0K--

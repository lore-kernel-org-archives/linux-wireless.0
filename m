Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:33042 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3ACHlN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 02:41:13 -0500
Date: Thu, 3 Jan 2013 08:41:06 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, assaf@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv5 7/8] mac80211: add ap channel switch command/event
Message-ID: <20130103074106.GC20780@pandem0nium> (sfid-20130103_084115_638381_0BC19948)
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1355407113-27006-8-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1357134362.9839.33.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eRtJSFbw+EEWtPj3"
In-Reply-To: <1357134362.9839.33.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--eRtJSFbw+EEWtPj3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 02, 2013 at 02:46:02PM +0100, Johannes Berg wrote:
> On Thu, 2012-12-13 at 14:58 +0100, Simon Wunderlich wrote:
>=20
> > +	drv_ap_channel_switch(local, ap_ch_switch);
> > +	return 0;
>=20
> Why is that not allowed to fail in the driver?

Fair question. Userspace should handle this if it fails (for whatever
reason). Will change that.

Cheers,
	Simon

--eRtJSFbw+EEWtPj3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDlNhIACgkQrzg/fFk7axaprwCgsC8i22qLI14J3BT9lb15//Jy
UwYAn2Dx1BDGa9LlHMOTNeds3J8eoEsC
=xGpm
-----END PGP SIGNATURE-----

--eRtJSFbw+EEWtPj3--

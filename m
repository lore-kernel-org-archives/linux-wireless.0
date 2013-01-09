Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:38887 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757476Ab3AINPw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 08:15:52 -0500
Date: Wed, 9 Jan 2013 14:15:40 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH] nl80211: allow ad-hoc to set WMM parameters from
 outside
Message-ID: <20130109131540.GA22836@pandem0nium> (sfid-20130109_141555_731001_6310430D)
References: <1354042232-32428-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <CAJ-Vmok_UDVykup4xHCigrBbzErOhUQOZMATJ+=qkBFOHQS+Bg@mail.gmail.com>
 <1357131499.9839.19.camel@jlt4.sipsolutions.net>
 <201301021436.55010.chunkeey@googlemail.com>
 <1357137688.9839.43.camel@jlt4.sipsolutions.net>
 <20130108141328.GA18920@pandem0nium>
 <CAJ-Vmom91BS5fPas+FWsaqQwm-ZVcZckUXB2vQgoEXtKiOH6mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
In-Reply-To: <CAJ-Vmom91BS5fPas+FWsaqQwm-ZVcZckUXB2vQgoEXtKiOH6mA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 08, 2013 at 09:28:44AM -0800, Adrian Chadd wrote:
> I still populate the WME fields; I need to "fix" paying attention to
> them in the adhoc case.

Applying the EDCA parameters in the hardware and sending "standard" WME IEs
(without EDCA parameter sets) is understandable, Linux does that too.=20
But are you really sending EDCA parameters in IBSS mode within the WME IEs?=
=20
After all, STAs in infrastructure don't do this either.
>=20
> The performance loss without them is quite noticable.

I don't understand why. If you apply the default EDCA parameters/QoS parame=
ters
in the hardware, it shouldn't make a difference if you transmit EDCA parame=
ters
in your beacons or not. I'm confused. :)

Cheers,
	Simon

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDtbXwACgkQrzg/fFk7axZ2tgCfaOlq5j/uuyEFlO9wUYEVdA/B
BPEAoKI30aQ9ct5qgLsO/IgGgsGNW7me
=Kg3u
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--

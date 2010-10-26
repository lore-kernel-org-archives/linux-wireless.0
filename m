Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from liberdade2.minaslivre.org ([74.50.53.203]:51256 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab0JZTBH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 15:01:07 -0400
Date: Tue, 26 Oct 2010 16:53:42 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: seno <senada@t-online.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187b: do not do per packet TX AGC
Message-ID: <20101026185341.GA4608@barata.holoscopio.com>
References: <1282974868-22237-1-git-send-email-cascardo@holoscopio.com>
 <4C798080.8010002@lwfinger.net>
 <20100830141218.GB30864@tuxdriver.com>
 <4C7BC4D9.1010108@lwfinger.net>
 <20100830152841.GB2950@barata.holoscopio.com>
 <loom.20101026T200014-691@post.gmane.org>
 <4CC71CFF.8050004@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
In-Reply-To: <4CC71CFF.8050004@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 26, 2010 at 01:25:03PM -0500, Larry Finger wrote:
> On 10/26/2010 01:03 PM, seno wrote:
> > I tried that patch on compat-wireless-2010-10-25 (Kernel 2.6.33.7).
> >=20
> > Performance improves minimal, but thousands of errors occur in iwconfig=
 output.
> > (Tx excessive retries, Invalid misc, Missed beacon).
> >=20
> > The router also shows lots of errors=20
> > (for Received (RX) / Transmitted (TX) packets)
>=20
> I no longer remember the details of why this patch was abandoned, but I s=
uspect
> you found the answer.
>=20

It was because of the bad wording in the commit description. I was
expecting some more testing from my client before posting it again with
the wording fixed. They've been testing it and there is enough
improvement they require the patch. I don't get the thousands of errors
in iwconfig output. I can try to reproduce it here if I get more
details.

Thanks,
Cascardo.

> Larry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJMxyO0AAoJEEWxSg7udFZIUPYQALT1XfPwkzIDxlQognTFFBem
yIYwc2101SuEhxnXuUoAvsmehKsTz32Nj4jW3kqFVScocGtQzBl82DdmAe2gYCOF
8Xx82He+4jaKzJhwaiwql58XrLCzGeLLrL0N9r1mxwjcLai8EujNaFsycpMKAmTx
7HBdlK1XyiQp92t2dsMtVdgdaJXd2r+d+/WCna6gNizeYLU8C6NSkJoNG497cPYI
QZkQEUFfdVYkrVO+23ifnujHvO3KQUCIz/niqpCGnnshlc/HtpuFvsONDKcvjWCV
woCyCpzgYu3qzdRdILt6x5A7HI6jcozVsayp68p8PMsYi/9S1Tpq/6uPjOH4kmYd
wUkeEc1XsIgVC+9GfWu53jsAUfEUFjLo8yMo0I4vhN2gg/t0dhEx0pen3oEkWMx1
xkTWv29A87KJE1L7w8Xa37e2AoGF7uQWwzOpgEDnetfFHvEgUZ1PgiPwdVqqjH/j
vxDPz9BKpGElO1Li507dVUeFX9Sosbp6Aq8afC9xFuoaFlHTGbkXbrTGN1zFi4aP
hweoxGw2/fShtqg4qOGyPcpRoDfx7D96X12gO5M9QNUi0QAhvS0rfXyrFmD90kFh
MdB7kBofQm3b6kmFHhX0367EHKBQm/PJOk3Hl4LUWxGlzGp/iA+WjPIh5T0QuFXt
HwvBuS6/e2Uv9X759e3V
=QB36
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--

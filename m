Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:36908 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab3G2R2I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jul 2013 13:28:08 -0400
Date: Mon, 29 Jul 2013 19:03:39 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [RFC/RFT] fwcutter: Add firmware 6.30.163.46
Message-ID: <20130729190339.5a84a2ca@milhouse> (sfid-20130729_192811_729667_CAAEEEAE)
In-Reply-To: <1375115025-26851-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1375115025-26851-1-git-send-email-Larry.Finger@lwfinger.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/eny5.fs28XTtBBjiwZVzjgN"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/eny5.fs28XTtBBjiwZVzjgN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 29 Jul 2013 11:23:45 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Is this change worthwhile?

Why not? Doesn't hurt to have it.

> @@ -874,4 +1047,12 @@ static const struct file files[] =3D
>  		.flags		=3D FW_FLAG_LE | FW_FLAG_V4,
>  		.extract	=3D _e1b05e268bcdbfef3560c28fc161f30e,
>  	},
> +	{
> +		/* http://www.lwfinger.com/b43-firmware/broadcom-wl-6.30.163.46.tar.bz=
2 */

Could you also add the original URL here?

--=20
Michael

--Sig_/eny5.fs28XTtBBjiwZVzjgN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR9qBuAAoJEPUyvh2QjYsO4Y0QAJ76kq2HxjhITNpegayw5acC
2j1U35UVYOBuLnR37cL0y+Dsbi5IfN6C8S7QdynuNDvvsU6l7BqqndWKW9sLzVpn
Zu03OBcOuQbWlueOP3ES8swCUyjircp0t5HeTc64gK/WtqP8pxTEJcxDLi9a38yW
B0PtBnFjB4IZYBeDPtZPh+2qylflm5X/MR7Y5X+LUK0ZTB0fXGABfWpHbjsd8RdN
yoKsDmMs3eLaiQmltUGlDlrvlEuFePjw23jSEM6wIBbXn6qhxG2/QCCHUtuBdnt2
8MqrANPhQ3b297y1qDIjKHxUbYUqfD/fDHbYU0MlNnksvpWmmN4gzPuEb4f6Z8Lt
I/J7FcBZ6kCUdyj0+ojHKNGay9eTfhcJrtiw+lIpZFvn5sfgUKVqx5w56cJ+EPZd
LSQGEr2vVWwaLLU9JZ7/Ufbd1EpnclGlS43WmfadWuWY1fgYgNbgGAshWfbeRI/C
2FsHvmE0hrynzgO4WQ2oAuIqXLhsyymmoN/ohEKQXqeidjJKwjRtcFdR3/Vanycf
G8yh5Ru+MfzO3Dxi/GN+Wl23F3kdapUnkQCcNjiZ3ufZYxgzmZvVWI2DoWmQJf35
oM0eFP9GY0u83spQBuKamLzuysg+DZxF6gPSAJPnwwEI5qJ/9LFS0FMtXRN5Rutp
41I5DQ1raqJi67VWheb3
=8d7/
-----END PGP SIGNATURE-----

--Sig_/eny5.fs28XTtBBjiwZVzjgN--

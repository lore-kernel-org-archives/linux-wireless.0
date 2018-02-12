Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:38863 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752780AbeBLSxC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Feb 2018 13:53:02 -0500
Received: by mail-wr0-f172.google.com with SMTP id t94so16247640wrc.5
        for <linux-wireless@vger.kernel.org>; Mon, 12 Feb 2018 10:53:02 -0800 (PST)
Date: Mon, 12 Feb 2018 19:52:59 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Centrino Advanced-N 6235 - Microcode SW error detected
Message-ID: <20180212185259.vuhee7ojgqyjdeeo@pali> (sfid-20180212_195307_212145_E4EBAFC1)
References: <20180130194926.lg3grfffcsruiz4j@pali>
 <1518461327.30914.17.camel@coelho.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="dyy4tbpkztypk57g"
In-Reply-To: <1518461327.30914.17.camel@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--dyy4tbpkztypk57g
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Monday 12 February 2018 20:48:47 Luca Coelho wrote:
> On Tue, 2018-01-30 at 20:49 +0100, Pali Roh=C3=A1r wrote:
> > Hello,
>=20
> Hi Pali,
>=20
>=20
> > for almost 3 years I have a problem with Intel wifi card Centrino
> > Advanced-N 6235. Its firmware periodically crash and in dmesg I'm
> > seeing
> > a message "Microcode SW error detected".
> >=20
> > Problem happens independently of kernel versions (I tried 3.8, 3.13,
> > 3.18, 4.0, 4.9). Currently I'm using Debian Stretch and its 4.9
> > version.
> >=20
> > This wifi card is identified as:
> >=20
> > $ lspci -s 03:00.0 -vv
> > 03:00.0 Network controller: Intel Corporation Centrino Advanced-N 6235 =
(rev 24)
> >         Subsystem: Intel Corporation Centrino Advanced-N 6235 AGN
>=20
> [...]
>=20
> > And here is example of dmesg error flood:
> >=20
> > [26624.998823] iwlwifi 0000:03:00.0: Microcode SW error detected.  Rest=
arting 0x2000000.
>=20
> [...]
>=20
> > [26624.999013] iwlwifi 0000:03:00.0: Loaded firmware version: 18.168.6.1
> > [26624.999117] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
> > [26624.999118] iwlwifi 0000:03:00.0: Status: 0x000002CC, count: 6
> > [26624.999120] iwlwifi 0000:03:00.0: 0x000028AA | ADVANCED_SYSASSERT   =
      =20
> > [27464.823779] iwlwifi 0000:03:00.0: Loaded firmware version: 18.168.6.1
> > [27464.823903] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
> > [27464.823904] iwlwifi 0000:03:00.0: Status: 0x000002CC, count: 6
> > [27464.823906] iwlwifi 0000:03:00.0: 0x000028AA | ADVANCED_SYSASSERT   =
      =20
>=20
> [...]
>=20
> > This really looks like firmware problem. What can I do with these
> > microcode errors? Can you help me?
>=20
> Yes, this is a firmware problem.  But unfortunately this is a really
> old hardware (6 years old) and we don't support the firmware anymore.=20

Hi! That is pity :-(

> I'm sorry, but there is really nothing we can do.

So can I debug this problem myself? Is there any documentation or
resources for this?

> I hope the driver manages to recover properly and WiFi continues to
> work on your machine without much disturbance when this happens.
>=20
> --
> Cheers,
> Luca.

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--dyy4tbpkztypk57g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQS4VrIQdKium2krgIWL8Mk9A+RDUgUCWoHiiQAKCRCL8Mk9A+RD
UmqYAJ0QFpSQvHy/gJ9ZsHOABm7k/KPR4wCbBfP6yxhjLdAgNGrHCA+GVQ6Ivk4=
=v4DQ
-----END PGP SIGNATURE-----

--dyy4tbpkztypk57g--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:44084 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751604AbeA0OPD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Jan 2018 09:15:03 -0500
Date: Sat, 27 Jan 2018 15:14:59 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Gnedt <david.gnedt@davizone.at>,
        Daniel Wagner <wagi@monom.org>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Grazvydas Ignotas <notasas@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/6] wl1251: Fix MAC address for Nokia N900
Message-ID: <20180127141459.lym2mhd5md22co4q@pali> (sfid-20180127_151534_957874_C8A88E19)
References: <1482598381-16513-1-git-send-email-pali.rohar@gmail.com>
 <1510270708-14377-1-git-send-email-pali.rohar@gmail.com>
 <20180102192345.dnywuv4sapltrfrl@pali>
 <20180105014510.GB22430@wotan.suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wojkpjjfykxww634"
In-Reply-To: <20180105014510.GB22430@wotan.suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--wojkpjjfykxww634
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Friday 05 January 2018 02:45:10 Luis R. Rodriguez wrote:
> On Tue, Jan 02, 2018 at 08:23:45PM +0100, Pali Roh=C3=A1r wrote:
> > On Friday 10 November 2017 00:38:22 Pali Roh=C3=A1r wrote:
> > > This patch series fix processing MAC address for wl1251 chip found in=
 Nokia N900.
> > >=20
> > > Changes since v1:
> > > * Added Acked-by for Pavel Machek
> > > * Fixed grammar
> > > * Magic numbers for NVS offsets are replaced by defines
> > > * Check for validity of mac address NVS data is moved into function
> > > * Changed order of patches as Pavel requested
> > >=20
> > > Pali Roh=C3=A1r (6):
> > >   wl1251: Update wl->nvs_len after wl->nvs is valid
> > >   wl1251: Generate random MAC address only if driver does not have
> > >     valid
> > >   wl1251: Parse and use MAC address from supplied NVS data
> > >   wl1251: Set generated MAC address back to NVS data
> > >   firmware: Add request_firmware_prefer_user() function
> > >   wl1251: Use request_firmware_prefer_user() for loading NVS
> > >     calibration data
> > >=20
> > >  drivers/base/firmware_class.c          |   45 +++++++++++++-
> > >  drivers/net/wireless/ti/wl1251/Kconfig |    1 +
> > >  drivers/net/wireless/ti/wl1251/main.c  |  104 ++++++++++++++++++++++=
++++------
> > >  include/linux/firmware.h               |    9 +++
> > >  4 files changed, 138 insertions(+), 21 deletions(-)
> >=20
> > Hi! Are there any comments for first 4 patches? If not, could they be
> > accepted and merged?
>=20
> Since the first 4 patches do not touch the firmware API they seem fine to=
 me so
> long as the maintainer accepts them. Maybe resend and clarify you have dr=
opped
> the other ones and amend with the new tags.

According to get_maintainer.pl, Kalle Valo is maintainer.

Kalle Valo, if you do not have any other comments, can you accept first
4 patches? Or do you really need to resent first 4 patches again?

--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--wojkpjjfykxww634
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQS4VrIQdKium2krgIWL8Mk9A+RDUgUCWmyJXgAKCRCL8Mk9A+RD
UtxPAJ9u8R682FeXsOnGuZ5sdbAt0UdGhQCgkVmHq8z/ojmBAvh1XxEeTnxF6B4=
=zwVx
-----END PGP SIGNATURE-----

--wojkpjjfykxww634--

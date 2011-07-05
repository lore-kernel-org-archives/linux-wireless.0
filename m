Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from storm.alittletooquiet.net ([67.23.28.199]:47086 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab1GEOaa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 10:30:30 -0400
Date: Tue, 5 Jul 2011 10:30:29 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath9k_htc fails to initialize TL-WN721N with compat-wireless
 3.0-rc4-1
Message-ID: <20110705143029.GA28091@alittletooquiet.net> (sfid-20110705_163033_723486_E5241CA5)
References: <20110701133553.GA7125@alittletooquiet.net>
 <BANLkTikByepHZoEE2b65CrgUmpBmcxiTgw@mail.gmail.com>
 <BANLkTimUs65_Sw=pwF-J8gPjyrNcs2qnOw@mail.gmail.com>
 <20110701173237.GC7125@alittletooquiet.net>
 <20110704052410.GA1364@vmraj-lnx.users.atheros.com>
 <20110704095341.GA1380@vmraj-lnx.users.atheros.com>
 <20110705124914.GC26882@alittletooquiet.net>
 <CAD2nsn0-FQuo7bT3nb3jJLDe1XwbMw4J-Gr8qFkY5zzY1O-vxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
In-Reply-To: <CAD2nsn0-FQuo7bT3nb3jJLDe1XwbMw4J-Gr8qFkY5zzY1O-vxg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 05, 2011 at 06:59:27PM +0530, Mohammed Shafi wrote:
> >> > Please share your PID/VID.
> >
> > 0cf3:9271
> >
> >> And also for compat-wireless-v3.0-rc4-1, FW version should be 1.3 and =
fw size
> >> should be 51272. But in your case size is 51288 which is 1.2. Please u=
pgrade fw
> >> to 1.3 and test again.
> >>
> >> http://wireless.kernel.org/download/htc_fw/1.3/htc_9271.fw
> >
> > Okay. =A0I had tried both versions previously; neither seems to work an=
y better
> > than the other. =A0Here is dmesg using firmware version 1.3:
> >
> > [ =A0102.984766] Compat-wireless backport release: compat-wireless-v3.0=
-rc4-1
> > [ =A0102.984775] Backport based on linux-2.6-allstable.git v3.0-rc4
> > [ =A0103.213468] Calling CRDA to update world regulatory domain
> > [ =A0103.798281] usbcore: registered new interface driver ath9k_htc
> > [ =A0108.482070] usb 5-7: new high speed USB device using ehci_hcd and =
address 5
> > [ =A0108.643105] usb 5-7: configuration #1 chosen from 1 choice
> > [ =A0108.996663] usb 5-7: ath9k_htc: Transferred FW: htc_9271.fw, size:=
 51272
> > [ =A0109.135499] ath9k_htc 5-7:1.0: ath9k_htc: HTC initialized with 33 =
credits
> > [ =A0109.140526] ath: UNDEFINED -> AWAKE
> > [ =A0109.141769] ath: serialize_regmode is 0
> > [ =A0109.383151] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CM=
DID
> > [ =A0109.383168] ath: REGISTER WRITE FAILED, multi len: 9
> > [ =A0109.609805] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0109.609822] ath: REGISTER READ FAILED: (0x9c00, -110)
> > [ =A0109.609835] ath: Reading from EEPROM, not flash
> > [ =A0109.824058] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0109.824079] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0110.042132] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0110.042148] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0110.260786] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0110.260802] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0110.482613] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0110.482629] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0110.719736] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0110.719753] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0110.953628] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0110.953645] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0111.195035] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0111.195057] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0111.432953] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0111.432975] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0111.668211] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0111.668227] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0111.903626] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0111.903642] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0112.135695] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0112.135711] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0112.370919] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0112.370936] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0112.603491] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0112.603508] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0112.841972] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0112.841988] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0113.065412] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0113.065428] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0113.300441] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0113.300458] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0113.536889] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0113.536906] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0113.774809] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0113.774826] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0114.012001] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0114.012018] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0114.245297] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0114.245314] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0114.476929] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0114.476946] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0114.753310] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0114.753327] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0114.966595] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0114.966611] ath: Multiple REGISTER READ FAILED (count: 8)
> > [ =A0115.193618] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0115.193634] ath: Multiple REGISTER READ FAILED (count: 4)
> > [ =A0115.462402] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0115.462419] ath: REGISTER READ FAILED: (0x2000, -110)
> > [ =A0115.685667] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0115.685684] ath: REGISTER READ FAILED: (0x407c, -110)
> > [ =A0115.918681] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0115.918703] ath: REGISTER READ FAILED: (0x407c, -110)
> > [ =A0116.152756] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0116.152773] ath: REGISTER READ FAILED: (0x407c, -110)
> > [ =A0116.391881] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0116.391898] ath: REGISTER READ FAILED: (0x407c, -110)
> > [ =A0116.629244] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0116.629265] ath: REGISTER READ FAILED: (0x407c, -110)
> > [ =A0116.860197] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0116.860214] ath: REGISTER READ FAILED: (0x407c, -110)
> > [ =A0117.094108] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0117.094124] ath: REGISTER READ FAILED: (0x407c, -110)
> > [ =A0117.325535] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0117.325551] ath: REGISTER READ FAILED: (0x407c, -110)
> > [ =A0117.578615] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0117.578632] ath: REGISTER READ FAILED: (0x407c, -110)
> > [ =A0117.819951] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0117.819968] ath: REGISTER READ FAILED: (0x407c, -110)
> > [ =A0118.055933] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0118.055950] ath: REGISTER READ FAILED: (0x407c, -110)
> > [ =A0118.329876] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0118.329893] ath: REGISTER READ FAILED: (0x407c, -110)
> > [ =A0118.563992] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0118.564009] ath: REGISTER READ FAILED: (0x407c, -110)
> > [ =A0118.803279] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0118.803296] ath: REGISTER READ FAILED: (0x407c, -110)
> > [ =A0119.045193] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0119.045209] ath: REGISTER READ FAILED: (0x407c, -110)
> > [ =A0119.294820] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0119.294832] ath: REGISTER READ FAILED: (0x407c, -110)
> > [ =A0119.536403] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0119.536421] ath: REGISTER READ FAILED: (0x407c, -110)
> > [ =A0119.764358] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0119.764375] ath: REGISTER READ FAILED: (0x407c, -110)
> > [ =A0120.002647] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0120.002664] ath: REGISTER READ FAILED: (0x407c, -110)
> > [ =A0120.223089] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0120.223107] ath: REGISTER READ FAILED: (0x407c, -110)
> > [ =A0120.450418] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0120.450435] ath: REGISTER READ FAILED: (0x407c, -110)
> > [ =A0120.701625] ath: Timeout waiting for WMI command: WMI_REG_READ_CMD=
ID
> > [ =A0120.701638] ath: REGISTER READ FAILED: (0x407c, -110)
>=20
> please try to apply the attached reverting patch, if it works it may
> help us to narrow down the issue.

This does not seem to make a difference.

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.rapidrollout.com

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk4TIAUACgkQRO4fQQdv5Aw+mQCgvAooL2oTsKLuJ3t5sC5wYYy9
nY4An2k7bw8pmOETV1SCTYU+TQFaKU/1
=YaPo
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--

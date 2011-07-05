Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from storm.alittletooquiet.net ([67.23.28.199]:41421 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab1GERUX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 13:20:23 -0400
Date: Tue, 5 Jul 2011 13:20:22 -0400
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
Message-ID: <20110705172022.GB28091@alittletooquiet.net> (sfid-20110705_192029_222807_76276C10)
References: <20110701133553.GA7125@alittletooquiet.net>
 <BANLkTikByepHZoEE2b65CrgUmpBmcxiTgw@mail.gmail.com>
 <BANLkTimUs65_Sw=pwF-J8gPjyrNcs2qnOw@mail.gmail.com>
 <20110701173237.GC7125@alittletooquiet.net>
 <20110704052410.GA1364@vmraj-lnx.users.atheros.com>
 <20110704095341.GA1380@vmraj-lnx.users.atheros.com>
 <20110705124914.GC26882@alittletooquiet.net>
 <CAD2nsn0-FQuo7bT3nb3jJLDe1XwbMw4J-Gr8qFkY5zzY1O-vxg@mail.gmail.com>
 <20110705143029.GA28091@alittletooquiet.net>
 <CAD2nsn1r7cW7KZ2W_z+SURHRpaTvuC_bd42yN9S+y9JrYMkS4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GZVR6ND4mMseVXL/"
In-Reply-To: <CAD2nsn1r7cW7KZ2W_z+SURHRpaTvuC_bd42yN9S+y9JrYMkS4w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--GZVR6ND4mMseVXL/
Content-Type: multipart/mixed; boundary="uZ3hkaAS1mZxFaxD"
Content-Disposition: inline


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 05, 2011 at 08:17:13PM +0530, Mohammed Shafi wrote:
> On Tue, Jul 5, 2011 at 8:00 PM, Forest Bond <forest@alittletooquiet.net> =
wrote:
> > Hi,
> >
> > On Tue, Jul 05, 2011 at 06:59:27PM +0530, Mohammed Shafi wrote:
> >> >> > Please share your PID/VID.
> >> >
> >> > 0cf3:9271
> >> >
> >> >> And also for compat-wireless-v3.0-rc4-1, FW version should be 1.3 a=
nd fw size
> >> >> should be 51272. But in your case size is 51288 which is 1.2. Pleas=
e upgrade fw
> >> >> to 1.3 and test again.
> >> >>
> >> >> http://wireless.kernel.org/download/htc_fw/1.3/htc_9271.fw
> >> >
> >> > Okay. =A0I had tried both versions previously; neither seems to work=
 any better
> >> > than the other. =A0Here is dmesg using firmware version 1.3:
> >> >
> >> > [ =A0102.984766] Compat-wireless backport release: compat-wireless-v=
3.0-rc4-1
> >> > [ =A0102.984775] Backport based on linux-2.6-allstable.git v3.0-rc4
> >> > [ =A0103.213468] Calling CRDA to update world regulatory domain
> >> > [ =A0103.798281] usbcore: registered new interface driver ath9k_htc
> >> > [ =A0108.482070] usb 5-7: new high speed USB device using ehci_hcd a=
nd address 5
> >> > [ =A0108.643105] usb 5-7: configuration #1 chosen from 1 choice
> >> > [ =A0108.996663] usb 5-7: ath9k_htc: Transferred FW: htc_9271.fw, si=
ze: 51272
> >> > [ =A0109.135499] ath9k_htc 5-7:1.0: ath9k_htc: HTC initialized with =
33 credits
> >> > [ =A0109.140526] ath: UNDEFINED -> AWAKE
> >> > [ =A0109.141769] ath: serialize_regmode is 0
> >> > [ =A0109.383151] ath: Timeout waiting for WMI command: WMI_REG_WRITE=
_CMDID
> >> > [ =A0109.383168] ath: REGISTER WRITE FAILED, multi len: 9
> >> > [ =A0109.609805] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0109.609822] ath: REGISTER READ FAILED: (0x9c00, -110)
> >> > [ =A0109.609835] ath: Reading from EEPROM, not flash
> >> > [ =A0109.824058] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0109.824079] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0110.042132] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0110.042148] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0110.260786] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0110.260802] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0110.482613] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0110.482629] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0110.719736] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0110.719753] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0110.953628] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0110.953645] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0111.195035] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0111.195057] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0111.432953] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0111.432975] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0111.668211] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0111.668227] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0111.903626] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0111.903642] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0112.135695] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0112.135711] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0112.370919] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0112.370936] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0112.603491] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0112.603508] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0112.841972] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0112.841988] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0113.065412] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0113.065428] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0113.300441] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0113.300458] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0113.536889] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0113.536906] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0113.774809] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0113.774826] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0114.012001] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0114.012018] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0114.245297] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0114.245314] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0114.476929] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0114.476946] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0114.753310] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0114.753327] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0114.966595] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0114.966611] ath: Multiple REGISTER READ FAILED (count: 8)
> >> > [ =A0115.193618] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0115.193634] ath: Multiple REGISTER READ FAILED (count: 4)
> >> > [ =A0115.462402] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0115.462419] ath: REGISTER READ FAILED: (0x2000, -110)
> >> > [ =A0115.685667] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0115.685684] ath: REGISTER READ FAILED: (0x407c, -110)
> >> > [ =A0115.918681] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0115.918703] ath: REGISTER READ FAILED: (0x407c, -110)
> >> > [ =A0116.152756] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0116.152773] ath: REGISTER READ FAILED: (0x407c, -110)
> >> > [ =A0116.391881] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0116.391898] ath: REGISTER READ FAILED: (0x407c, -110)
> >> > [ =A0116.629244] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0116.629265] ath: REGISTER READ FAILED: (0x407c, -110)
> >> > [ =A0116.860197] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0116.860214] ath: REGISTER READ FAILED: (0x407c, -110)
> >> > [ =A0117.094108] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0117.094124] ath: REGISTER READ FAILED: (0x407c, -110)
> >> > [ =A0117.325535] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0117.325551] ath: REGISTER READ FAILED: (0x407c, -110)
> >> > [ =A0117.578615] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0117.578632] ath: REGISTER READ FAILED: (0x407c, -110)
> >> > [ =A0117.819951] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0117.819968] ath: REGISTER READ FAILED: (0x407c, -110)
> >> > [ =A0118.055933] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0118.055950] ath: REGISTER READ FAILED: (0x407c, -110)
> >> > [ =A0118.329876] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0118.329893] ath: REGISTER READ FAILED: (0x407c, -110)
> >> > [ =A0118.563992] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0118.564009] ath: REGISTER READ FAILED: (0x407c, -110)
> >> > [ =A0118.803279] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0118.803296] ath: REGISTER READ FAILED: (0x407c, -110)
> >> > [ =A0119.045193] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0119.045209] ath: REGISTER READ FAILED: (0x407c, -110)
> >> > [ =A0119.294820] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0119.294832] ath: REGISTER READ FAILED: (0x407c, -110)
> >> > [ =A0119.536403] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0119.536421] ath: REGISTER READ FAILED: (0x407c, -110)
> >> > [ =A0119.764358] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0119.764375] ath: REGISTER READ FAILED: (0x407c, -110)
> >> > [ =A0120.002647] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0120.002664] ath: REGISTER READ FAILED: (0x407c, -110)
> >> > [ =A0120.223089] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0120.223107] ath: REGISTER READ FAILED: (0x407c, -110)
> >> > [ =A0120.450418] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0120.450435] ath: REGISTER READ FAILED: (0x407c, -110)
> >> > [ =A0120.701625] ath: Timeout waiting for WMI command: WMI_REG_READ_=
CMDID
> >> > [ =A0120.701638] ath: REGISTER READ FAILED: (0x407c, -110)
> >>
> >> please try to apply the attached reverting patch, if it works it may
> >> help us to narrow down the issue.
> >
> > This does not seem to make a difference.
>=20
> sorry  i found it late and Raj pointed out register write itself is
> failing and I doubt multiple register write is failing for you.
> just thinking about these two commits ... and may be try reverting the
> second one
>=20
> commit 4a22fe108e62367c10c3abeb469d6972ba3299f5
> commit 7d0d0df0eca695c83a08dc386824a9d1d7c526a4

I reverted 7d0d0df0eca695c83a08dc386824a9d1d7c526a4 and resolved conflicts =
as
best as I could (see attached patch).  I think this helps some, but there a=
re
still problems.  Here's dmesg:

[   60.933710] Compat-wireless backport release: compat-wireless-v3.0-rc4-1
[   60.933719] Backport based on linux-2.6-allstable.git v3.0-rc4
[   61.270084] Calling CRDA to update world regulatory domain
[   62.168966] usbcore: registered new interface driver ath9k_htc
[   78.359251] usb 5-7: new high speed USB device using ehci_hcd and addres=
s 5
[   78.508423] usb 5-7: configuration #1 chosen from 1 choice
[   78.813505] usb 5-7: ath9k_htc: Transferred FW: htc_9271.fw, size: 51272
[   78.950592] ath9k_htc 5-7:1.0: ath9k_htc: HTC initialized with 33 credits
[   78.955621] ath: UNDEFINED -> AWAKE
[   78.956846] ath: serialize_regmode is 0
[   78.958679] ath: Reading from EEPROM, not flash
[   79.179769] ath: Read Magic =3D 0xA55A
[   79.179783] ath: need_swap =3D False.
[   79.179794] ath: Eeprom VER: 14, REV: 13
[   79.179803] ath: Initialize ANI
[   79.179812] ath: Enable MIB counters
[   79.181827] ath: Setup TX queue: 9
[   79.181832] ath: Set queue properties for: 9
[   79.181837] ath: Setup TX queue: 8
[   79.181840] ath: Set queue properties for: 8
[   79.181844] ath: Setup TX queue: 0
[   79.181847] ath: Set queue properties for: 0
[   79.181851] ath: Setup TX queue: 1
[   79.181854] ath: Set queue properties for: 1
[   79.181857] ath: Setup TX queue: 2
[   79.181861] ath: Set queue properties for: 2
[   79.181864] ath: Setup TX queue: 3
[   79.181867] ath: Set queue properties for: 3
[   79.419609] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   79.419630] ath: REGISTER WRITE FAILED, multi len: 8
[   79.649912] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   79.649929] ath: REGISTER READ FAILED: (0x8834, -110)
[   79.878055] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   79.878072] ath: REGISTER WRITE FAILED, multi len: 8
[   80.129094] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   80.129112] ath: REGISTER READ FAILED: (0x8854, -110)
[   80.395313] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   80.395330] ath: REGISTER WRITE FAILED, multi len: 8
[   80.623382] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   80.623395] ath: REGISTER READ FAILED: (0x8874, -110)
[   80.856254] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   80.856271] ath: REGISTER WRITE FAILED, multi len: 8
[   81.101565] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   81.101582] ath: REGISTER READ FAILED: (0x8894, -110)
[   81.335080] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   81.335102] ath: REGISTER WRITE FAILED, multi len: 8
[   81.573358] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   81.573374] ath: REGISTER READ FAILED: (0x88b4, -110)
[   81.803931] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   81.803948] ath: REGISTER WRITE FAILED, multi len: 8
[   82.039197] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   82.039214] ath: REGISTER READ FAILED: (0x88d4, -110)
[   82.328374] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   82.328391] ath: REGISTER WRITE FAILED, multi len: 8
[   82.568008] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   82.568019] ath: REGISTER READ FAILED: (0x88f4, -110)
[   82.811037] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   82.811059] ath: REGISTER WRITE FAILED, multi len: 8
[   83.049456] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   83.049473] ath: REGISTER READ FAILED: (0x8914, -110)
[   83.324571] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   83.324588] ath: REGISTER WRITE FAILED, multi len: 8
[   83.566035] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   83.566052] ath: REGISTER READ FAILED: (0x8934, -110)
[   83.795421] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   83.795439] ath: REGISTER WRITE FAILED, multi len: 8
[   84.017921] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   84.017942] ath: REGISTER READ FAILED: (0x8954, -110)
[   84.248985] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   84.249002] ath: REGISTER WRITE FAILED, multi len: 8
[   84.474865] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   84.474881] ath: REGISTER READ FAILED: (0x8974, -110)
[   84.713530] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   84.713547] ath: REGISTER WRITE FAILED, multi len: 8
[   84.950195] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   84.950212] ath: REGISTER READ FAILED: (0x8994, -110)
[   85.191996] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   85.192013] ath: REGISTER WRITE FAILED, multi len: 8
[   85.439516] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   85.439529] ath: REGISTER READ FAILED: (0x89b4, -110)
[   85.689182] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   85.689199] ath: REGISTER WRITE FAILED, multi len: 8
[   85.913953] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   85.913970] ath: REGISTER READ FAILED: (0x89d4, -110)
[   86.151019] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   86.151037] ath: REGISTER WRITE FAILED, multi len: 8
[   86.429545] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   86.429562] ath: REGISTER READ FAILED: (0x89f4, -110)
[   86.748242] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   86.748259] ath: REGISTER WRITE FAILED, multi len: 8
[   86.981646] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   86.981663] ath: REGISTER READ FAILED: (0x8a14, -110)
[   87.219593] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   87.219610] ath: REGISTER WRITE FAILED, multi len: 8
[   87.457406] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   87.457423] ath: REGISTER READ FAILED: (0x8a34, -110)
[   87.696039] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   87.696056] ath: REGISTER WRITE FAILED, multi len: 8
[   87.932277] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   87.932294] ath: REGISTER READ FAILED: (0x8a54, -110)
[   88.167619] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   88.167637] ath: REGISTER WRITE FAILED, multi len: 8
[   88.446352] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   88.446369] ath: REGISTER READ FAILED: (0x8a74, -110)
[   88.673373] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   88.673390] ath: REGISTER WRITE FAILED, multi len: 8
[   88.910855] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   88.910877] ath: REGISTER READ FAILED: (0x8a94, -110)
[   89.144349] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   89.144366] ath: REGISTER WRITE FAILED, multi len: 8
[   89.363669] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   89.363685] ath: REGISTER READ FAILED: (0x8ab4, -110)
[   89.579427] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   89.579444] ath: REGISTER WRITE FAILED, multi len: 8
[   89.802272] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   89.802289] ath: REGISTER READ FAILED: (0x8ad4, -110)
[   90.035100] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   90.035117] ath: REGISTER WRITE FAILED, multi len: 8
[   90.274214] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   90.274231] ath: REGISTER READ FAILED: (0x8af4, -110)
[   90.508156] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   90.508174] ath: REGISTER WRITE FAILED, multi len: 8
[   90.744777] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   90.744794] ath: REGISTER READ FAILED: (0x8b14, -110)
[   90.986425] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   90.986443] ath: REGISTER WRITE FAILED, multi len: 8
[   91.206572] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   91.206595] ath: REGISTER READ FAILED: (0x8b34, -110)
[   91.445947] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   91.445965] ath: REGISTER WRITE FAILED, multi len: 8
[   91.680429] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   91.680451] ath: REGISTER READ FAILED: (0x8b54, -110)
[   91.916274] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   91.916291] ath: REGISTER WRITE FAILED, multi len: 8
[   92.151459] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   92.151476] ath: REGISTER READ FAILED: (0x8b74, -110)
[   92.383992] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   92.384009] ath: REGISTER WRITE FAILED, multi len: 8
[   92.613994] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   92.614016] ath: REGISTER READ FAILED: (0x8b94, -110)
[   92.850545] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   92.850562] ath: REGISTER WRITE FAILED, multi len: 8
[   93.086608] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   93.086619] ath: REGISTER READ FAILED: (0x8bb4, -110)
[   93.327099] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   93.327116] ath: REGISTER WRITE FAILED, multi len: 8
[   93.563971] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   93.563987] ath: REGISTER READ FAILED: (0x8bd4, -110)
[   93.795161] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   93.795174] ath: REGISTER WRITE FAILED, multi len: 8
[   94.033200] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   94.033216] ath: REGISTER READ FAILED: (0x8bf4, -110)
[   94.299464] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   94.299477] ath: REGISTER WRITE FAILED, multi len: 8
[   94.540808] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   94.540825] ath: REGISTER READ FAILED: (0x8c14, -110)
[   94.766436] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   94.766458] ath: REGISTER WRITE FAILED, multi len: 8
[   94.990123] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   94.990140] ath: REGISTER READ FAILED: (0x8c34, -110)
[   95.255593] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   95.255610] ath: REGISTER WRITE FAILED, multi len: 8
[   95.493251] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   95.493268] ath: REGISTER READ FAILED: (0x8c54, -110)
[   95.727716] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   95.727733] ath: REGISTER WRITE FAILED, multi len: 8
[   95.964662] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   95.964684] ath: REGISTER READ FAILED: (0x8c74, -110)
[   96.205757] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   96.205774] ath: REGISTER WRITE FAILED, multi len: 8
[   96.431263] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   96.431280] ath: REGISTER READ FAILED: (0x8c94, -110)
[   96.670594] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   96.670611] ath: REGISTER WRITE FAILED, multi len: 8
[   96.904391] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   96.904407] ath: REGISTER READ FAILED: (0x8cb4, -110)
[   97.141760] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   97.141778] ath: REGISTER WRITE FAILED, multi len: 8
[   97.380312] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   97.380329] ath: REGISTER READ FAILED: (0x8cd4, -110)
[   97.610917] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   97.610935] ath: REGISTER WRITE FAILED, multi len: 8
[   97.841642] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   97.841658] ath: REGISTER READ FAILED: (0x8cf4, -110)
[   98.087991] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   98.088009] ath: REGISTER WRITE FAILED, multi len: 8
[   98.352449] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   98.352466] ath: REGISTER READ FAILED: (0x8d14, -110)
[   98.591965] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   98.591982] ath: REGISTER WRITE FAILED, multi len: 8
[   98.826263] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   98.826281] ath: REGISTER READ FAILED: (0x8d34, -110)
[   99.047712] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   99.047729] ath: REGISTER WRITE FAILED, multi len: 8
[   99.292783] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   99.292800] ath: REGISTER READ FAILED: (0x8d54, -110)
[   99.522494] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   99.522511] ath: REGISTER WRITE FAILED, multi len: 8
[   99.738792] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[   99.738809] ath: REGISTER READ FAILED: (0x8d74, -110)
[   99.959168] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[   99.959186] ath: REGISTER WRITE FAILED, multi len: 8
[  100.188047] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  100.188059] ath: REGISTER READ FAILED: (0x8d94, -110)
[  100.454063] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  100.454080] ath: REGISTER WRITE FAILED, multi len: 8
[  100.689843] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  100.689860] ath: REGISTER READ FAILED: (0x8db4, -110)
[  100.924129] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  100.924146] ath: REGISTER WRITE FAILED, multi len: 8
[  101.156497] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  101.156515] ath: REGISTER READ FAILED: (0x8dd4, -110)
[  101.397536] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  101.397555] ath: REGISTER WRITE FAILED, multi len: 8
[  101.666040] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  101.666057] ath: REGISTER READ FAILED: (0x8df4, -110)
[  101.899913] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  101.899930] ath: REGISTER WRITE FAILED, multi len: 8
[  102.134299] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  102.134312] ath: REGISTER READ FAILED: (0x8e14, -110)
[  102.371090] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  102.371107] ath: REGISTER WRITE FAILED, multi len: 8
[  102.611698] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  102.611715] ath: REGISTER READ FAILED: (0x8e34, -110)
[  102.847307] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  102.847324] ath: REGISTER WRITE FAILED, multi len: 8
[  103.066903] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  103.066920] ath: REGISTER READ FAILED: (0x8e54, -110)
[  103.304121] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  103.304138] ath: REGISTER WRITE FAILED, multi len: 8
[  103.535983] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  103.536000] ath: REGISTER READ FAILED: (0x8e74, -110)
[  103.771419] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  103.771436] ath: REGISTER WRITE FAILED, multi len: 8
[  104.010499] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  104.010516] ath: REGISTER READ FAILED: (0x8e94, -110)
[  104.244160] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  104.244178] ath: REGISTER WRITE FAILED, multi len: 8
[  104.479000] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  104.479013] ath: REGISTER READ FAILED: (0x8eb4, -110)
[  104.711724] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  104.711741] ath: REGISTER WRITE FAILED, multi len: 8
[  104.923163] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  104.923185] ath: REGISTER READ FAILED: (0x8ed4, -110)
[  105.159891] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  105.159909] ath: REGISTER WRITE FAILED, multi len: 8
[  105.389905] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  105.389922] ath: REGISTER READ FAILED: (0x8ef4, -110)
[  105.605699] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  105.605716] ath: REGISTER WRITE FAILED, multi len: 8
[  105.838344] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  105.838361] ath: REGISTER READ FAILED: (0x8f14, -110)
[  106.076069] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  106.076086] ath: REGISTER WRITE FAILED, multi len: 8
[  106.350270] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  106.350287] ath: REGISTER READ FAILED: (0x8f34, -110)
[  106.588805] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  106.588823] ath: REGISTER WRITE FAILED, multi len: 8
[  106.823643] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  106.823660] ath: REGISTER READ FAILED: (0x8f54, -110)
[  107.053350] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  107.053367] ath: REGISTER WRITE FAILED, multi len: 8
[  107.286945] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  107.286963] ath: REGISTER READ FAILED: (0x8f74, -110)
[  107.517329] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  107.517346] ath: REGISTER WRITE FAILED, multi len: 8
[  107.754844] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  107.754861] ath: REGISTER READ FAILED: (0x8f94, -110)
[  108.018059] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  108.018076] ath: REGISTER WRITE FAILED, multi len: 8
[  108.243426] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  108.243444] ath: REGISTER READ FAILED: (0x8fb4, -110)
[  108.477214] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  108.477231] ath: REGISTER WRITE FAILED, multi len: 8
[  108.707476] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  108.707496] ath: REGISTER READ FAILED: (0x8fd4, -110)
[  108.941315] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  108.941332] ath: REGISTER WRITE FAILED, multi len: 8
[  109.172995] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  109.173007] ath: REGISTER READ FAILED: (0x8ff4, -110)
[  109.402696] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  109.402714] ath: REGISTER WRITE FAILED, multi len: 8
[  109.634771] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  109.634793] ath: REGISTER READ FAILED: (0x9014, -110)
[  109.865550] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  109.865567] ath: REGISTER WRITE FAILED, multi len: 8
[  110.082064] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  110.082080] ath: REGISTER READ FAILED: (0x9034, -110)
[  110.300529] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  110.300546] ath: REGISTER WRITE FAILED, multi len: 8
[  110.526273] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  110.526289] ath: REGISTER READ FAILED: (0x9054, -110)
[  110.749106] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  110.749124] ath: REGISTER WRITE FAILED, multi len: 8
[  110.999478] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  110.999489] ath: REGISTER READ FAILED: (0x9074, -110)
[  111.237365] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  111.237382] ath: REGISTER WRITE FAILED, multi len: 8
[  111.472907] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  111.472924] ath: REGISTER READ FAILED: (0x9094, -110)
[  111.711196] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  111.711213] ath: REGISTER WRITE FAILED, multi len: 8
[  111.946930] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  111.946948] ath: REGISTER READ FAILED: (0x90b4, -110)
[  112.220810] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  112.220828] ath: REGISTER WRITE FAILED, multi len: 8
[  112.456704] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  112.456720] ath: REGISTER READ FAILED: (0x90d4, -110)
[  112.693033] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  112.693050] ath: REGISTER WRITE FAILED, multi len: 8
[  112.973828] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  112.973845] ath: REGISTER READ FAILED: (0x90f4, -110)
[  113.212845] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  113.212862] ath: REGISTER WRITE FAILED, multi len: 8
[  113.433009] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  113.433026] ath: REGISTER READ FAILED: (0x9114, -110)
[  113.662628] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  113.662645] ath: REGISTER WRITE FAILED, multi len: 8
[  113.896300] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  113.896313] ath: REGISTER READ FAILED: (0x9134, -110)
[  114.131041] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  114.131059] ath: REGISTER WRITE FAILED, multi len: 8
[  114.368026] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  114.368042] ath: REGISTER READ FAILED: (0x9154, -110)
[  114.604473] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  114.604490] ath: REGISTER WRITE FAILED, multi len: 8
[  114.838850] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  114.838867] ath: REGISTER READ FAILED: (0x9174, -110)
[  115.072474] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  115.072492] ath: REGISTER WRITE FAILED, multi len: 8
[  115.297650] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  115.297667] ath: REGISTER READ FAILED: (0x9194, -110)
[  115.522142] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  115.522159] ath: REGISTER WRITE FAILED, multi len: 8
[  115.743577] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  115.743594] ath: REGISTER READ FAILED: (0x91b4, -110)
[  115.966947] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  115.966965] ath: REGISTER WRITE FAILED, multi len: 8
[  116.240720] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  116.240737] ath: REGISTER READ FAILED: (0x91d4, -110)
[  116.473288] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  116.473305] ath: REGISTER WRITE FAILED, multi len: 8
[  116.711937] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  116.711954] ath: REGISTER READ FAILED: (0x91f4, -110)
[  116.949273] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  116.949290] ath: REGISTER WRITE FAILED, multi len: 8
[  117.202915] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  117.202932] ath: REGISTER READ FAILED: (0x9214, -110)
[  117.429051] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  117.429068] ath: REGISTER WRITE FAILED, multi len: 8
[  117.663660] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  117.663677] ath: REGISTER READ FAILED: (0x9234, -110)
[  117.903342] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  117.903359] ath: REGISTER WRITE FAILED, multi len: 8
[  118.183918] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  118.183935] ath: REGISTER READ FAILED: (0x9254, -110)
[  118.426246] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  118.426263] ath: REGISTER WRITE FAILED, multi len: 8
[  118.657714] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  118.657730] ath: REGISTER READ FAILED: (0x9274, -110)
[  118.884836] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  118.884854] ath: REGISTER WRITE FAILED, multi len: 8
[  119.120373] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  119.120390] ath: REGISTER READ FAILED: (0x9294, -110)
[  119.356156] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  119.356174] ath: REGISTER WRITE FAILED, multi len: 8
[  119.591889] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  119.591905] ath: REGISTER READ FAILED: (0x92b4, -110)
[  119.826025] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  119.826038] ath: REGISTER WRITE FAILED, multi len: 8
[  120.058233] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  120.058249] ath: REGISTER READ FAILED: (0x92d4, -110)
[  120.290314] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  120.290332] ath: REGISTER WRITE FAILED, multi len: 8
[  120.562007] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  120.562023] ath: REGISTER READ FAILED: (0x92f4, -110)
[  120.777958] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  120.777975] ath: REGISTER WRITE FAILED, multi len: 8
[  120.990469] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  120.990486] ath: REGISTER READ FAILED: (0x9314, -110)
[  121.215391] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  121.215408] ath: REGISTER WRITE FAILED, multi len: 8
[  121.444176] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  121.444194] ath: REGISTER READ FAILED: (0x9334, -110)
[  121.680204] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  121.680221] ath: REGISTER WRITE FAILED, multi len: 8
[  121.921151] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  121.921167] ath: REGISTER READ FAILED: (0x9354, -110)
[  122.163536] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  122.163553] ath: REGISTER WRITE FAILED, multi len: 8
[  122.401806] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  122.401823] ath: REGISTER READ FAILED: (0x9374, -110)
[  122.634011] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  122.634028] ath: REGISTER WRITE FAILED, multi len: 8
[  122.869594] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  122.869612] ath: REGISTER READ FAILED: (0x9394, -110)
[  123.133792] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  123.133809] ath: REGISTER WRITE FAILED, multi len: 8
[  123.372003] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  123.372020] ath: REGISTER READ FAILED: (0x93b4, -110)
[  123.607633] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  123.607650] ath: REGISTER WRITE FAILED, multi len: 8
[  123.839417] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  123.839434] ath: REGISTER READ FAILED: (0x93d4, -110)
[  124.082752] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  124.082765] ath: REGISTER WRITE FAILED, multi len: 8
[  124.343226] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  124.343243] ath: REGISTER READ FAILED: (0x93f4, -110)
[  124.609795] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  124.609808] ath: REGISTER WRITE FAILED, multi len: 8
[  124.873602] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  124.873619] ath: REGISTER READ FAILED: (0x9414, -110)
[  125.110193] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  125.110210] ath: REGISTER WRITE FAILED, multi len: 8
[  125.343346] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  125.343367] ath: REGISTER READ FAILED: (0x9434, -110)
[  125.578907] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  125.578924] ath: REGISTER WRITE FAILED, multi len: 8
[  125.812580] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  125.812597] ath: REGISTER READ FAILED: (0x9454, -110)
[  126.036792] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  126.036809] ath: REGISTER WRITE FAILED, multi len: 8
[  126.245583] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  126.245600] ath: REGISTER READ FAILED: (0x9474, -110)
[  126.470684] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  126.470701] ath: REGISTER WRITE FAILED, multi len: 8
[  126.695099] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  126.695116] ath: REGISTER READ FAILED: (0x9494, -110)
[  126.927598] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  126.927616] ath: REGISTER WRITE FAILED, multi len: 8
[  127.170145] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  127.170163] ath: REGISTER READ FAILED: (0x94b4, -110)
[  127.402661] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  127.402678] ath: REGISTER WRITE FAILED, multi len: 8
[  127.637571] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  127.637588] ath: REGISTER READ FAILED: (0x94d4, -110)
[  127.863365] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  127.863383] ath: REGISTER WRITE FAILED, multi len: 8
[  128.091631] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  128.091647] ath: REGISTER READ FAILED: (0x94f4, -110)
[  128.329717] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  128.329734] ath: REGISTER WRITE FAILED, multi len: 8
[  128.569187] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  128.569204] ath: REGISTER READ FAILED: (0x9514, -110)
[  128.808314] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  128.808331] ath: REGISTER WRITE FAILED, multi len: 8
[  129.051407] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  129.051424] ath: REGISTER READ FAILED: (0x9534, -110)
[  129.264204] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  129.264222] ath: REGISTER WRITE FAILED, multi len: 8
[  129.500790] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  129.500807] ath: REGISTER READ FAILED: (0x9554, -110)
[  129.739287] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  129.739304] ath: REGISTER WRITE FAILED, multi len: 8
[  129.977121] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  129.977138] ath: REGISTER READ FAILED: (0x9574, -110)
[  130.256434] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  130.256452] ath: REGISTER WRITE FAILED, multi len: 8
[  130.482659] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  130.482671] ath: REGISTER READ FAILED: (0x9594, -110)
[  130.758145] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  130.758162] ath: REGISTER WRITE FAILED, multi len: 8
[  130.988136] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  130.988158] ath: REGISTER READ FAILED: (0x95b4, -110)
[  131.198704] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  131.198721] ath: REGISTER WRITE FAILED, multi len: 8
[  131.425187] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  131.425204] ath: REGISTER READ FAILED: (0x95d4, -110)
[  131.652416] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  131.652433] ath: REGISTER WRITE FAILED, multi len: 8
[  131.871049] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  131.871066] ath: REGISTER READ FAILED: (0x95f4, -110)
[  132.106850] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  132.106868] ath: REGISTER WRITE FAILED, multi len: 8
[  132.351316] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  132.351333] ath: REGISTER READ FAILED: (0x9614, -110)
[  132.586807] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  132.586825] ath: REGISTER WRITE FAILED, multi len: 8
[  132.821928] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  132.821941] ath: REGISTER READ FAILED: (0x9634, -110)
[  133.052099] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  133.052117] ath: REGISTER WRITE FAILED, multi len: 8
[  133.281250] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  133.281267] ath: REGISTER READ FAILED: (0x9654, -110)
[  133.533685] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  133.533703] ath: REGISTER WRITE FAILED, multi len: 8
[  133.802899] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  133.802916] ath: REGISTER READ FAILED: (0x9674, -110)
[  134.035319] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  134.035336] ath: REGISTER WRITE FAILED, multi len: 8
[  134.271297] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  134.271314] ath: REGISTER READ FAILED: (0x9694, -110)
[  134.488850] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  134.488867] ath: REGISTER WRITE FAILED, multi len: 8
[  134.723776] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  134.723793] ath: REGISTER READ FAILED: (0x96b4, -110)
[  134.960923] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  134.960940] ath: REGISTER WRITE FAILED, multi len: 8
[  135.208717] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  135.208734] ath: REGISTER READ FAILED: (0x96d4, -110)
[  135.447071] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  135.447088] ath: REGISTER WRITE FAILED, multi len: 8
[  135.686469] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  135.686486] ath: REGISTER READ FAILED: (0x96f4, -110)
[  135.920807] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  135.920829] ath: REGISTER WRITE FAILED, multi len: 8
[  136.198714] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  136.198731] ath: REGISTER READ FAILED: (0x9714, -110)
[  136.419191] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  136.419209] ath: REGISTER WRITE FAILED, multi len: 8
[  136.640991] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  136.641012] ath: REGISTER READ FAILED: (0x9734, -110)
[  136.865320] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  136.865338] ath: REGISTER WRITE FAILED, multi len: 8
[  137.127238] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  137.127255] ath: REGISTER READ FAILED: (0x9754, -110)
[  137.359408] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  137.359425] ath: REGISTER WRITE FAILED, multi len: 8
[  137.597341] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  137.597363] ath: REGISTER READ FAILED: (0x9774, -110)
[  137.836090] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  137.836107] ath: REGISTER WRITE FAILED, multi len: 8
[  138.075803] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  138.075819] ath: REGISTER READ FAILED: (0x9794, -110)
[  138.310459] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  138.310477] ath: REGISTER WRITE FAILED, multi len: 8
[  138.540266] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  138.540283] ath: REGISTER READ FAILED: (0x97b4, -110)
[  138.778382] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  138.778399] ath: REGISTER WRITE FAILED, multi len: 8
[  139.034750] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  139.034767] ath: REGISTER READ FAILED: (0x97d4, -110)
[  139.273181] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  139.273198] ath: REGISTER WRITE FAILED, multi len: 8
[  139.512953] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  139.512970] ath: REGISTER READ FAILED: (0x97f4, -110)
[  139.770607] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  139.770625] ath: REGISTER WRITE FAILED, multi len: 8
[  139.770638] ath: TX streams 1, RX streams: 1
[  140.946240] ath: Timeout waiting for WMI command: WMI_GET_FW_VERSION
[  140.946259] ath: AWAKE -> FULL-SLEEP
[  141.187898] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  141.187915] ath: REGISTER READ FAILED: (0x8004, -110)
[  141.420292] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  141.420308] ath: REGISTER WRITE FAILED:(0x8004, -110)
[  141.632925] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
[  141.632942] ath: REGISTER READ FAILED: (0x704c, -110)
[  141.855875] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  141.855892] ath: REGISTER WRITE FAILED:(0x704c, -110)
[  142.116512] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
[  142.116529] ath: REGISTER WRITE FAILED:(0x4000, -110)
[  142.116562] Failed to initialize the device
[  142.156645] ath9k_htc: probe of 5-7:1.0 failed with error -22


I should also mention that lsusb seems to work much better now, but maybe i=
t's a
coincidence?

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.rapidrollout.com

--uZ3hkaAS1mZxFaxD
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-Revert-ath9k_hw-Use-buffered-register-writes.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 952f8ce6a3762b2aca49641b66e88f4ea37d7454 Mon Sep 17 00:00:00 2001
=46rom: Forest Bond <forest.bond@rapidrollout.com>
Date: Tue, 5 Jul 2011 13:06:18 -0400
Subject: [PATCH] Revert "ath9k_hw: Use buffered register writes"

This reverts commit 7d0d0df0eca695c83a08dc386824a9d1d7c526a4.

Conflicts:

	drivers/net/wireless/ath/ath9k/ani.c
	drivers/net/wireless/ath/ath9k/ar5008_phy.c
	drivers/net/wireless/ath/ath9k/ar9002_calib.c
	drivers/net/wireless/ath/ath9k/ar9002_hw.c
	drivers/net/wireless/ath/ath9k/ar9002_phy.c
	drivers/net/wireless/ath/ath9k/eeprom_4k.c
	drivers/net/wireless/ath/ath9k/hw.c
	drivers/net/wireless/ath/ath9k/mac.c
---
 drivers/net/wireless/ath/ath9k/ani.c          |   13 ------
 drivers/net/wireless/ath/ath9k/ar5008_phy.c   |   18 --------
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |    4 --
 drivers/net/wireless/ath/ath9k/ar9002_hw.c    |    6 +--
 drivers/net/wireless/ath/ath9k/ar9002_phy.c   |    4 --
 drivers/net/wireless/ath/ath9k/calib.c        |    2 -
 drivers/net/wireless/ath/ath9k/eeprom_4k.c    |    8 ----
 drivers/net/wireless/ath/ath9k/hw.c           |   53 ---------------------=
----
 drivers/net/wireless/ath/ath9k/mac.c          |   17 --------
 9 files changed, 1 insertions(+), 124 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/at=
h/ath9k/ani.c
index bfb6481..41c2fd0 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -138,15 +138,11 @@ static void ath9k_ani_restart(struct ath_hw *ah)
 	ath_dbg(common, ATH_DBG_ANI,
 		"Writing ofdmbase=3D%u   cckbase=3D%u\n", ofdm_base, cck_base);
=20
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	REG_WRITE(ah, AR_PHY_ERR_1, ofdm_base);
 	REG_WRITE(ah, AR_PHY_ERR_2, cck_base);
 	REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
 	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
=20
-	REGWRITE_BUFFER_FLUSH(ah);
-
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
=20
 	aniState->ofdmPhyErrCount =3D 0;
@@ -528,13 +524,8 @@ static void ath9k_ani_reset_old(struct ath_hw *ah, boo=
l is_scanning)
 	ath9k_hw_setrxfilter(ah, ath9k_hw_getrxfilter(ah) &
 			     ~ATH9K_RX_FILTER_PHYERR);
 	ath9k_ani_restart(ah);
-
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
 	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
-
-	REGWRITE_BUFFER_FLUSH(ah);
 }
=20
 /*
@@ -752,8 +743,6 @@ void ath9k_enable_mib_counters(struct ath_hw *ah)
=20
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
=20
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	REG_WRITE(ah, AR_FILT_OFDM, 0);
 	REG_WRITE(ah, AR_FILT_CCK, 0);
 	REG_WRITE(ah, AR_MIBC,
@@ -761,8 +750,6 @@ void ath9k_enable_mib_counters(struct ath_hw *ah)
 		  & 0x0f);
 	REG_WRITE(ah, AR_PHY_ERR_MASK_1, AR_PHY_ERR_OFDM_TIMING);
 	REG_WRITE(ah, AR_PHY_ERR_MASK_2, AR_PHY_ERR_CCK_TIMING);
-
-	REGWRITE_BUFFER_FLUSH(ah);
 }
=20
 /* Freeze the MIB counters, get the stats and then clear them */
diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wire=
less/ath/ath9k/ar5008_phy.c
index 441bb33..6b83eaf 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -639,7 +639,6 @@ static void ar5008_hw_init_chain_masks(struct ath_hw *a=
h)
 	rx_chainmask =3D ah->rxchainmask;
 	tx_chainmask =3D ah->txchainmask;
=20
-
 	switch (rx_chainmask) {
 	case 0x5:
 		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
@@ -653,19 +652,14 @@ static void ar5008_hw_init_chain_masks(struct ath_hw =
*ah)
 	case 0x1:
 	case 0x2:
 	case 0x7:
-		ENABLE_REGWRITE_BUFFER(ah);
 		REG_WRITE(ah, AR_PHY_RX_CHAINMASK, rx_chainmask);
 		REG_WRITE(ah, AR_PHY_CAL_CHAINMASK, rx_chainmask);
 		break;
 	default:
-		ENABLE_REGWRITE_BUFFER(ah);
 		break;
 	}
=20
 	REG_WRITE(ah, AR_SELFGEN_MASK, tx_chainmask);
-
-	REGWRITE_BUFFER_FLUSH(ah);
-
 	if (tx_chainmask =3D=3D 0x5) {
 		REG_SET_BIT(ah, AR_PHY_ANALOG_SWAP,
 			    AR_PHY_SWAP_ALT_CHAIN);
@@ -744,12 +738,8 @@ static void ar5008_hw_set_channel_regs(struct ath_hw *=
ah,
=20
 	ath9k_hw_set11nmac2040(ah);
=20
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	REG_WRITE(ah, AR_GTXTO, 25 << AR_GTXTO_TIMEOUT_LIMIT_S);
 	REG_WRITE(ah, AR_CST, 0xF << AR_CST_TIMEOUT_LIMIT_S);
-
-	REGWRITE_BUFFER_FLUSH(ah);
 }
=20
=20
@@ -822,8 +812,6 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
=20
 	REG_WRITE(ah, AR_PHY_ADC_SERIAL_CTL, AR_PHY_SEL_INTERNAL_ADDAC);
=20
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	for (i =3D 0; i < ah->iniModes.ia_rows; i++) {
 		u32 reg =3D INI_RA(&ah->iniModes, i, 0);
 		u32 val =3D INI_RA(&ah->iniModes, i, modesIndex);
@@ -842,8 +830,6 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
 		DO_DELAY(regWrites);
 	}
=20
-	REGWRITE_BUFFER_FLUSH(ah);
-
 	if (AR_SREV_9280(ah) || AR_SREV_9287_11_OR_LATER(ah))
 		REG_WRITE_ARRAY(&ah->iniModesRxGain, modesIndex, regWrites);
=20
@@ -855,8 +841,6 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
 		REG_WRITE_ARRAY(&ah->iniModes_9271_1_0_only,
 				modesIndex, regWrites);
=20
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	/* Write common array parameters */
 	for (i =3D 0; i < ah->iniCommon.ia_rows; i++) {
 		u32 reg =3D INI_RA(&ah->iniCommon, i, 0);
@@ -873,8 +857,6 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
 		DO_DELAY(regWrites);
 	}
=20
-	REGWRITE_BUFFER_FLUSH(ah);
-
 	if (AR_SREV_9271(ah)) {
 		if (ah->eep_ops->get_eeprom(ah, EEP_TXGAIN_TYPE) =3D=3D 1)
 			REG_WRITE_ARRAY(&ah->iniModes_high_power_tx_gain_9271,
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wi=
reless/ath/ath9k/ar9002_calib.c
index 2d4c091..f24c46f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -528,8 +528,6 @@ static void ar9271_hw_pa_cal(struct ath_hw *ah, bool is=
_reset)
 		ah->pacal_info.prev_offset =3D regVal;
 	}
=20
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	regVal =3D REG_READ(ah, 0x7834);
 	regVal |=3D 0x1;
 	REG_WRITE(ah, 0x7834, regVal);
@@ -539,8 +537,6 @@ static void ar9271_hw_pa_cal(struct ath_hw *ah, bool is=
_reset)
=20
 	for (i =3D 0; i < ARRAY_SIZE(regList); i++)
 		REG_WRITE(ah, regList[i][0], regList[i][1]);
-
-	REGWRITE_BUFFER_FLUSH(ah);
 }
=20
 static inline void ar9285_hw_pa_cal(struct ath_hw *ah, bool is_reset)
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wirel=
ess/ath/ath9k/ar9002_hw.c
index f344cc2..3020f0c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -444,14 +444,10 @@ static int ar9002_hw_get_radiorev(struct ath_hw *ah)
 	u32 val;
 	int i;
=20
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	REG_WRITE(ah, AR_PHY(0x36), 0x00007058);
+
 	for (i =3D 0; i < 8; i++)
 		REG_WRITE(ah, AR_PHY(0x20), 0x00010000);
-
-	REGWRITE_BUFFER_FLUSH(ah);
-
 	val =3D (REG_READ(ah, AR_PHY(256)) >> 24) & 0xff;
 	val =3D ((val & 0xf0) >> 4) | ((val & 0x0f) << 4);
=20
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wire=
less/ath/ath9k/ar9002_phy.c
index 2fe0a34..0715d71 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -239,8 +239,6 @@ static void ar9002_hw_spur_mitigate(struct ath_hw *ah,
=20
 	tmp =3D REG_READ(ah, AR_PHY_TIMING_CTRL4(0));
=20
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	newVal =3D tmp | (AR_PHY_TIMING_CTRL4_ENABLE_SPUR_RSSI |
 			AR_PHY_TIMING_CTRL4_ENABLE_SPUR_FILTER |
 			AR_PHY_TIMING_CTRL4_ENABLE_CHAN_MASK |
@@ -416,8 +414,6 @@ static void ar9002_hw_spur_mitigate(struct ath_hw *ah,
 		| (mask_p[47] << 2) | (mask_p[46] << 0);
 	REG_WRITE(ah, AR_PHY_BIN_MASK2_4, tmp_mask);
 	REG_WRITE(ah, AR_PHY_MASK2_P_61_45, tmp_mask);
-
-	REGWRITE_BUFFER_FLUSH(ah);
 }
=20
 static void ar9002_olc_init(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/=
ath/ath9k/calib.c
index a1250c5..6b2f104 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -300,7 +300,6 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_ch=
annel *chan)
 	 * by the median we just loaded.  This will be initial (and max) value
 	 * of next noise floor calibration the baseband does.
 	 */
-	ENABLE_REGWRITE_BUFFER(ah);
 	for (i =3D 0; i < NUM_NF_READINGS; i++) {
 		if (chainmask & (1 << i)) {
 			if ((i >=3D AR5416_MAX_CHAINS) && !conf_is_ht40(conf))
@@ -312,7 +311,6 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_ch=
annel *chan)
 			REG_WRITE(ah, ah->nf_regs[i], val);
 		}
 	}
-	REGWRITE_BUFFER_FLUSH(ah);
 }
=20
=20
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wirel=
ess/ath/ath9k/eeprom_4k.c
index 5b1e894..8f96297 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -313,8 +313,6 @@ static void ath9k_hw_set_4k_power_cal_table(struct ath_=
hw *ah,
 					    gainBoundaries,
 					    pdadcValues, numXpdGain);
=20
-			ENABLE_REGWRITE_BUFFER(ah);
-
 			if ((i =3D=3D 0) || AR_SREV_5416_20_OR_LATER(ah)) {
 				REG_WRITE(ah, AR_PHY_TPCRG5 + regChainOffset,
 					  SM(pdGainOverlap_t2,
@@ -354,8 +352,6 @@ static void ath9k_hw_set_4k_power_cal_table(struct ath_=
hw *ah,
=20
 				regOffset +=3D 4;
 			}
-
-			REGWRITE_BUFFER_FLUSH(ah);
 		}
 	}
=20
@@ -628,8 +624,6 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 			ratesArray[i] -=3D AR5416_PWR_TABLE_OFFSET_DB * 2;
 	}
=20
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	/* OFDM power per rate */
 	REG_WRITE(ah, AR_PHY_POWER_TX_RATE1,
 		  ATH9K_POW_SM(ratesArray[rate18mb], 24)
@@ -692,8 +686,6 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 			  | ATH9K_POW_SM(ratesArray[rateDupOfdm], 8)
 			  | ATH9K_POW_SM(ratesArray[rateDupCck], 0));
 	}
-
-	REGWRITE_BUFFER_FLUSH(ah);
 }
=20
 static void ath9k_hw_4k_set_addac(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath=
/ath9k/hw.c
index 1be7c8b..df48dc3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -654,8 +654,6 @@ EXPORT_SYMBOL(ath9k_hw_init);
=20
 static void ath9k_hw_init_qos(struct ath_hw *ah)
 {
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	REG_WRITE(ah, AR_MIC_QOS_CONTROL, 0x100aa);
 	REG_WRITE(ah, AR_MIC_QOS_SELECT, 0x3210);
=20
@@ -669,8 +667,6 @@ static void ath9k_hw_init_qos(struct ath_hw *ah)
 	REG_WRITE(ah, AR_TXOP_4_7, 0xFFFFFFFF);
 	REG_WRITE(ah, AR_TXOP_8_11, 0xFFFFFFFF);
 	REG_WRITE(ah, AR_TXOP_12_15, 0xFFFFFFFF);
-
-	REGWRITE_BUFFER_FLUSH(ah);
 }
=20
 u32 ar9003_get_pll_sqsum_dvc(struct ath_hw *ah)
@@ -825,8 +821,6 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hw=
 *ah,
 	if (opmode =3D=3D NL80211_IFTYPE_AP)
 		imr_reg |=3D AR_IMR_MIB;
=20
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	REG_WRITE(ah, AR_IMR, imr_reg);
 	ah->imrs2_reg |=3D AR_IMR_S2_GTT;
 	REG_WRITE(ah, AR_IMR_S2, ah->imrs2_reg);
@@ -837,8 +831,6 @@ static void ath9k_hw_init_interrupt_masks(struct ath_hw=
 *ah,
 		REG_WRITE(ah, AR_INTR_SYNC_MASK, 0);
 	}
=20
-	REGWRITE_BUFFER_FLUSH(ah);
-
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		REG_WRITE(ah, AR_INTR_PRIO_ASYNC_ENABLE, 0);
 		REG_WRITE(ah, AR_INTR_PRIO_ASYNC_MASK, 0);
@@ -962,8 +954,6 @@ static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 {
 	struct ath_common *common =3D ath9k_hw_common(ah);
=20
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	/*
 	 * set AHB_MODE not to do cacheline prefetches
 	*/
@@ -975,8 +965,6 @@ static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 	 */
 	REG_RMW(ah, AR_TXCFG, AR_TXCFG_DMASZ_128B, AR_TXCFG_DMASZ_MASK);
=20
-	REGWRITE_BUFFER_FLUSH(ah);
-
 	/*
 	 * Restore TX Trigger Level to its pre-reset value.
 	 * The initial value depends on whether aggregation is enabled, and is
@@ -985,8 +973,6 @@ static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 	if (!AR_SREV_9300_20_OR_LATER(ah))
 		REG_RMW_FIELD(ah, AR_TXCFG, AR_FTRIG, ah->tx_trig_level);
=20
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	/*
 	 * let mac dma writes be in 128 byte chunks
 	 */
@@ -1021,8 +1007,6 @@ static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 			  AR_PCU_TXBUF_CTRL_USABLE_SIZE);
 	}
=20
-	REGWRITE_BUFFER_FLUSH(ah);
-
 	if (AR_SREV_9300_20_OR_LATER(ah))
 		ath9k_hw_reset_txstatus_ring(ah);
 }
@@ -1080,8 +1064,6 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int=
 type)
 		(void)REG_READ(ah, AR_RTC_DERIVED_CLK);
 	}
=20
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		REG_WRITE(ah, AR_WA, ah->WARegVal);
 		udelay(10);
@@ -1115,9 +1097,6 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int=
 type)
 	}
=20
 	REG_WRITE(ah, AR_RTC_RC, rst_flags);
-
-	REGWRITE_BUFFER_FLUSH(ah);
-
 	udelay(50);
=20
 	REG_WRITE(ah, AR_RTC_RC, 0);
@@ -1138,8 +1117,6 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int=
 type)
=20
 static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 {
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
 		REG_WRITE(ah, AR_WA, ah->WARegVal);
 		udelay(10);
@@ -1153,8 +1130,6 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw=
 *ah)
=20
 	REG_WRITE(ah, AR_RTC_RESET, 0);
=20
-	REGWRITE_BUFFER_FLUSH(ah);
-
 	if (!AR_SREV_9300_20_OR_LATER(ah))
 		udelay(2);
=20
@@ -1442,8 +1417,6 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_ch=
annel *chan,
 	ath9k_hw_spur_mitigate_freq(ah, chan);
 	ah->eep_ops->set_board_values(ah, chan);
=20
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	REG_WRITE(ah, AR_STA_ID0, get_unaligned_le32(common->macaddr));
 	REG_WRITE(ah, AR_STA_ID1, get_unaligned_le16(common->macaddr + 4)
 		  | macStaId1
@@ -1457,8 +1430,6 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_ch=
annel *chan,
 	REG_WRITE(ah, AR_ISR, ~0);
 	REG_WRITE(ah, AR_RSSI_THR, INIT_RSSI_THR);
=20
-	REGWRITE_BUFFER_FLUSH(ah);
-
 	ath9k_hw_set_operating_mode(ah, ah->opmode);
=20
 	r =3D ath9k_hw_rf_set_freq(ah, chan);
@@ -1467,13 +1438,9 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_c=
hannel *chan,
=20
 	ath9k_hw_set_clockrate(ah);
=20
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	for (i =3D 0; i < AR_NUM_DCU; i++)
 		REG_WRITE(ah, AR_DQCUMASK(i), 1 << i);
=20
-	REGWRITE_BUFFER_FLUSH(ah);
-
 	ah->intr_txqs =3D 0;
 	for (i =3D 0; i < ATH9K_NUM_TX_QUEUES; i++)
 		ath9k_hw_resettxqueue(ah, i);
@@ -1513,13 +1480,9 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_c=
hannel *chan,
 	if (!ath9k_hw_init_cal(ah, chan))
 		return -EIO;
=20
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	ath9k_hw_restore_chainmask(ah);
 	REG_WRITE(ah, AR_CFG_LED, saveLedState | AR_CFG_SCLK_32KHZ);
=20
-	REGWRITE_BUFFER_FLUSH(ah);
-
 	/*
 	 * For big endian systems turn on swapping for descriptors
 	 */
@@ -1735,8 +1698,6 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_=
beacon, u32 beacon_period)
 {
 	int flags =3D 0;
=20
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	switch (ah->opmode) {
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_MESH_POINT:
@@ -1767,8 +1728,6 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_=
beacon, u32 beacon_period)
 	REG_WRITE(ah, AR_SWBA_PERIOD, beacon_period);
 	REG_WRITE(ah, AR_NDP_PERIOD, beacon_period);
=20
-	REGWRITE_BUFFER_FLUSH(ah);
-
 	REG_SET_BIT(ah, AR_TIMER_MODE, flags);
 }
 EXPORT_SYMBOL(ath9k_hw_beaconinit);
@@ -1780,8 +1739,6 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 	struct ath9k_hw_capabilities *pCap =3D &ah->caps;
 	struct ath_common *common =3D ath9k_hw_common(ah);
=20
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(bs->bs_nexttbtt));
=20
 	REG_WRITE(ah, AR_BEACON_PERIOD,
@@ -1789,8 +1746,6 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 	REG_WRITE(ah, AR_DMA_BEACON_PERIOD,
 		  TU_TO_USEC(bs->bs_intval & ATH9K_BEACON_PERIOD));
=20
-	REGWRITE_BUFFER_FLUSH(ah);
-
 	REG_RMW_FIELD(ah, AR_RSSI_THR,
 		      AR_RSSI_THR_BM_THR, bs->bs_bmissthreshold);
=20
@@ -1813,8 +1768,6 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 	ath_dbg(common, ATH_DBG_BEACON, "beacon period %d\n", beaconintval);
 	ath_dbg(common, ATH_DBG_BEACON, "DTIM period %d\n", dtimperiod);
=20
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	REG_WRITE(ah, AR_NEXT_DTIM,
 		  TU_TO_USEC(bs->bs_nextdtim - SLEEP_SLOP));
 	REG_WRITE(ah, AR_NEXT_TIM, TU_TO_USEC(nextTbtt - SLEEP_SLOP));
@@ -1834,8 +1787,6 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 	REG_WRITE(ah, AR_TIM_PERIOD, TU_TO_USEC(beaconintval));
 	REG_WRITE(ah, AR_DTIM_PERIOD, TU_TO_USEC(dtimperiod));
=20
-	REGWRITE_BUFFER_FLUSH(ah);
-
 	REG_SET_BIT(ah, AR_TIMER_MODE,
 		    AR_TBTT_TIMER_EN | AR_TIM_TIMER_EN |
 		    AR_DTIM_TIMER_EN);
@@ -2217,8 +2168,6 @@ void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits)
 {
 	u32 phybits;
=20
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	REG_WRITE(ah, AR_RX_FILTER, bits);
=20
 	phybits =3D 0;
@@ -2232,8 +2181,6 @@ void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits)
 		REG_SET_BIT(ah, AR_RXCFG, AR_RXCFG_ZLFDMA);
 	else
 		REG_CLR_BIT(ah, AR_RXCFG, AR_RXCFG_ZLFDMA);
-
-	REGWRITE_BUFFER_FLUSH(ah);
 }
 EXPORT_SYMBOL(ath9k_hw_setrxfilter);
=20
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/at=
h/ath9k/mac.c
index c2091f1..50510ca 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -26,8 +26,6 @@ static void ath9k_hw_set_txq_interrupts(struct ath_hw *ah,
 		ah->txdesc_interrupt_mask, ah->txeol_interrupt_mask,
 		ah->txurn_interrupt_mask);
=20
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	REG_WRITE(ah, AR_IMR_S0,
 		  SM(ah->txok_interrupt_mask, AR_IMR_S0_QCU_TXOK)
 		  | SM(ah->txdesc_interrupt_mask, AR_IMR_S0_QCU_TXDESC));
@@ -38,8 +36,6 @@ static void ath9k_hw_set_txq_interrupts(struct ath_hw *ah,
 	ah->imrs2_reg &=3D ~AR_IMR_S2_QCU_TXURN;
 	ah->imrs2_reg |=3D (ah->txurn_interrupt_mask & AR_IMR_S2_QCU_TXURN);
 	REG_WRITE(ah, AR_IMR_S2, ah->imrs2_reg);
-
-	REGWRITE_BUFFER_FLUSH(ah);
 }
=20
 u32 ath9k_hw_gettxbuf(struct ath_hw *ah, u32 q)
@@ -417,8 +413,6 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 	} else
 		cwMin =3D qi->tqi_cwmin;
=20
-	ENABLE_REGWRITE_BUFFER(ah);
-
 	REG_WRITE(ah, AR_DLCL_IFS(q),
 		  SM(cwMin, AR_D_LCL_IFS_CWMIN) |
 		  SM(qi->tqi_cwmax, AR_D_LCL_IFS_CWMAX) |
@@ -463,15 +457,11 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 	if (qi->tqi_qflags & TXQ_FLAG_BACKOFF_DISABLE)
 		REG_SET_BIT(ah, AR_DMISC(q), AR_D_MISC_POST_FR_BKOFF_DIS);
=20
-	REGWRITE_BUFFER_FLUSH(ah);
-
 	if (qi->tqi_qflags & TXQ_FLAG_FRAG_BURST_BACKOFF_ENABLE)
 		REG_SET_BIT(ah, AR_DMISC(q), AR_D_MISC_FRAG_BKOFF_EN);
=20
 	switch (qi->tqi_type) {
 	case ATH9K_TX_QUEUE_BEACON:
-		ENABLE_REGWRITE_BUFFER(ah);
-
 		REG_SET_BIT(ah, AR_QMISC(q),
 			    AR_Q_MISC_FSP_DBA_GATED
 			    | AR_Q_MISC_BEACON_USE
@@ -483,8 +473,6 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 			    | AR_D_MISC_BEACON_USE
 			    | AR_D_MISC_POST_FR_BKOFF_DIS);
=20
-		REGWRITE_BUFFER_FLUSH(ah);
-
 		/*
 		 * cwmin and cwmax should be 0 for beacon queue
 		 * but not for IBSS as we would create an imbalance
@@ -498,8 +486,6 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 		}
 		break;
 	case ATH9K_TX_QUEUE_CAB:
-		ENABLE_REGWRITE_BUFFER(ah);
-
 		REG_SET_BIT(ah, AR_QMISC(q),
 			    AR_Q_MISC_FSP_DBA_GATED
 			    | AR_Q_MISC_CBR_INCR_DIS1
@@ -513,9 +499,6 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 		REG_SET_BIT(ah, AR_DMISC(q),
 			    (AR_D_MISC_ARB_LOCKOUT_CNTRL_GLOBAL <<
 			     AR_D_MISC_ARB_LOCKOUT_CNTRL_S));
-
-		REGWRITE_BUFFER_FLUSH(ah);
-
 		break;
 	case ATH9K_TX_QUEUE_PSPOLL:
 		REG_SET_BIT(ah, AR_QMISC(q), AR_Q_MISC_CBR_INCR_DIS1);
--=20
1.7.0.4


--uZ3hkaAS1mZxFaxD--

--GZVR6ND4mMseVXL/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk4TR9YACgkQRO4fQQdv5AyqvgCfb11KLoxvyUPe9b/z27S/Bl7+
W+UAoNtKmeVco+c6WRKXVu7QK8e3DLX2
=pBAR
-----END PGP SIGNATURE-----

--GZVR6ND4mMseVXL/--

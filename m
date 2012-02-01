Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:41284 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751766Ab2BARZs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 12:25:48 -0500
Received: by mail-lpp01m020-f172.google.com with SMTP id gk8so241392lbb.31
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2012 09:25:45 -0800 (PST)
Date: Wed, 1 Feb 2012 19:25:39 +0200
From: Felipe Balbi <balbi@ti.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
	"stefano.brivio@polimi.it" <stefano.brivio@polimi.it>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Subject: Re: Dell e6410 with b43
Message-ID: <20120201172537.GC8429@legolas.emea.dhcp.ti.com> (sfid-20120201_182557_414389_B10D499A)
Reply-To: balbi@ti.com
References: <20120201123324.GG20238@legolas.emea.dhcp.ti.com>
 <4F2963A9.1020100@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eHhjakXzOLJAF9wJ"
In-Reply-To: <4F2963A9.1020100@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--eHhjakXzOLJAF9wJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Feb 01, 2012 at 05:09:13PM +0100, Arend van Spriel wrote:
> On 02/01/2012 01:33 PM, Felipe Balbi wrote:
> > Hi all,
> >=20
> > is Dell e6410's b43 wireless card supported by the open source driver ?
> >=20
> > Here's lspci dump:
> >=20
> > 02:00.0 Network controller [0280]: Broadcom Corporation BCM43224 802.11=
a/b/g/n [14e4:4353] (rev 01)
> > 	Subsystem: Dell Wireless 1520 Half-size Mini PCIe Card [1028:000e]
> > 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- St=
epping- SERR- FastB2B- DisINTx-
> > 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 0, Cache Line Size: 64 bytes
> > 	Interrupt: pin A routed to IRQ 10
> > 	Region 0: Memory at f4100000 (64-bit, non-prefetchable) [size=3D16K]
> > 	Capabilities: [40] Power Management version 3
> > 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D=
3cold+)
> > 		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D2 PME-
> > 	Capabilities: [58] Vendor Specific Information: Len=3D78 <?>
> > 	Capabilities: [48] MSI: Enable- Count=3D1/1 Maskable- 64bit+
> > 		Address: 0000000000000000  Data: 0000
> > 	Capabilities: [d0] Express (v1) Endpoint, MSI 00
> > 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlim=
ited
> > 			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> > 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> > 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> > 			MaxPayload 128 bytes, MaxReadReq 128 bytes
> > 		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
> > 		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4u=
s, L1 <64us
> > 			ClockPM+ Surprise- LLActRep+ BwNot-
> > 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
> > 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> > 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWM=
gmt- ABWMgmt-
> >=20
> > It's at least not listed under http://linuxwireless.org/en/users/Device=
s/PCI
> >=20
> > If it is supported, which firmware should I use ? (kernel is 3.3-rc2)
> >=20
>=20
> It is. See http://linuxwireless.org/en/users/Drivers/brcm80211

last time I tried that one (3.1 or 3.0, can't remember) it was causing
all sorts of problems and I got numerous BUG()s. Because this is my work
laptop, I decided to ditch that driver. Is it more stable now ?

--=20
balbi

--eHhjakXzOLJAF9wJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKXWRAAoJEIaOsuA1yqREEH4P/iTOZ8mXFLePp1dlWjMcXAdw
oFZ+vLQc2UhsM2/LnfLAAjYDSdWNX8whxRjWWOiFln0lt/co4/jyQ668YpejlBG7
dUL+0rVGsMo/94aC75qCY+RDlooREfjWKca2HFM2zqA+bm0d7MPg/GadwiSsu9Qy
Rx9QQ0v0p0iDdOgTfnR4ZnP9h1HIJ51T/W5BqsK7YyKA6y9yiGs1ANULbz+02kmr
0VyoDGHQCHQpILSscGIySuXtydTMlQOtxF7ucA/AR3kQuPeT37bUEcFg8q6M8wW5
seNO9bmtPILWQydGoAJCfOkiAVXQ/rRsmivwTc6axoWtyAj8DmpmIlk0gPNKXmz1
qxWSZdRhe+W1caA+IIud6nX0Tne+KrRP+90cftmWVCg3BKXOVBrv4MeXaGJ1DKF+
wJ2PiwkOm7CCnbjVbx3YfAo/YwqQuS7dm+olgi4II2etg+BUS7XC24xd8JSV3aWO
w+BsoOZ+YhFxyICF2F9ANfnNidhWvifXGvRvS48pyHR62s26ZVTVhSZJ9rdqdWLg
lx5qg6VnUo10d+nSLOrpjcvY0TsjVbJfyfr+xC8Wzv7PpgOpte3R6EydLn7FTk9Y
lLdhH6ZH8dwhxWZSSLljpm4I0fKrn2SOYk7ccmw2A+W+kal1sy3pXj9Uv1aOow1H
1kFfWKBBTiMGpFUQdipy
=/Wky
-----END PGP SIGNATURE-----

--eHhjakXzOLJAF9wJ--

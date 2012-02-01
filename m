Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:40229 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754287Ab2BAMdb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 07:33:31 -0500
Received: by mail-lpp01m010-f42.google.com with SMTP id k11so1403421lag.1
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2012 04:33:29 -0800 (PST)
Date: Wed, 1 Feb 2012 14:33:26 +0200
From: Felipe Balbi <balbi@ti.com>
To: stefano.brivio@polimi.it
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Dell e6410 with b43
Message-ID: <20120201123324.GG20238@legolas.emea.dhcp.ti.com> (sfid-20120201_133334_912890_FA3E0E15)
Reply-To: balbi@ti.com
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7J16OGEJ/mt06A90"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--7J16OGEJ/mt06A90
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

is Dell e6410's b43 wireless card supported by the open source driver ?

Here's lspci dump:

02:00.0 Network controller [0280]: Broadcom Corporation BCM43224 802.11a/b/=
g/n [14e4:4353] (rev 01)
	Subsystem: Dell Wireless 1520 Half-size Mini PCIe Card [1028:000e]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort- =
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at f4100000 (64-bit, non-prefetchable) [size=3D16K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3col=
d+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=3D0 DScale=3D2 PME-
	Capabilities: [58] Vendor Specific Information: Len=3D78 <?>
	Capabilities: [48] MSI: Enable- Count=3D1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [d0] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L=
1 <64us
			ClockPM+ Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt-=
 ABWMgmt-

It's at least not listed under http://linuxwireless.org/en/users/Devices/PCI

If it is supported, which firmware should I use ? (kernel is 3.3-rc2)

--=20
balbi

--7J16OGEJ/mt06A90
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKTEUAAoJEIaOsuA1yqRE9BgQAI4XoJJgcJ+aV29IwhM2czhB
ZRbnxjO5BeELRR8vbjAKBELk0YJ/1ItVDeYxEegwjJTAFfkpLyDvWh3ymSKLrhyY
P08lNJkloXadjBS+8/bKWJmi+Zk7C65BPW1dCpQRTB/IxZE5wAvJlBQylcLwToW3
Y9vfZ9O+sgPkMFCcGiWx4rGl4XYDi85u9G7WXcBQ7rjPV9IC+xb/yhnCt5tE/47i
gb/KHBpEsrF9LEp0cke69csvUzLSaVyv5yoRaZvpoO8XWUEGryiIO8r2c95PAYF/
kotpoVtqtnxMSC+P57XQrW8QfQ/HdrTA2BCA2Pc9xwJ6e37w3/ndT4DOuxn24ssa
9lkoi7QokyI0qDBSPVRTe6rpicqyt3fFHYo9eSTauliQ+/vNb0+vL33lkAvGeTro
kJHx5Cz5gr3k8Ty/O4BLtbjU2zk8/soOdBx+eg49rL/4TEWbC6/LSzIeWobCqFPK
XGscfAjTK9j6oBviJRawpSjTMhB7Fikq2Kf6M/OTG9sxUYhi/zheIjB0YOiWszq5
AnSS/dasTx5jj224oZyNTILOeuKAgkN1Rn1NwRxqQjWFEuoSePIfo3dgak5MbyoI
Eb6HfM8UQih45yuGcdYxvQqesAse1Aql2xSUGV1yB+/MB9KfKIaY6+bRiO9AFa7G
L7mSgnQxRpxtjsdeNlV4
=fakw
-----END PGP SIGNATURE-----

--7J16OGEJ/mt06A90--

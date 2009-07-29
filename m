Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zbasel.fortytwo.ch ([193.138.215.60]:47290 "EHLO
	zbasel.fortytwo.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbZG2Svp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 14:51:45 -0400
From: Adrian von Bidder <avbidder@fortytwo.ch>
To: Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: ath5k connection loss (failed to wakeup the MAC Chip)
Date: Wed, 29 Jul 2009 12:11:15 +0200
Cc: linux-wireless@vger.kernel.org
References: <200907280838.42541@fortytwo.ch> <40f31dec0907281653g63375736id57f547a8ba12cad@mail.gmail.com>
In-Reply-To: <40f31dec0907281653g63375736id57f547a8ba12cad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7058764.8rLeEex8sC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200907291211.21133@fortytwo.ch>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart7058764.8rLeEex8sC
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

On Wednesday 29 July 2009 01.53:18 Nick Kossifidis wrote:
> 2009/7/28 Adrian von Bidder <avbidder@fortytwo.ch>:
> > Heyho!
> >
> > (This is using kernel 2.6.31-rc3 as packaged by Debian)
> >
> > While taking a full backup of my laptop, I noticed that after a few
> > 100M the ath5k can't connect to WLAN anymore.
>
> Working on it, can you please post the part when ath5k loads ?

$ dmesg | grep -5 ath5
[   10.837434] usbcore: registered new interface driver uvcvideo
[   10.837444] USB Video Class driver (v0.1.0)                 =20
[   11.058396] Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps: 0x=
d04771/0xa40000                                                            =
         =20
[   11.100259] ACPI: WMI: Mapper loaded                                    =
    =20
[   11.116172] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042=
/serio2/input/input3                                                       =
         =20
[   11.152799] ath5k 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ =
18
[   11.152843] ath5k 0000:03:00.0: setting latency timer to 64
[   11.152938] ath5k 0000:03:00.0: registered as 'phy0'
[   11.160210] acer-wmi: Acer Laptop ACPI-WMI Extras  =20
[   11.160218] acer-wmi: Blacklisted hardware detected - not loading
[   11.227537] ath: EEPROM regdomain: 0x65                         =20
[   11.227546] ath: EEPROM indicates we should expect a direct regpair map
[   11.227557] ath: Country alpha2 being used: 00                        =20
=2D-
[   13.449969] ACPI: Video Device [OVGA] (multi-head: yes  rom: yes  post: =
no)
[   13.500020] Clocksource tsc unstable (delta =3D -353758420 ns)          =
    =20
[   13.602489] ACPI: AC Adapter [ACAD] (on-line)                           =
  =20
[   13.602714] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input7                                                            =
         =20
[   13.872882] phy0: Selected rate control algorithm 'minstrel'            =
    =20
[   13.875055] Registered led device: ath5k-phy0::rx
[   13.875106] Registered led device: ath5k-phy0::tx
[   13.875116] ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[   14.047189] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> =
IRQ 16                                                                     =
         =20
[   14.047271] HDA Intel 0000:00:1b.0: setting latency timer to 64         =
    =20
[   14.160144] ACPI: Lid Switch [LID0]                                     =
    =20
[   14.160386] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
E:00/input/input8                                                          =
         =20
[   14.160502] ACPI: Sleep Button [SLPB]                                   =
    =20

(btw, in my case the laptop probably went through suspend to ram/resume=20
before I started the backup.  Don't know if that has any influence.)

cheers
=2D- vbi

cheers
=2D- vbi

=2D-=20
featured product: ClamAV Antivirus - http://www.clamav.net/


--nextPart7058764.8rLeEex8sC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: get my key from http://fortytwo.ch/gpg/92082481

iKcEABECAGcFAkpwIERgGmh0dHA6Ly9mb3J0eXR3by5jaC9sZWdhbC9ncGcvZW1h
aWwuMjAwMjA4MjI/dmVyc2lvbj0xLjUmbWQ1c3VtPTVkZmY4NjhkMTE4NDMyNzYw
NzFiMjVlYjcwMDZkYTNlAAoJECqqZti935l6desAoID5px5fBx/achbxv48uPr66
uydiAKC6Qd3THBFm8XjsX6nValmAO7G3LA==
=zMSt
-----END PGP SIGNATURE-----

--nextPart7058764.8rLeEex8sC--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout.hostsharing.net ([83.223.95.98]:43024 "EHLO
	smtpout.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758181AbXKOSVw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 13:21:52 -0500
Date: Thu, 15 Nov 2007 19:21:44 +0100
From: Elimar Riesebieter <riesebie@lxtec.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 2.6.24-rc1 freezes on powerbook at first boot stage
Message-ID: <20071115182144.GA3199@samweis.home.lxtec.de> (sfid-20071115_182155_176978_F93C92D1)
References: <20071024120739.GA4897@aragorn.home.lxtec.de> <20071024124109.GA9442@frodo.home.lxtec.de> <20071104032006.GG9695@localdomain> <20071113220235.GB9008@frodo.home.lxtec.de> <1195053964.4091.20.camel@johannes.berg> <20071114193340.GA14921@frodo.home.lxtec.de> <1195145325.13846.70.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
In-Reply-To: <1195145325.13846.70.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Nov 2007 the mental interface of
Johannes Berg told:

>=20
> > > [FWIW, my powerbook worked with -rc1]
> > >=20
> > > > 2.6.24-rc2 works so lala :)
> > >=20
> > > > b43 doesn't authenticate via wpa (bluetooth isn't loaded):
> > > > WEXT auth param 4 value 0x0 - ioctl[SIOCSIWAUTH]: Operation not sup=
ported
> > > > WEXT auth param 5 value 0x1 - Internet Systems Consortium DHCP Clie=
nt V3.1.0
> > >=20
> > > Those error messages are unrelated. My b43 works fine, even with a
> > > multi-MAC patch.
> >=20
> > I tried it as follows:
> >=20
> > wpa_supplicant -Dwext -ieth2 -c/etc/wpa_supplicant/wpa_supplicant.conf
> >=20
> > eth2 is renamed by udev via MAC address.
> >=20
> > b43-fwcutter intalled
> >=20
> > Could you please enlighten me.
>=20
> Well, you haven't said what broke. Those "error" messages above are
> perfectlly normal.

wmaster0  no wireless extensions.

wlan0     IEEE 802.11g  ESSID:"" =20
          Mode:Managed  Channel:0  Access Point: Not-Associated  =20
          Tx-Power=3D0 dBm  =20
          Retry min limit:7   RTS thr:off   Fragment thr=3D2346 B  =20
          Link Quality:0  Signal level:0  Noise level:0
          wRx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

Nov 15 18:48:04 samweis kernel: b43-phy1 debug: Loading firmware version 35=
1.126 (2006-07-29 05:54:02)
Nov 15 18:48:05 samweis kernel: b43-phy1 debug: Chip initialized
Nov 15 18:48:05 samweis kernel: b43-phy1 debug: 30-bit DMA initialized
Nov 15 18:48:05 samweis kernel: input: Unspecified device as /devices/virtu=
al/input/input9
Nov 15 18:48:05 samweis kernel: b43-phy1 debug: Wireless interface started
Nov 15 18:48:05 samweis kernel: b43-phy1 debug: Adding Interface type 2
Nov 15 18:48:05 samweis kernel: ADDRCONF(NETDEV_UP): wlan0: link is not rea=
dy
Nov 15 18:48:31 samweis dhclient: Internet Systems Consortium DHCP Client V=
3.1.0
Nov 15 18:48:33 samweis dhclient: wmaster0: unknown hardware address type 8=
01

# ifconfig wlan0 up

Nov 15 18:51:01 samweis kernel: b43-phy1 debug: Removing Interface type 2
Nov 15 18:51:01 samweis kernel: b43-phy1 debug: Wireless interface stopped
Nov 15 18:51:01 samweis kernel: b43-phy1 debug: DMA-32 0x0200 (RX) max used=
 slots: 1/64
Nov 15 18:51:01 samweis kernel: b43-phy1 debug: DMA-32 0x02A0 (TX) max used=
 slots: 0/128
Nov 15 18:51:01 samweis kernel: b43-phy1 debug: DMA-32 0x0280 (TX) max used=
 slots: 0/128
Nov 15 18:51:01 samweis kernel: b43-phy1 debug: DMA-32 0x0260 (TX) max used=
 slots: 0/128
Nov 15 18:51:01 samweis kernel: b43-phy1 debug: DMA-32 0x0240 (TX) max used=
 slots: 0/128
Nov 15 18:51:01 samweis kernel: b43-phy1 debug: DMA-32 0x0220 (TX) max used=
 slots: 2/128
Nov 15 18:51:01 samweis kernel: b43-phy1 debug: DMA-32 0x0200 (TX) max used=
 slots: 0/128
Nov 15 18:51:29 samweis kernel: b43-phy1 debug: Loading firmware version 35=
1.126 (2006-07-29 05:54:02)
Nov 15 18:51:31 samweis kernel: b43-phy1 debug: Chip initialized
Nov 15 18:51:31 samweis kernel: b43-phy1 debug: 30-bit DMA initialized
Nov 15 18:51:31 samweis kernel: Unable to handle kernel paging request for =
data at address 0x7e13ed24
Nov 15 18:51:31 samweis kernel: Faulting instruction address: 0xc02b3060
Nov 15 18:51:31 samweis kernel: Oops: Kernel access of bad area, sig: 11 [#=
1]
Nov 15 18:51:31 samweis kernel: PowerMac
Nov 15 18:51:31 samweis kernel: Modules linked in: b43 firmware_class ssb r=
adeon drm hci_usb bluetooth autofs4 ipv6 nfs lockd sunrpc af_packet i2c_dev=
 apm_emu apm_emulation therm_adt746x ams appletouch arc4 usbhid ecb snd_aoa=
_codec_tas snd_aoa_fabric_layout snd_aoa rc80211_simple snd_aoa_i2sbus snd_=
pcm_oss snd_mixer_oss firewire_ohci firewire_core crc_itu_t snd_pcm mac8021=
1 cfg80211 snd_timer snd_page_alloc input_polldev ide_cd cdrom snd soundcor=
e snd_aoa_soundbus ehci_hcd ohci_hcd ohci1394 uninorth_agp sungem sungem_ph=
y evdev ieee1394 usbcore agpgart yenta_socket rsrc_nonstatic pcmcia_core un=
ix
Nov 15 18:51:31 samweis kernel: NIP: c02b3060 LR: c02b302c CTR: c02b2ff4
Nov 15 18:51:31 samweis kernel: REGS: c7517ca0 TRAP: 0300   Not tainted  (2=
=2E6.24-rc2-aragorn)
Nov 15 18:51:31 samweis kernel: MSR: 00009032 <EE,ME,IR,DR>  CR: 24084422  =
XER: 20000000
Nov 15 18:51:31 samweis kernel: DAR: 7e13ed24, DSISR: 40000000
Nov 15 18:51:31 samweis kernel: TASK =3D c1f81850[3943] 'wpa_supplicant' TH=
READ: c7516000
Nov 15 18:51:31 samweis kernel: GPR00: bdd880c4 c7517d50 c1f81850 c131f200 =
f1078164 00000000 00000000 00000010=20
Nov 15 18:51:31 samweis kernel: GPR08: 00000000 c03b0000 00000000 00000000 =
24084422 1006dbf8 00000000 00000006=20
Nov 15 18:51:31 samweis kernel: GPR16: 28244242 100a0000 00000001 100cfb80 =
c7517e58 ffff8914 c1cd1000 c1c7ad40=20
Nov 15 18:51:31 samweis kernel: GPR24: c1de5808 c1cf6de0 c1306000 c03b6c60 =
c0385e24 c0385d70 00000000 c131f200=20
Nov 15 18:51:31 samweis kernel: NIP [c02b3060] rfkill_register+0x6c/0x12c
Nov 15 18:51:31 samweis kernel: LR [c02b302c] rfkill_register+0x38/0x12c
Nov 15 18:51:31 samweis kernel: Call Trace:
Nov 15 18:51:31 samweis kernel: [c7517d50] [c02b302c] rfkill_register+0x38/=
0x12c (unreliable)
Nov 15 18:51:31 samweis kernel: [c7517d70] [f26fd594] b43_rfkill_init+0x24/=
0xb0 [b43]
Nov 15 18:51:31 samweis kernel: [c7517d80] [f26ed324] b43_wireless_core_ini=
t+0x614/0x780 [b43]
Nov 15 18:51:31 samweis kernel: [c7517db0] [f26ee254] b43_start+0x94/0xa4 [=
b43]
Nov 15 18:51:31 samweis kernel: [c7517dd0] [f24b2dac] ieee80211_open+0x1a0/=
0x3e4 [mac80211]
Nov 15 18:51:31 samweis kernel: [c7517e00] [c024b29c] dev_open+0xb0/0xe8
Nov 15 18:51:31 samweis kernel: [c7517e10] [c024a08c] dev_change_flags+0x90=
/0x1c0
Nov 15 18:51:31 samweis kernel: [c7517e30] [c02922e0] devinet_ioctl+0x620/0=
x784
Nov 15 18:51:31 samweis kernel: [c7517ea0] [c02929c8] inet_ioctl+0xcc/0xf8
Nov 15 18:51:31 samweis kernel: [c7517eb0] [c023b22c] sock_ioctl+0x100/0x2b8
Nov 15 18:51:31 samweis kernel: [c7517ed0] [c0097e8c] do_ioctl+0x34/0x98
Nov 15 18:51:31 samweis kernel: [c7517ee0] [c00981c4] vfs_ioctl+0x2d4/0x424
Nov 15 18:51:31 samweis kernel: [c7517f10] [c0098354] sys_ioctl+0x40/0x74
Nov 15 18:51:31 samweis kernel: [c7517f40] [c0011c28] ret_from_syscall+0x0/=
0x38
Nov 15 18:51:31 samweis kernel: --- Exception: c01 at 0xfcb77fc
Nov 15 18:51:31 samweis kernel:     LR =3D 0xfcb7760
Nov 15 18:51:31 samweis kernel: Instruction dump:
Nov 15 18:51:31 samweis kernel: 4182001c 80010024 7fc3f378 bb61000c 3821002=
0 7c0803a6 4e800020 801f0004=20
Nov 15 18:51:31 samweis kernel: 3d20c03b 7fe3fb78 3b696c60 5400103a <7c9b00=
2e> 4bfffa25 7c7e1b79 40820074=20

This is with debugging on.

Elimar


--=20
  You cannot propel yourself forward by
  patting yourself on the back.

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHPI433Ig8bsVPf7ARAtwUAKCIRnyArqOBwgAWzYiOImvnbJh5zgCgpiVV
4ivyJjBY9SyNatTKKfI8JAs=
=gkIP
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--

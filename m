Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:37144 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935569Ab3IEKMH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Sep 2013 06:12:07 -0400
Date: Thu, 5 Sep 2013 12:09:14 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org
Subject: WARNING with ath9k_htc on TL-WN721N
Message-ID: <20130905100914.GA1570@ritirata.org> (sfid-20130905_121215_308088_E618288F)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello list,=20

I ma connected to my WPA2-PSK protected network and from time to time I get=
 the
following warning in dmesg. I don't experience any malfunctionng but I thou=
ght
it was worth reporting. My kernel version is linux-3.10.10. I remember I've=
 seen
this warning also with previous versions.

The device I use is a TP-LINK TL-WN721N.
lsusb says:

Bus 002 Device 003: ID 0cf3:9271 Atheros Communications, Inc. AR9271 802.11n

Cheers,

[ 7762.963117] ------------[ cut here ]------------
[ 7762.963127] WARNING: at drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:501
ath9k_htc_tx_process+0x36b/0x380 [ath9k_htc]()
[ 7762.963129] Modules linked in: usbhid btusb bluetooth ftdi_sio usbserial
ath9k_htc ath9k_common ath9k_hw ath acpi_cpufreq mperf kvm_intel kvm
crc32c_intel iwldvm mac80211 ghash_clmulni_intel snd_hda_codec_hdmi
snd_hda_codec_idt aesni_intel ehci_pci iwlwifi snd_hda_intel snd_hda_codec
ehci_hcd snd_hwdep cfg80211 aes_x86_64 snd_pcm snd_page_alloc snd_timer usb=
core
snd lrw gf128mul lpc_ich glue_helper usb_common ablk_helper psmouse soundco=
re
cryptd
[ 7762.963159] CPU: 0 PID: 512 Comm: X Tainted: G        W    3.10.10-gento=
o #2
[ 7762.963161] Hardware name: Dell Inc. Latitude E5420/0675PR, BIOS A01
04/20/2011
[ 7762.963163]  ffffffff814bf8ea ffffffff81034886 ffff8802249a9cf0
ffff880221bf17a0
[ 7762.963166]  ffff880221bf1d50 0000000000000000 0000000000004188
ffffffffa05a316b
[ 7762.963169]  ffffffffa05a2d9c 0000000000000000 ffff88022489860d
ffff880221bf17a0
[ 7762.963172] Call Trace:
[ 7762.963174]  <IRQ>  [<ffffffff814bf8ea>] ? dump_stack+0xc/0x15
[ 7762.963183]  [<ffffffff81034886>] ? warn_slowpath_common+0x56/0x70
[ 7762.963187]  [<ffffffffa05a316b>] ? ath9k_htc_tx_process+0x36b/0x380
[ath9k_htc]
[ 7762.963191]  [<ffffffffa05a2d9c>] ? ath9k_htc_tx_get_packet+0x12c/0x190
[ath9k_htc]
[ 7762.963195]  [<ffffffffa05a3a7e>] ? ath9k_htc_txstatus+0x2e/0x120 [ath9k=
_htc]
[ 7762.963198]  [<ffffffffa05a274e>] ? ath9k_wmi_event_tasklet+0x12e/0x150
[ath9k_htc]
[ 7762.963202]  [<ffffffff8103b44a>] ? tasklet_action+0x5a/0xc0
[ 7762.963205]  [<ffffffff8103b9b6>] ? __do_softirq+0xd6/0x1b0
[ 7762.963209]  [<ffffffff8103bbfd>] ? irq_exit+0xbd/0xd0
[ 7762.963212]  [<ffffffff81004819>] ? do_IRQ+0x49/0xb0
[ 7762.963215]  [<ffffffff814c51aa>] ? common_interrupt+0x6a/0x6a
[ 7762.963216]  <EOI>  [<ffffffff81080f62>] ? smp_call_function_many+0x222/=
0x280
[ 7762.963224]  [<ffffffff812dc7c0>] ? i915_restore_state+0x960/0x960
[ 7762.963226]  [<ffffffff812dc7c0>] ? i915_restore_state+0x960/0x960
[ 7762.963229]  [<ffffffff81080fe9>] ? smp_call_function+0x29/0x60
[ 7762.963232]  [<ffffffff81081041>] ? on_each_cpu+0x21/0x70
[ 7762.963235]  [<ffffffff812dcd23>] ? i915_gem_object_update_fence+0xf3/0x=
100
[ 7762.963238]  [<ffffffff812df18d>] ? i915_gem_object_get_fence+0x6d/0x1f0
[ 7762.963241]  [<ffffffff812e12f0>] ? i915_gem_fault+0x1c0/0x210
[ 7762.963244]  [<ffffffff810d6516>] ? __do_fault+0x66/0x4f0
[ 7762.963248]  [<ffffffff812b57a5>] ? drm_gem_object_lookup+0x55/0xa0
[ 7762.963251]  [<ffffffff810d92b7>] ? handle_pte_fault+0x87/0x850
[ 7762.963254]  [<ffffffff8102a38d>] ? __do_page_fault+0x11d/0x440
[ 7762.963257]  [<ffffffff810e0678>] ? do_mmap_pgoff+0x2f8/0x3b0
[ 7762.963261]  [<ffffffff8106ac71>] ? cpuacct_account_field+0x11/0x60
[ 7762.963264]  [<ffffffff8102a6f2>] ? do_page_fault+0x22/0x40
[ 7762.963267]  [<ffffffff814c53e2>] ? page_fault+0x22/0x30
[ 7762.963269] ---[ end trace 3c536c5012f2e043 ]---


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSKFhJAAoJEADl0hg6qKeOmUkP/3wUPV7d4YF/1ZE4pLY28zF5
aCKpScOhJ3DgJvfAqP3CXMNIWk0uTziSHLuW4P4zbNXOLWmWukToeNtARIVYWQcY
LkQEK8PWqXzgiZALZQ1QmZhXpiU+GPptzVTeIk/iadUlDdsx6vOOj4YOd0znF+pW
YcCGIKTH0T8Ltz5PhBXZLXkTTnewnmp6FmllaViwFnkQS2BY59tnbA8ER4c40H/5
EOQ4BkgIx3AawbeW1pHoM35xPEHnnj5rweQKX7ZQ4eyLln/kTf1SHtfhuHhQ/skV
NLz1k3HQXXvOwzuh1BGb49QYtjW5PG2g7OHGpFIMjTO/8wQ/FHlRFGTYo2VNBUpP
Ahgd/XU+0NG0D88Sw3hcARiw2x3M+Mn3Z1PD/v1TqUcIWJlrgkrbaNi1UKwvTuWi
CJ1bUT09bY4FYyxxkKRlnct4gssanHxACQxNIr+m+TRIhfdbiaFXArzB00P2+SPY
ZxyD2vHaZGZAmYoS7haj5TRnuZPll/Q23CV9HxYXz+RbRyCSL0Wli1hI7+Mo0qO9
rgSxJUkjKTzQ2PN+H/dHLNSoHoUTT4PpD/LrQu7V5XcPGYZHVZxqpwJZ/m2RHUmH
4uTeKspxW2gnpD7+SASinwvurTLO04QPaY3dVMuIjjEMNX7YdBJEZ3YJTDByBlCr
Z5D/8QBgZnA3ICMLB/OY
=Coiu
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--

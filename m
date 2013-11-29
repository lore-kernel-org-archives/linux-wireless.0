Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from winsoft.com.pl ([109.234.111.213]:46700 "EHLO winsoft.com.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662Ab3K2TtU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 14:49:20 -0500
Received: from static-78-9-71-254.ssp.dialog.net.pl ([78.9.71.254]:54330 helo=[192.168.10.30])
	by az0044.srv.az.pl with esmtpsa (TLSv1:DHE-RSA-AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <kkolasa@winsoft.pl>)
	id 1VmThW-001kNK-4V
	for linux-wireless@vger.kernel.org; Fri, 29 Nov 2013 20:26:06 +0100
Message-ID: <5298EA48.1050206@winsoft.pl> (sfid-20131129_204934_655986_57747678)
Date: Fri, 29 Nov 2013 20:26:00 +0100
From: Krzysztof Kolasa <kkolasa@winsoft.pl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: WARNING: CPU: 2 PID: 827 at net/wireless/sme.c:795 cfg80211_roamed+0x97/0xa0
 [cfg80211]()
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms060304040908090603060809"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060304040908090603060809
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: quoted-printable

syslog trace:

Nov 29 15:09:52 krzysiek-hp1 kernel: [25459.769263] ------------[ cut=20
here ]------------
Nov 29 15:09:52 krzysiek-hp1 kernel: [25459.769318] WARNING: CPU: 2 PID: =

827 at net/wireless/sme.c:795 cfg80211_roamed+0x97/0xa0 [cfg80211]()
Nov 29 15:09:52 krzysiek-hp1 kernel: [25459.769322] Modules linked in:=20
xts(F) gf128mul(F) dm_crypt(F) pci_stub(F) vboxpci(OF) vboxnetadp(OF)=20
vboxnetflt(OF) vboxdrv(OF) bnep(F) rfcomm(F) bluetooth(F) binfmt_misc(F) =

fglrx(POF) lib80211_crypt_tkip(F) wl(POF) snd_hda_codec_hdmi(F)=20
snd_hda_codec_idt(F) snd_hda_intel(F) uvcvideo(F) snd_hda_codec(F)=20
snd_hwdep(F) videobuf2_core(F) videodev(F) snd_pcm(F)=20
videobuf2_vmalloc(F) videobuf2_memops(F) snd_seq_midi(F) snd_rawmidi(F)=20
snd_seq_midi_event(F) snd_seq(F) psmouse(F) snd_timer(F)=20
snd_seq_device(F) hp_wmi(F) serio_raw(F) sparse_keymap(F) joydev(F)=20
cfg80211(F) video(F) snd(F) tpm_infineon(F) soundcore(F) hp_accel(F)=20
lib80211(F) amd_iommu_v2(F) lis3lv02d(F) lpc_ich(F) snd_page_alloc(F)=20
wmi(F) tpm_tis(F) input_polldev(F) ppdev(F) mac_hid(F) parport_pc(F)=20
lp(F) parport(F) hid_generic(F) usbhid(F) hid(F) firewire_ohci(F)=20
firewire_core(F) ahci(F) crc_itu_t(F) libahci(F) sdhci_pci(F) sdhci(F)=20
e1000e(F) ptp(F) pps_core(F)
Nov 29 15:09:52 krzysiek-hp1 kernel: [25459.769424] CPU: 2 PID: 827=20
Comm: wl_event_handle Tainted: PF          O 3.13.0-rc1-winsoft-x64 #6
Nov 29 15:09:52 krzysiek-hp1 kernel: [25459.769428] Hardware name:=20
Hewlett-Packard HP ProBook 6560b/1619, BIOS 68SCE Ver. F.42 07/15/2013
Nov 29 15:09:52 krzysiek-hp1 kernel: [25459.769433] 000000000000031b=20
ffff880231cabd48 ffffffff816e58f6 0000000000000007
Nov 29 15:09:52 krzysiek-hp1 kernel: [25459.769441] 0000000000000000=20
ffff880231cabd88 ffffffff8104fbdc ffff880036cbae1a
Nov 29 15:09:52 krzysiek-hp1 kernel: [25459.769449] ffff88023169b000=20
ffff880230335080 00000000000000a2 ffff8800aa03bf00
Nov 29 15:09:52 krzysiek-hp1 kernel: [25459.769456] Call Trace:
Nov 29 15:09:52 krzysiek-hp1 kernel: [25459.769472] [<ffffffff816e58f6>] =

dump_stack+0x46/0x58
Nov 29 15:09:52 krzysiek-hp1 kernel: [25459.769483] [<ffffffff8104fbdc>] =

warn_slowpath_common+0x8c/0xc0
Nov 29 15:09:52 krzysiek-hp1 kernel: [25459.769491] [<ffffffff8104fc2a>] =

warn_slowpath_null+0x1a/0x20
Nov 29 15:09:52 krzysiek-hp1 kernel: [25459.769520] [<ffffffffa01b3907>] =

cfg80211_roamed+0x97/0xa0 [cfg80211]
Nov 29 15:09:52 krzysiek-hp1 kernel: [25459.769597] [<ffffffffa04b9a23>] =

wl_bss_connect_done.isra.18+0xa3/0x1b0 [wl]
Nov 29 15:09:52 krzysiek-hp1 kernel: [25459.769663] [<ffffffffa04b9ca6>] =

wl_notify_connect_status+0x176/0x340 [wl]
Nov 29 15:09:52 krzysiek-hp1 kernel: [25459.769726] [<ffffffffa04b7c35>] =

wl_event_handler+0x55/0x1e0 [wl]
Nov 29 15:09:52 krzysiek-hp1 kernel: [25459.769787] [<ffffffffa04b7be0>] =

? wl_create_event_handler+0xc0/0xc0 [wl]
Nov 29 15:09:52 krzysiek-hp1 kernel: [25459.769795] [<ffffffff81072f29>] =

kthread+0xc9/0xe0
Nov 29 15:09:52 krzysiek-hp1 kernel: [25459.769803] [<ffffffff81072e60>] =

? flush_kthread_worker+0xb0/0xb0
Nov 29 15:09:52 krzysiek-hp1 kernel: [25459.769811] [<ffffffff816fc6ec>] =

ret_from_fork+0x7c/0xb0
Nov 29 15:09:52 krzysiek-hp1 kernel: [25459.769818] [<ffffffff81072e60>] =

? flush_kthread_worker+0xb0/0xb0
Nov 29 15:09:52 krzysiek-hp1 kernel: [25459.769823] ---[ end trace=20
643f04fdb2db61b9 ]---

This problem is reported on fedora project retrace and looks that began=20
with the kernel version 3.10.9

http://retrace.fedoraproject.org/faf/reports/197610/




--------------ms060304040908090603060809
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
bDBaBggrBgEFBQcBAQROMEwwIQYIKwYBBQUHMAGGFWh0dHA6Ly9vY3NwLmNlcnR1bS5wbDAn
BggrBgEFBQcwAoYbaHR0cDovL3d3dy5jZXJ0dW0ucGwvbDMuY2VyMB8GA1UdIwQYMBaAFATJ
2prcSkl3rzADBGYux87y+Bd9MB0GA1UdDgQWBBSDc5sJYMsdTdjm9qQWXUehbDVLgzAOBgNV
HQ8BAf8EBAMCBPAwggE9BgNVHSAEggE0MIIBMDCCASwGCiqEaAGG9ncCAgMwggEcMCUGCCsG
AQUFBwIBFhlodHRwczovL3d3dy5jZXJ0dW0ucGwvQ1BTMIHyBggrBgEFBQcCAjCB5TAgFhlV
bml6ZXRvIFRlY2hub2xvZ2llcyBTLkEuMAMCAQEagcBVc2FnZSBvZiB0aGlzIGNlcnRpZmlj
YXRlIGlzIHN0cmljdGx5IHN1YmplY3RlZCB0byB0aGUgQ0VSVFVNIENlcnRpZmljYXRpb24g
UHJhY3RpY2UgU3RhdGVtZW50IChDUFMpIGluY29ycG9yYXRlZCBieSByZWZlcmVuY2UgaGVy
ZWluIGFuZCBpbiB0aGUgcmVwb3NpdG9yeSBhdCBodHRwczovL3d3dy5jZXJ0dW0ucGwvcmVw
b3NpdG9yeS4wHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBEGCWCGSAGG+EIBAQQE
AwIFoDAdBgNVHREEFjAUgRJra29sYXNhQHdpbnNvZnQucGwwDQYJKoZIhvcNAQEFBQADggEB
AAI98P3y5OBE/SLnwBNQNjmR+wcvZAUX5/xSZ6KHnVHzKPTZlGySNl1TrhAWnCRDthm92Kdu
zPtSaGflQZhEfG5DutK1EgIAHMBYDRV4jEZztFHZVfkDxPXgnR0XRFmb3xquNODcCt3SIKDv
J9JA5UHrzWJ9DsKUWbaZAV7NdK454aabllpHzjmagL76HqIRRuT0wwpn+pyGkU68gDFfOlZ0
s9Htz5YMcmBwTmuLbYxAgM+aHYXhhqdf7w3m84YL9QviZRhW+TsvDdRy6g3GnUJXQ1r8i/FC
Q3nukRRa0sz0Db1SyDiCFO171v8VpJO4L8r6DzMK36RBc8A5g9cOSXkxggPFMIIDwQIBATCB
jDB4MQswCQYDVQQGEwJQTDEiMCAGA1UEChMZVW5pemV0byBUZWNobm9sb2dpZXMgUy5BLjEn
MCUGA1UECxMeQ2VydHVtIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MRwwGgYDVQQDExNDZXJ0
dW0gTGV2ZWwgSUlJIENBAhABw4d6KSuqDFcuWaNhb8SaMAkGBSsOAwIaBQCgggINMBgGCSqG
SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTEzMTEyOTE5MjYwMFowIwYJ
KoZIhvcNAQkEMRYEFNJdlubuALb0xyUvif31u3qDDaNjMGwGCSqGSIb3DQEJDzFfMF0wCwYJ
YIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYI
KoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZ0GCSsGAQQBgjcQBDGBjzCB
jDB4MQswCQYDVQQGEwJQTDEiMCAGA1UEChMZVW5pemV0byBUZWNobm9sb2dpZXMgUy5BLjEn
MCUGA1UECxMeQ2VydHVtIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MRwwGgYDVQQDExNDZXJ0
dW0gTGV2ZWwgSUlJIENBAhABw4d6KSuqDFcuWaNhb8SaMIGfBgsqhkiG9w0BCRACCzGBj6CB
jDB4MQswCQYDVQQGEwJQTDEiMCAGA1UEChMZVW5pemV0byBUZWNobm9sb2dpZXMgUy5BLjEn
MCUGA1UECxMeQ2VydHVtIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MRwwGgYDVQQDExNDZXJ0
dW0gTGV2ZWwgSUlJIENBAhABw4d6KSuqDFcuWaNhb8SaMA0GCSqGSIb3DQEBAQUABIIBAMo2
2ZlhV99KGfFXAhJ1zo4EfEg+uvek/cLa5wOIMTrCI4aFmhlXOq+Nt3clvUPQsEfr0hj9ybxu
AgJ83XJoJUqVAiqp5x8hZ6KsepZpNbvjXF9HLK9ZA1VU3y+QADIWUPIVsOST1DsMOAchhX62
0sNcgIUNovHV490ElJ7sIM1pbsLP+SIu5YlEs4dPV7JjGqy8DERG900i/ZJcHyOgex6aZsw8
XyVjZ3SEW20SuuXpBfs/2WmsCQGbNKDjhMvTZooOQM+nMNjD14W596oCw4/ZPIIXJ3gPZ/Pg
XVQn/F2DnSyoKyU2hSoZWWuFZ6XCogeev8OasptbTiHD6mHiK1kAAAAAAAA=
--------------ms060304040908090603060809--

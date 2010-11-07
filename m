Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:50949 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751966Ab0KGSgm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Nov 2010 13:36:42 -0500
Content-Type: multipart/mixed; boundary="========GMX316561289154999263298"
Date: Sun, 07 Nov 2010 19:36:39 +0100
From: "Werner Nagel" <werner.nagel@gmx.de>
Message-ID: <20101107183639.316560@gmx.net>
MIME-Version: 1.0
Subject: bug in wireless driver
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--========GMX316561289154999263298
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

I would like to send you a bug report from linux (ubunto) and wireless driver b43.
There is the file with the kernel-log and a file with the ouput from lspci -k.
Thank you from Germany

Werner Nagel
-- 
GRATIS! Movie-FLAT mit über 300 Videos. 
Jetzt freischalten unter http://portal.gmx.net/de/go/maxdome

--========GMX316561289154999263298
Content-Type: application/octet-stream; name="output_lspci"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="output_lspci"

MDA6MDAuMCBIb3N0IGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gQ29yZSBQcm9jZXNzb3IgRFJB
TSBDb250cm9sbGVyIChyZXYgMTIpCglLZXJuZWwgbW9kdWxlczogaW50ZWwtYWdwCjAwOjAxLjAg
UENJIGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gQ29yZSBQcm9jZXNzb3IgUENJIEV4cHJlc3Mg
eDE2IFJvb3QgUG9ydCAocmV2IDEyKQoJS2VybmVsIGRyaXZlciBpbiB1c2U6IHBjaWVwb3J0CglL
ZXJuZWwgbW9kdWxlczogc2hwY2hwCjAwOjE2LjAgQ29tbXVuaWNhdGlvbiBjb250cm9sbGVyOiBJ
bnRlbCBDb3Jwb3JhdGlvbiA1IFNlcmllcy8zNDAwIFNlcmllcyBDaGlwc2V0IEhFQ0kgQ29udHJv
bGxlciAocmV2IDA2KQowMDoxYS4wIFVTQiBDb250cm9sbGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiA1
IFNlcmllcy8zNDAwIFNlcmllcyBDaGlwc2V0IFVTQjIgRW5oYW5jZWQgSG9zdCBDb250cm9sbGVy
IChyZXYgMDYpCglLZXJuZWwgZHJpdmVyIGluIHVzZTogZWhjaV9oY2QKMDA6MWIuMCBBdWRpbyBk
ZXZpY2U6IEludGVsIENvcnBvcmF0aW9uIDUgU2VyaWVzLzM0MDAgU2VyaWVzIENoaXBzZXQgSGln
aCBEZWZpbml0aW9uIEF1ZGlvIChyZXYgMDYpCglLZXJuZWwgZHJpdmVyIGluIHVzZTogSERBIElu
dGVsCglLZXJuZWwgbW9kdWxlczogc25kLWhkYS1pbnRlbAowMDoxYy4wIFBDSSBicmlkZ2U6IElu
dGVsIENvcnBvcmF0aW9uIDUgU2VyaWVzLzM0MDAgU2VyaWVzIENoaXBzZXQgUENJIEV4cHJlc3Mg
Um9vdCBQb3J0IDEgKHJldiAwNikKCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiBwY2llcG9ydAoJS2Vy
bmVsIG1vZHVsZXM6IHNocGNocAowMDoxYy4xIFBDSSBicmlkZ2U6IEludGVsIENvcnBvcmF0aW9u
IDUgU2VyaWVzLzM0MDAgU2VyaWVzIENoaXBzZXQgUENJIEV4cHJlc3MgUm9vdCBQb3J0IDIgKHJl
diAwNikKCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiBwY2llcG9ydAoJS2VybmVsIG1vZHVsZXM6IHNo
cGNocAowMDoxYy41IFBDSSBicmlkZ2U6IEludGVsIENvcnBvcmF0aW9uIDUgU2VyaWVzLzM0MDAg
U2VyaWVzIENoaXBzZXQgUENJIEV4cHJlc3MgUm9vdCBQb3J0IDYgKHJldiAwNikKCUtlcm5lbCBk
cml2ZXIgaW4gdXNlOiBwY2llcG9ydAoJS2VybmVsIG1vZHVsZXM6IHNocGNocAowMDoxZC4wIFVT
QiBDb250cm9sbGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiA1IFNlcmllcy8zNDAwIFNlcmllcyBDaGlw
c2V0IFVTQjIgRW5oYW5jZWQgSG9zdCBDb250cm9sbGVyIChyZXYgMDYpCglLZXJuZWwgZHJpdmVy
IGluIHVzZTogZWhjaV9oY2QKMDA6MWUuMCBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiA4
MjgwMSBNb2JpbGUgUENJIEJyaWRnZSAocmV2IGE2KQowMDoxZi4wIElTQSBicmlkZ2U6IEludGVs
IENvcnBvcmF0aW9uIE1vYmlsZSA1IFNlcmllcyBDaGlwc2V0IExQQyBJbnRlcmZhY2UgQ29udHJv
bGxlciAocmV2IDA2KQoJS2VybmVsIG1vZHVsZXM6IGlUQ09fd2R0CjAwOjFmLjIgU0FUQSBjb250
cm9sbGVyOiBJbnRlbCBDb3Jwb3JhdGlvbiA1IFNlcmllcy8zNDAwIFNlcmllcyBDaGlwc2V0IDQg
cG9ydCBTQVRBIEFIQ0kgQ29udHJvbGxlciAocmV2IDA2KQoJS2VybmVsIGRyaXZlciBpbiB1c2U6
IGFoY2kKCUtlcm5lbCBtb2R1bGVzOiBhaGNpCjAwOjFmLjMgU01CdXM6IEludGVsIENvcnBvcmF0
aW9uIDUgU2VyaWVzLzM0MDAgU2VyaWVzIENoaXBzZXQgU01CdXMgQ29udHJvbGxlciAocmV2IDA2
KQoJS2VybmVsIG1vZHVsZXM6IGkyYy1pODAxCjAyOjAwLjAgVkdBIGNvbXBhdGlibGUgY29udHJv
bGxlcjogQVRJIFRlY2hub2xvZ2llcyBJbmMgTTkyIExQIFtNb2JpbGl0eSBSYWRlb24gSEQgNDMw
MCBTZXJpZXNdCglLZXJuZWwgZHJpdmVyIGluIHVzZTogcmFkZW9uCglLZXJuZWwgbW9kdWxlczog
cmFkZW9uCjAyOjAwLjEgQXVkaW8gZGV2aWNlOiBBVEkgVGVjaG5vbG9naWVzIEluYyBSVjcxMC83
MzAKCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiBIREEgSW50ZWwKCUtlcm5lbCBtb2R1bGVzOiBzbmQt
aGRhLWludGVsCjA0OjAwLjAgTmV0d29yayBjb250cm9sbGVyOiBCcm9hZGNvbSBDb3Jwb3JhdGlv
biBCQ000MzEyIDgwMi4xMWIvZyAocmV2IDAxKQoJS2VybmVsIGRyaXZlciBpbiB1c2U6IGI0My1w
Y2ktYnJpZGdlCglLZXJuZWwgbW9kdWxlczogc3NiCjA1OjAwLjAgRXRoZXJuZXQgY29udHJvbGxl
cjogUmVhbHRlayBTZW1pY29uZHVjdG9yIENvLiwgTHRkLiBSVEw4MTAxRS9SVEw4MTAyRSBQQ0kg
RXhwcmVzcyBGYXN0IEV0aGVybmV0IGNvbnRyb2xsZXIgKHJldiAwMikKCUtlcm5lbCBkcml2ZXIg
aW4gdXNlOiByODE2OQoJS2VybmVsIG1vZHVsZXM6IHI4MTY5CmZmOjAwLjAgSG9zdCBicmlkZ2U6
IEludGVsIENvcnBvcmF0aW9uIENvcmUgUHJvY2Vzc29yIFF1aWNrUGF0aCBBcmNoaXRlY3R1cmUg
R2VuZXJpYyBOb24tY29yZSBSZWdpc3RlcnMgKHJldiAwMikKZmY6MDAuMSBIb3N0IGJyaWRnZTog
SW50ZWwgQ29ycG9yYXRpb24gQ29yZSBQcm9jZXNzb3IgUXVpY2tQYXRoIEFyY2hpdGVjdHVyZSBT
eXN0ZW0gQWRkcmVzcyBEZWNvZGVyIChyZXYgMDIpCmZmOjAyLjAgSG9zdCBicmlkZ2U6IEludGVs
IENvcnBvcmF0aW9uIENvcmUgUHJvY2Vzc29yIFFQSSBMaW5rIDAgKHJldiAwMikKZmY6MDIuMSBI
b3N0IGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gQ29yZSBQcm9jZXNzb3IgUVBJIFBoeXNpY2Fs
IDAgKHJldiAwMikKZmY6MDIuMiBIb3N0IGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gQ29yZSBQ
cm9jZXNzb3IgUmVzZXJ2ZWQgKHJldiAwMikKZmY6MDIuMyBIb3N0IGJyaWRnZTogSW50ZWwgQ29y
cG9yYXRpb24gQ29yZSBQcm9jZXNzb3IgUmVzZXJ2ZWQgKHJldiAwMikK
--========GMX316561289154999263298
Content-Type: text/plain; charset="iso-8859-15"; name="Kern_log.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="Kern_log.txt"

﻿ov  7 19:07:20 werner-laptop kernel: [   68.105881] ------------[ cut here ]------------
Nov  7 19:07:20 werner-laptop kernel: [   68.105887] kernel BUG at /build/buildd/linux-2.6.32/drivers/net/wireless/b43/dma.c:1426!
Nov  7 19:07:20 werner-laptop kernel: [   68.105890] invalid opcode: 0000 [#1] SMP 
Nov  7 19:07:20 werner-laptop kernel: [   68.105893] last sysfs file: /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0A:00/power_supply/BAT0/energy_full
Nov  7 19:07:20 werner-laptop kernel: [   68.105896] CPU 1 
Nov  7 19:07:20 werner-laptop kernel: [   68.105898] Modules linked in: rfcomm sco binfmt_misc ppdev bridge stp bnep l2cap snd_hda_codec_atihdmi btusb bluetooth joydev snd_hda_codec_realtek fbcon tileblit font bitblit softcursor vga16fb vgastate arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event dell_wmi b43 snd_seq video radeon mac80211 snd_timer uvcvideo lp snd_seq_device ttm cfg80211 drm_kms_helper output dell_laptop dcdbas snd parport videodev psmouse v4l1_compat v4l2_compat_ioctl32 serio_raw led_class soundcore drm snd_page_alloc i2c_algo_bit intel_agp usbhid hid usb_storage ahci r8169 mii ssb
Nov  7 19:07:20 werner-laptop kernel: [   68.105944] Pid: 1511, comm: irq/17-b43 Not tainted 2.6.32-25-generic #45-Ubuntu Inspiron 1564
Nov  7 19:07:20 werner-laptop kernel: [   68.105946] RIP: 0010:[<ffffffffa0326ea9>]  [<ffffffffa0326ea9>] b43_dma_handle_txstatus+0x209/0x210 [b43]
Nov  7 19:07:20 werner-laptop kernel: [   68.105961] RSP: 0000:ffff880122bb9d40  EFLAGS: 00010246
Nov  7 19:07:20 werner-laptop kernel: [   68.105964] RAX: 0000000000000000 RBX: ffff8801231ac7e0 RCX: ffff880130530d38
Nov  7 19:07:20 werner-laptop kernel: [   68.105966] RDX: 0000000020000000 RSI: 0000000000000000 RDI: ffff880024000000
Nov  7 19:07:20 werner-laptop kernel: [   68.105968] RBP: ffff880122bb9d90 R08: 0000000000000000 R09: ffff880028293800
Nov  7 19:07:20 werner-laptop kernel: [   68.105970] R10: 0000000000000001 R11: 0000000000000000 R12: 000000000000008d
Nov  7 19:07:20 werner-laptop kernel: [   68.105972] R13: ffff88013150d800 R14: ffffffffa032e8e0 R15: ffff880122bb9d58
Nov  7 19:07:20 werner-laptop kernel: [   68.105974] FS:  0000000000000000(0000) GS:ffff880028280000(0000) knlGS:0000000000000000
Nov  7 19:07:20 werner-laptop kernel: [   68.105976] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Nov  7 19:07:20 werner-laptop kernel: [   68.105978] CR2: 00007f51d157d000 CR3: 0000000123072000 CR4: 00000000000006e0
Nov  7 19:07:20 werner-laptop kernel: [   68.105981] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov  7 19:07:20 werner-laptop kernel: [   68.105983] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov  7 19:07:20 werner-laptop kernel: [   68.105985] Process irq/17-b43 (pid: 1511, threadinfo ffff880122bb8000, task ffff88012fe35bc0)
Nov  7 19:07:20 werner-laptop kernel: [   68.105987] Stack:
Nov  7 19:07:20 werner-laptop kernel: [   68.105988]  ffff880028295bc0 ffff880122bb9df0 ffff880122bb9d90 ffff880130530d38
Nov  7 19:07:20 werner-laptop kernel: [   68.105991] <0> 0000000000000000 ffff88013150d800 0000000000000000 ffff880122bb9df0
Nov  7 19:07:20 werner-laptop kernel: [   68.105995] <0> ffff8801231ac168 ffff8801332cbae4 ffff880122bb9db0 ffffffffa0321d90
Nov  7 19:07:20 werner-laptop kernel: [   68.105999] Call Trace:
Nov  7 19:07:20 werner-laptop kernel: [   68.106008]  [<ffffffffa0321d90>] b43_handle_txstatus+0x50/0x90 [b43]
Nov  7 19:07:20 werner-laptop kernel: [   68.106016]  [<ffffffffa0311c44>] b43_do_interrupt_thread+0x244/0x3c0 [b43]
Nov  7 19:07:20 werner-laptop kernel: [   68.106023]  [<ffffffffa0311de6>] b43_interrupt_thread_handler+0x26/0x40 [b43]
Nov  7 19:07:20 werner-laptop kernel: [   68.106030]  [<ffffffff810c5c64>] irq_thread+0x154/0x260
Nov  7 19:07:20 werner-laptop kernel: [   68.106033]  [<ffffffff810c5b10>] ? irq_thread+0x0/0x260
Nov  7 19:07:20 werner-laptop kernel: [   68.106038]  [<ffffffff81084206>] kthread+0x96/0xa0
Nov  7 19:07:20 werner-laptop kernel: [   68.106043]  [<ffffffff810131ea>] child_rip+0xa/0x20
Nov  7 19:07:20 werner-laptop kernel: [   68.106046]  [<ffffffff81084170>] ? kthread+0x0/0xa0
Nov  7 19:07:20 werner-laptop kernel: [   68.106049]  [<ffffffff810131e0>] ? child_rip+0x0/0x20
Nov  7 19:07:20 werner-laptop kernel: [   68.106050] Code: 00 48 83 c4 28 5b 41 5c 41 5d 41 5e 41 5f c9 c3 48 8b 5f 70 e9 85 fe ff ff 48 8b 5f 58 e9 7c fe ff ff 48 8b 5f 68 e9 73 fe ff ff <0f> 0b eb fe 0f 1f 00 55 48 89 e5 41 56 41 55 41 54 53 48 83 ec 
Nov  7 19:07:20 werner-laptop kernel: [   68.106080] RIP  [<ffffffffa0326ea9>] b43_dma_handle_txstatus+0x209/0x210 [b43]
Nov  7 19:07:20 werner-laptop kernel: [   68.106087]  RSP <ffff880122bb9d40>
Nov  7 19:07:20 werner-laptop kernel: [   68.106090] ---[ end trace e5c75e217c7c8a75 ]---

--========GMX316561289154999263298--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s35.blu0.hotmail.com ([65.55.111.110]:64372 "EHLO
	blu0-omc2-s35.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751975AbaCJKMu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 06:12:50 -0400
Message-ID: <BLU0-SMTP207EA48A3F1202F42B5F601AC740@phx.gbl> (sfid-20140310_111256_244079_555284AE)
Date: Mon, 10 Mar 2014 11:12:46 +0100
From: =?ISO-8859-1?Q?Aril_T=F8nnessen?= <ariltonnessen@hotmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Asus ux31e wireless, Qualcomm Atheros AR9485
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I'm the owner of a Asus Zenbook UX31E, and I'm running kubuntu 12.04 on it.

Unfortunately the wirelesscard on it keeps dropping the connection, and 
it's not possible to reconnect until reboot. I've been trying to observe 
when it happens, and I think it's mostly when it's running on batterypower.

dmesg gave me this:

[46290.238747] ath: phy0: Chip reset failed
[46290.238748] ath: phy0: Unable to reset channel, reset status -22
[46290.238756] ath: phy0: Unable to set channel
[46290.302254] ath: phy0: Failed to stop TX DMA, queues=0x18f!
[46290.313546] ath: phy0: DMA failed to stop in 10 ms AR_CR=0xffffffff 
AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
[46290.313558] ath: phy0: Could not stop RX, we could be confusing the 
DMA engine when we start RX up
[46290.427570] ath: phy0: Chip reset failed
[46290.427573] ath: phy0: Unable to reset channel, reset status -22
[46290.427581] ath: phy0: Unable to set channel
[46290.491212] ath: phy0: Failed to stop TX DMA, queues=0x18f!
[46290.502580] ath: phy0: DMA failed to stop in 10 ms AR_CR=0xffffffff 
AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
[46290.502588] ath: phy0: Could not stop RX, we could be confusing the 
DMA engine when we start RX up
[46290.616192] ath: phy0: Chip reset failed
[46290.616195] ath: phy0: Unable to reset channel, reset status -22
[46290.616204] ath: phy0: Unable to set channel
[46290.679691] ath: phy0: Failed to stop TX DMA, queues=0x18f!
[46290.691075] ath: phy0: DMA failed to stop in 10 ms AR_CR=0xffffffff 
AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
[46290.691082] ath: phy0: Could not stop RX, we could be confusing the 
DMA engine when we start RX up
[46290.805144] ath: phy0: Chip reset failed
[46290.805146] ath: phy0: Unable to reset channel, reset status -22
[46290.805153] ath: phy0: Unable to set channel
[46290.868573] ath: phy0: Failed to stop TX DMA, queues=0x18f!
[46290.879963] ath: phy0: DMA failed to stop in 10 ms AR_CR=0xffffffff 
AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
[46290.879971] ath: phy0: Could not stop RX, we could be confusing the 
DMA engine when we start RX up
[46290.993647] ath: phy0: Chip reset failed
[46290.993651] ath: phy0: Unable to reset channel, reset status -22
[46290.993669] ath: phy0: Unable to set channel
[46291.057267] ath: phy0: Failed to stop TX DMA, queues=0x18f!
[46291.068574] ath: phy0: DMA failed to stop in 10 ms AR_CR=0xffffffff 
AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
[46291.068582] ath: phy0: Could not stop RX, we could be confusing the 
DMA engine when we start RX up
[46291.182637] ath: phy0: Chip reset failed
[46291.182639] ath: phy0: Unable to reset channel, reset status -22
[46291.182653] ath: phy0: Unable to set channel
[46291.296484] ath: phy0: RX failed to go idle in 10 ms RXSM=0xffffffff
[46291.307837] ath: phy0: DMA failed to stop in 10 ms AR_CR=0xffffffff 
AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff




lspci:

00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor 
Family DRAM Controller (rev 09)
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core 
Processor Family Integrated Graphics Controller (rev 09)
00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series 
Chipset Family MEI Controller #1 (rev 04)
00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset 
Family High Definition Audio Controller (rev 05)
00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset 
Family PCI Express Root Port 1 (rev b5)
00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset 
Family PCI Express Root Port 2 (rev b5)
00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset 
Family PCI Express Root Port 4 (rev b5)
00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset 
Family USB Enhanced Host Controller #1 (rev 05)
00:1f.0 ISA bridge: Intel Corporation QS67 Express Chipset Family LPC 
Controller (rev 05)
00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset 
Family 6 port SATA AHCI Controller (rev 05)
00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family 
SMBus Controller (rev 05)
02:00.0 Network controller: Qualcomm Atheros AR9485 Wireless Network 
Adapter (rev 01)
03:00.0 USB controller: Fresco Logic FL1009 USB 3.0 Host Controller (rev 02)





lsmod:

pci_stub               12622  1
vboxpci                23237  0
vboxnetadp             13382  0
vboxnetflt             23478  0
vboxdrv               287130  3 vboxpci,vboxnetadp,vboxnetflt
dm_crypt               23125  1
snd_hda_codec_hdmi     32530  1
snd_hda_codec_realtek   224173  1
joydev                 17693  0
rts5139               351188  0
uvcvideo               72627  0
videodev               98259  1 uvcvideo
v4l2_compat_ioctl32    17128  1 videodev
ath3k                  12961  0
btusb                  18332  1
asus_nb_wmi            12710  0
asus_wmi               24456  1 asus_nb_wmi
sparse_keymap          13890  1 asus_wmi
snd_hda_intel          33719  3
snd_hda_codec         127706  3 
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel
snd_hwdep              17764  1 snd_hda_codec
snd_pcm                97275  3 
snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec
arc4                   12529  2
ath9k                 101495  0
snd_seq_midi           13324  0
mac80211              573177  1 ath9k
psmouse                97519  0
snd_rawmidi            30748  1 snd_seq_midi
ath9k_common           13792  1 ath9k
serio_raw              13211  0
ath9k_hw              432022  2 ath9k,ath9k_common
snd_seq_midi_event     14899  1 snd_seq_midi
snd_seq                61929  2 snd_seq_midi,snd_seq_midi_event
ath                    23827  3 ath9k,ath9k_common,ath9k_hw
cfg80211              567517  3 ath9k,mac80211,ath
snd_timer              29990  2 snd_pcm,snd_seq
snd_seq_device         14540  3 snd_seq_midi,snd_rawmidi,snd_seq
compat                 30258  5 
ath9k,mac80211,ath9k_common,ath9k_hw,cfg80211
snd                    79041  16 
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
bnep                   18281  2
soundcore              15091  1 snd
snd_page_alloc         18529  2 snd_hda_intel,snd_pcm
rfcomm                 47604  16
mac_hid                13253  0
bluetooth             180113  24 ath3k,btusb,bnep,rfcomm
parport_pc             32866  0
mei                    41616  0
ppdev                  17113  0
binfmt_misc            17540  1
lp                     17799  0
parport                46562  3 parport_pc,ppdev,lp
wmi                    19256  1 asus_wmi
i915                  478556  3
drm_kms_helper         46978  1 i915
drm                   241971  4 i915,drm_kms_helper
i2c_algo_bit           13423  1 i915
video                  19651  1 i915



uname -a:

Linux aril-UX31E 3.2.0-60-generic #91-Ubuntu SMP Wed Feb 19 03:54:44 UTC 
2014 x86_64 x86_64 x86_64 GNU/Linux


And I'm using backports-modules:

linux-backports-modules-cw-3.12-precise-generic





Hope this info is helpful, and please don't hesitate to tell me what 
other info you need or if I can help in any other way.



Thank you!


Aril Tønnessen



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:58453 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbaG1Us7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2014 16:48:59 -0400
Received: from saldaea ([84.134.4.86]) by smtp.web.de (mrweb003) with ESMTPSA
 (Nemesis) id 0Lj2Cs-1Wd5KY2Noc-00dJX5 for <linux-wireless@vger.kernel.org>;
 Mon, 28 Jul 2014 22:48:57 +0200
Date: Mon, 28 Jul 2014 22:48:47 +0200
From: Julian Wollrath <jwollrath@web.de>
To: linux-wireless@vger.kernel.org
Subject: iwlwifi microcode SW error and traces on v3.16-rc7
Message-ID: <20140728224847.69537b1c@saldaea> (sfid-20140728_224904_210684_EF2E9B13)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/j1oKKkaxa79uz2J4Res54DU"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/j1oKKkaxa79uz2J4Res54DU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

during wakeup from suspend to RAM, I got the following microcode SW
error and traces for my wireless card (03:00.0 Network controller
[0280]: Intel Corporation Centrino Advanced-N 6205 [Taylor Peak]
[8086:0085] (rev 34)):
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: L1 Enabled; Disabling=
 L0S
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: Radio type=3D0x1-0x2-=
0x0
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: Error sending REPLY_R=
XON: time out after 2000ms.
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: Current CMD queue rea=
d_ptr 15 write_ptr 16
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: Loaded firmware versi=
on: 18.168.6.1
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: Microcode SW error de=
tected.  Restarting 0x2000000.
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: CSR values:
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_=
COALESCING is CSR_INT_PERIODIC_REG)
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:        CSR_HW_IF_CONF=
IG_REG: 0X00488700
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:          CSR_INT_COAL=
ESCING: 0X00000040
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:                     C=
SR_INT: 0X00000000
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:                CSR_IN=
T_MASK: 0X00000000
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:           CSR_FH_INT_=
STATUS: 0X00000000
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:                 CSR_G=
PIO_IN: 0X00000030
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:                   CSR=
_RESET: 0X00000000
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:                CSR_GP=
_CNTRL: 0X080403cd
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:                  CSR_=
HW_REV: 0X000000b0
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:              CSR_EEPR=
OM_REG: 0X19010ffd
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:               CSR_EEP=
ROM_GP: 0X90000001
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:              CSR_OTP_=
GP_REG: 0X00030001
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:                 CSR_G=
IO_REG: 0X00080042
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:            CSR_GP_UCO=
DE_REG: 0X00000007
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:           CSR_GP_DRIV=
ER_REG: 0X00000000
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:           CSR_UCODE_D=
RV_GP1: 0X00000000
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:           CSR_UCODE_D=
RV_GP2: 0X00000000
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:                 CSR_L=
ED_REG: 0X00000060
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:        CSR_DRAM_INT_T=
BL_REG: 0X881193ad
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:        CSR_GIO_CHICKE=
N_BITS: 0X27800200
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:             CSR_ANA_P=
LL_CFG: 0X00000000
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:      CSR_MONITOR_STAT=
US_REG: 0X6bf7f7d7
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:           CSR_HW_REV_=
WA_REG: 0X0001001a
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:        CSR_DBG_HPET_M=
EM_REG: 0Xffff0000
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: FH register values:
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: Start IWL Error Log D=
ump:
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: Status: 0x0000204C, c=
ount: 6
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x00000066 | NMI_INTE=
RRUPT_HOST         =20
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x00010050 | uPc
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x0001001E | branchli=
nk1
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x00010090 | branchli=
nk2
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x0000D6BE | interrup=
tlink1
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x000003FE | interrup=
tlink2
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x00000001 | data1
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x07030000 | data2
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x00024B96 | line
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x000189A8 | beacon t=
ime
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x00000658 | tsf low
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x00000000 | time gp1
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x00011050 | time gp2
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x00000000 | time gp3
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x754312A8 | uCode ve=
rsion
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x000000B0 | hw versi=
on
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x00488700 | board ve=
rsion
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x090E0077 | hcmd
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x26C23080 | isr0
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x00004000 | isr1
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x00000E02 | isr2
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x0140B0C2 | isr3
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL=
0_STTS_WPTR_REG: 0X118e9100
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x00000000 | isr4
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x01000112 | isr_pref
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x00024B96 | wait_eve=
nt
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x00000000 | l2p_cont=
rol
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x00000000 | l2p_dura=
tion
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x00000000 | l2p_mhva=
lid
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x00000000 | l2p_addr=
_match
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x00000004 | lmpm_pmg=
_sel
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x06061222 | timestamp
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: 0x00001018 | flow_han=
dler
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0=
_RBDCB_BASE_REG: 0X01193de0
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:                  FH_R=
SCSR_CHNL0_WPTR: 0X00000010
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:         FH_MEM_RCSR_C=
HNL0_CONFIG_REG: 0X00801114
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:          FH_MEM_RSSR_=
SHARED_CTRL_REG: 0X000000fc
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: Start IWL Event Log D=
ump: display last 1 entries
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:            FH_MEM_RSS=
R_RX_STATUS_REG: 0X07030000
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: EVT_LOGT:0000069712:0=
x0000010c:0123
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0: Error clearing ASSOC_=
MSK on BSS (-110)
Jul 28 10:35:47 saldaea kernel: ------------[ cut here ]------------
Jul 28 10:35:47 saldaea kernel: WARNING: CPU: 2 PID: 4603 at net/mac80211/d=
river-ops.h:12 ieee80211_reconfig+0x119b/0x1500 [mac80211]()
Jul 28 10:35:47 saldaea kernel: wlan0:  Failed check-sdata-in-driver check,=
 flags: 0x4
Jul 28 10:35:47 saldaea kernel: Modules linked in: uas usb_storage msr cpuf=
req_stats ecb arc4 iwldvm btusb mac80211 bluetooth crc16 iwlwifi cfg80211 u=
vcvideo snd_hda_codec_hdmi i915 snd_hda_codec_realtek snd_hda_codec_generic=
 snd_hda_intel x86_pkg_temp_thermal intel_powerclamp intel_rapl coretemp kv=
m_intel snd_hda_controller thinkpad_acpi snd_hda_codec i2c_algo_bit videobu=
f2_vmalloc drm_kms_helper videobuf2_memops kvm videobuf2_core drm v4l2_comm=
on
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENA=
BLE_ERR_IRQ2DRV: 0X00000000
Jul 28 10:35:47 saldaea kernel:  videodev snd_hwdep i2c_i801 psmouse snd_pc=
m evdev pcspkr snd_timer nvram snd soundcore rfkill wmi i2c_core tpm_tis tp=
m serio_raw battery video button ac processor sch_fq fuse autofs4 dm_crypt =
dm_mod sd_mod crc_t10dif crct10dif_generic crct10dif_pclmul crct10dif_commo=
n crc32_pclmul crc32c_intel ghash_clmulni_intel ahci libahci ehci_pci libat=
a xhci_hcd ehci_hcd scsi_mod sdhci_pci sdhci e1000e ptp mmc_core pps_core u=
sbcore thermal usb_common thermal_sys
Jul 28 10:35:47 saldaea kernel: CPU: 2 PID: 4603 Comm: systemd-sleep Not ta=
inted 3.16.0-rc7 #2
Jul 28 10:35:47 saldaea kernel: Hardware name: LENOVO 23250BM/23250BM, BIOS=
 G2ETA1WW (2.61 ) 04/22/2014
Jul 28 10:35:47 saldaea kernel:  0000000000000009 ffffffff814a1912 ffff8800=
beea3cf0 ffffffff81069512
Jul 28 10:35:47 saldaea kernel:  ffff8800ca000680 ffff8800beea3d40 00000000=
00000000 ffff8800ca212d94
Jul 28 10:35:47 saldaea kernel:  00000000ffffff92 ffffffff81069577 ffffffff=
a06961b8 0000000000000028
Jul 28 10:35:47 saldaea kernel: Call Trace:
Jul 28 10:35:47 saldaea kernel:  [<ffffffff814a1912>] ? dump_stack+0x41/0x51
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81069512>] ? warn_slowpath_commo=
n+0x72/0x90
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81069577>] ? warn_slowpath_fmt+0=
x47/0x50
Jul 28 10:35:47 saldaea kernel:  [<ffffffffa05c2f1c>] ? iwlagn_mac_add_inte=
rface+0x6c/0x1a0 [iwldvm]
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:                FH_TSS=
R_TX_STATUS_REG: 0X07ff0001
Jul 28 10:35:47 saldaea kernel:  [<ffffffffa066ba3b>] ? ieee80211_reconfig+=
0x119b/0x1500 [mac80211]
Jul 28 10:35:47 saldaea kernel:  [<ffffffffa051861a>] ? wiphy_resume+0x7a/0=
xf0 [cfg80211]
Jul 28 10:35:47 saldaea kernel:  [<ffffffffa05185a0>] ? addresses_show+0xa0=
/0xa0 [cfg80211]
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81373256>] ? dpm_run_callback+0x=
26/0xd0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff8137367d>] ? device_resume+0x7d/=
0x190
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81374d7c>] ? dpm_resume+0xec/0x2=
b0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff810abcc9>] ? hibernation_snapsho=
t+0x249/0x3b0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff810ac4df>] ? hibernate+0x12f/0x1=
a0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff810aa20c>] ? state_store+0xcc/0x=
e0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff811df10b>] ? kernfs_fop_write+0x=
db/0x160
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81179f7d>] ? vfs_write+0xad/0x1e0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff8117aa8d>] ? SyS_write+0x3d/0xa0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff814a89e2>] ? page_fault+0x22/0x30
Jul 28 10:35:47 saldaea kernel:  [<ffffffff814a7052>] ? system_call_fastpat=
h+0x16/0x1b
Jul 28 10:35:47 saldaea kernel: ---[ end trace 64eab003ea24e032 ]---
Jul 28 10:35:47 saldaea kernel: ------------[ cut here ]------------
Jul 28 10:35:47 saldaea kernel: WARNING: CPU: 2 PID: 4603 at net/mac80211/d=
river-ops.h:12 ieee80211_reconfig+0x119b/0x1500 [mac80211]()
Jul 28 10:35:47 saldaea kernel: iwlwifi 0000:03:00.0:                 FH_TS=
SR_TX_ERROR_REG: 0X00000000
Jul 28 10:35:47 saldaea kernel: wlan0:  Failed check-sdata-in-driver check,=
 flags: 0x4
Jul 28 10:35:47 saldaea kernel: Modules linked in: uas usb_storage msr cpuf=
req_stats ecb arc4 iwldvm btusb mac80211 bluetooth crc16 iwlwifi cfg80211 u=
vcvideo snd_hda_codec_hdmi i915 snd_hda_codec_realtek snd_hda_codec_generic=
 snd_hda_intel x86_pkg_temp_thermal intel_powerclamp intel_rapl coretemp kv=
m_intel snd_hda_controller thinkpad_acpi snd_hda_codec i2c_algo_bit videobu=
f2_vmalloc drm_kms_helper videobuf2_memops kvm videobuf2_core drm v4l2_comm=
on videodev snd_hwdep i2c_i801 psmouse snd_pcm evdev pcspkr snd_timer nvram=
 snd soundcore rfkill wmi i2c_core tpm_tis tpm serio_raw battery video butt=
on ac processor sch_fq fuse autofs4 dm_crypt dm_mod sd_mod crc_t10dif crct1=
0dif_generic crct10dif_pclmul crct10dif_common crc32_pclmul crc32c_intel gh=
ash_clmulni_intel ahci libahci ehci_pci libata xhci_hcd ehci_hcd scsi_mod s=
dhci_pci
Jul 28 10:35:47 saldaea kernel:  sdhci e1000e ptp mmc_core pps_core usbcore=
 thermal usb_common thermal_sys
Jul 28 10:35:47 saldaea kernel: CPU: 2 PID: 4603 Comm: systemd-sleep Tainte=
d: G        W     3.16.0-rc7 #2
Jul 28 10:35:47 saldaea kernel: Hardware name: LENOVO 23250BM/23250BM, BIOS=
 G2ETA1WW (2.61 ) 04/22/2014
Jul 28 10:35:47 saldaea kernel:  0000000000000009 ffffffff814a1912 ffff8800=
beea3cf0 ffffffff81069512
Jul 28 10:35:47 saldaea kernel:  ffff8800ca000680 ffff8800beea3d40 00000000=
00000001 ffff8800ca212d9e
Jul 28 10:35:47 saldaea kernel:  00000000ffffff92 ffffffff81069577 ffffffff=
a06961b8 0000000000000028
Jul 28 10:35:47 saldaea kernel: Call Trace:
Jul 28 10:35:47 saldaea kernel:  [<ffffffff814a1912>] ? dump_stack+0x41/0x51
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81069512>] ? warn_slowpath_commo=
n+0x72/0x90
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81069577>] ? warn_slowpath_fmt+0=
x47/0x50
Jul 28 10:35:47 saldaea kernel:  [<ffffffffa05c2f1c>] ? iwlagn_mac_add_inte=
rface+0x6c/0x1a0 [iwldvm]
Jul 28 10:35:47 saldaea kernel:  [<ffffffffa066ba3b>] ? ieee80211_reconfig+=
0x119b/0x1500 [mac80211]
Jul 28 10:35:47 saldaea kernel:  [<ffffffffa051861a>] ? wiphy_resume+0x7a/0=
xf0 [cfg80211]
Jul 28 10:35:47 saldaea kernel:  [<ffffffffa05185a0>] ? addresses_show+0xa0=
/0xa0 [cfg80211]
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81373256>] ? dpm_run_callback+0x=
26/0xd0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff8137367d>] ? device_resume+0x7d/=
0x190
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81374d7c>] ? dpm_resume+0xec/0x2=
b0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff810abcc9>] ? hibernation_snapsho=
t+0x249/0x3b0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff810ac4df>] ? hibernate+0x12f/0x1=
a0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff810aa20c>] ? state_store+0xcc/0x=
e0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff811df10b>] ? kernfs_fop_write+0x=
db/0x160
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81179f7d>] ? vfs_write+0xad/0x1e0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff8117aa8d>] ? SyS_write+0x3d/0xa0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff814a89e2>] ? page_fault+0x22/0x30
Jul 28 10:35:47 saldaea kernel:  [<ffffffff814a7052>] ? system_call_fastpat=
h+0x16/0x1b
Jul 28 10:35:47 saldaea kernel: ---[ end trace 64eab003ea24e033 ]---
Jul 28 10:35:47 saldaea kernel: ------------[ cut here ]------------
Jul 28 10:35:47 saldaea kernel: WARNING: CPU: 2 PID: 4603 at net/mac80211/d=
river-ops.h:12 ieee80211_reconfig+0x119b/0x1500 [mac80211]()
Jul 28 10:35:47 saldaea kernel: wlan0:  Failed check-sdata-in-driver check,=
 flags: 0x4
Jul 28 10:35:47 saldaea kernel: Modules linked in: uas usb_storage msr cpuf=
req_stats ecb arc4 iwldvm btusb mac80211 bluetooth crc16 iwlwifi cfg80211 u=
vcvideo snd_hda_codec_hdmi i915 snd_hda_codec_realtek snd_hda_codec_generic=
 snd_hda_intel x86_pkg_temp_thermal intel_powerclamp intel_rapl coretemp kv=
m_intel snd_hda_controller thinkpad_acpi snd_hda_codec i2c_algo_bit videobu=
f2_vmalloc drm_kms_helper videobuf2_memops kvm videobuf2_core drm v4l2_comm=
on videodev snd_hwdep i2c_i801 psmouse snd_pcm evdev pcspkr snd_timer nvram=
 snd soundcore rfkill wmi i2c_core tpm_tis tpm serio_raw battery video butt=
on ac processor sch_fq fuse autofs4 dm_crypt dm_mod sd_mod crc_t10dif crct1=
0dif_generic crct10dif_pclmul crct10dif_common crc32_pclmul crc32c_intel gh=
ash_clmulni_intel ahci libahci ehci_pci libata xhci_hcd ehci_hcd scsi_mod s=
dhci_pci
Jul 28 10:35:47 saldaea kernel:  sdhci e1000e ptp mmc_core pps_core usbcore=
 thermal usb_common thermal_sys
Jul 28 10:35:47 saldaea kernel: CPU: 2 PID: 4603 Comm: systemd-sleep Tainte=
d: G        W     3.16.0-rc7 #2
Jul 28 10:35:47 saldaea kernel: Hardware name: LENOVO 23250BM/23250BM, BIOS=
 G2ETA1WW (2.61 ) 04/22/2014
Jul 28 10:35:47 saldaea kernel:  0000000000000009 ffffffff814a1912 ffff8800=
beea3cf0 ffffffff81069512
Jul 28 10:35:47 saldaea kernel:  ffff8800ca000680 ffff8800beea3d40 00000000=
00000002 ffff8800ca212da8
Jul 28 10:35:47 saldaea kernel:  00000000ffffff92 ffffffff81069577 ffffffff=
a06961b8 0000000000000028
Jul 28 10:35:47 saldaea kernel: Call Trace:
Jul 28 10:35:47 saldaea kernel:  [<ffffffff814a1912>] ? dump_stack+0x41/0x51
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81069512>] ? warn_slowpath_commo=
n+0x72/0x90
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81069577>] ? warn_slowpath_fmt+0=
x47/0x50
Jul 28 10:35:47 saldaea kernel:  [<ffffffffa05c2f1c>] ? iwlagn_mac_add_inte=
rface+0x6c/0x1a0 [iwldvm]
Jul 28 10:35:47 saldaea kernel:  [<ffffffffa066ba3b>] ? ieee80211_reconfig+=
0x119b/0x1500 [mac80211]
Jul 28 10:35:47 saldaea kernel:  [<ffffffffa051861a>] ? wiphy_resume+0x7a/0=
xf0 [cfg80211]
Jul 28 10:35:47 saldaea kernel:  [<ffffffffa05185a0>] ? addresses_show+0xa0=
/0xa0 [cfg80211]
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81373256>] ? dpm_run_callback+0x=
26/0xd0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff8137367d>] ? device_resume+0x7d/=
0x190
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81374d7c>] ? dpm_resume+0xec/0x2=
b0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff810abcc9>] ? hibernation_snapsho=
t+0x249/0x3b0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff810ac4df>] ? hibernate+0x12f/0x1=
a0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff810aa20c>] ? state_store+0xcc/0x=
e0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff811df10b>] ? kernfs_fop_write+0x=
db/0x160
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81179f7d>] ? vfs_write+0xad/0x1e0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff8117aa8d>] ? SyS_write+0x3d/0xa0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff814a89e2>] ? page_fault+0x22/0x30
Jul 28 10:35:47 saldaea kernel:  [<ffffffff814a7052>] ? system_call_fastpat=
h+0x16/0x1b
Jul 28 10:35:47 saldaea kernel: ---[ end trace 64eab003ea24e034 ]---
Jul 28 10:35:47 saldaea kernel: ------------[ cut here ]------------
Jul 28 10:35:47 saldaea kernel: WARNING: CPU: 2 PID: 4603 at net/mac80211/d=
river-ops.h:12 ieee80211_reconfig+0x119b/0x1500 [mac80211]()
Jul 28 10:35:47 saldaea kernel: wlan0:  Failed check-sdata-in-driver check,=
 flags: 0x4
Jul 28 10:35:47 saldaea kernel: Modules linked in: uas usb_storage msr cpuf=
req_stats ecb arc4 iwldvm btusb mac80211 bluetooth crc16 iwlwifi cfg80211 u=
vcvideo snd_hda_codec_hdmi i915 snd_hda_codec_realtek snd_hda_codec_generic=
 snd_hda_intel x86_pkg_temp_thermal intel_powerclamp intel_rapl coretemp kv=
m_intel snd_hda_controller thinkpad_acpi snd_hda_codec i2c_algo_bit videobu=
f2_vmalloc drm_kms_helper videobuf2_memops kvm videobuf2_core drm v4l2_comm=
on videodev snd_hwdep i2c_i801 psmouse snd_pcm evdev pcspkr snd_timer nvram=
 snd soundcore rfkill wmi i2c_core tpm_tis tpm serio_raw battery video butt=
on ac processor sch_fq fuse autofs4 dm_crypt dm_mod sd_mod crc_t10dif crct1=
0dif_generic crct10dif_pclmul crct10dif_common crc32_pclmul crc32c_intel gh=
ash_clmulni_intel ahci libahci ehci_pci libata xhci_hcd ehci_hcd scsi_mod s=
dhci_pci
Jul 28 10:35:47 saldaea kernel:  sdhci e1000e ptp mmc_core pps_core usbcore=
 thermal usb_common thermal_sys
Jul 28 10:35:47 saldaea kernel: CPU: 2 PID: 4603 Comm: systemd-sleep Tainte=
d: G        W     3.16.0-rc7 #2
Jul 28 10:35:47 saldaea kernel: Hardware name: LENOVO 23250BM/23250BM, BIOS=
 G2ETA1WW (2.61 ) 04/22/2014
Jul 28 10:35:47 saldaea kernel:  0000000000000009 ffffffff814a1912 ffff8800=
beea3cf0 ffffffff81069512
Jul 28 10:35:47 saldaea kernel:  ffff8800ca000680 ffff8800beea3d40 00000000=
00000003 ffff8800ca212db2
Jul 28 10:35:47 saldaea kernel:  00000000ffffff92 ffffffff81069577 ffffffff=
a06961b8 0000000000000028
Jul 28 10:35:47 saldaea kernel: Call Trace:
Jul 28 10:35:47 saldaea kernel:  [<ffffffff814a1912>] ? dump_stack+0x41/0x51
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81069512>] ? warn_slowpath_commo=
n+0x72/0x90
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81069577>] ? warn_slowpath_fmt+0=
x47/0x50
Jul 28 10:35:47 saldaea kernel:  [<ffffffffa05c2f1c>] ? iwlagn_mac_add_inte=
rface+0x6c/0x1a0 [iwldvm]
Jul 28 10:35:47 saldaea kernel:  [<ffffffffa066ba3b>] ? ieee80211_reconfig+=
0x119b/0x1500 [mac80211]
Jul 28 10:35:47 saldaea kernel:  [<ffffffffa051861a>] ? wiphy_resume+0x7a/0=
xf0 [cfg80211]
Jul 28 10:35:47 saldaea kernel:  [<ffffffffa05185a0>] ? addresses_show+0xa0=
/0xa0 [cfg80211]
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81373256>] ? dpm_run_callback+0x=
26/0xd0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff8137367d>] ? device_resume+0x7d/=
0x190
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81374d7c>] ? dpm_resume+0xec/0x2=
b0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff810abcc9>] ? hibernation_snapsho=
t+0x249/0x3b0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff810ac4df>] ? hibernate+0x12f/0x1=
a0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff810aa20c>] ? state_store+0xcc/0x=
e0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff811df10b>] ? kernfs_fop_write+0x=
db/0x160
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81179f7d>] ? vfs_write+0xad/0x1e0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff8117aa8d>] ? SyS_write+0x3d/0xa0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff814a89e2>] ? page_fault+0x22/0x30
Jul 28 10:35:47 saldaea kernel:  [<ffffffff814a7052>] ? system_call_fastpat=
h+0x16/0x1b
Jul 28 10:35:47 saldaea kernel: ---[ end trace 64eab003ea24e035 ]---
Jul 28 10:35:47 saldaea kernel: ------------[ cut here ]------------
Jul 28 10:35:47 saldaea kernel: WARNING: CPU: 2 PID: 4603 at net/mac80211/d=
river-ops.h:12 ieee80211_reconfig+0xb40/0x1500 [mac80211]()
Jul 28 10:35:47 saldaea kernel: ieee80211 phy0: Hardware restart was reques=
ted
Jul 28 10:35:47 saldaea kernel: wlan0:  Failed check-sdata-in-driver check,=
 flags: 0x4
Jul 28 10:35:47 saldaea kernel: Modules linked in: uas usb_storage msr cpuf=
req_stats ecb arc4 iwldvm btusb mac80211 bluetooth crc16 iwlwifi cfg80211 u=
vcvideo snd_hda_codec_hdmi i915 snd_hda_codec_realtek snd_hda_codec_generic=
 snd_hda_intel x86_pkg_temp_thermal intel_powerclamp intel_rapl coretemp kv=
m_intel snd_hda_controller thinkpad_acpi snd_hda_codec i2c_algo_bit videobu=
f2_vmalloc drm_kms_helper videobuf2_memops kvm videobuf2_core drm v4l2_comm=
on videodev snd_hwdep i2c_i801 psmouse snd_pcm evdev pcspkr snd_timer nvram=
 snd soundcore rfkill wmi i2c_core tpm_tis tpm serio_raw battery video butt=
on ac processor sch_fq fuse autofs4 dm_crypt dm_mod sd_mod crc_t10dif crct1=
0dif_generic crct10dif_pclmul crct10dif_common crc32_pclmul crc32c_intel gh=
ash_clmulni_intel ahci libahci ehci_pci libata xhci_hcd ehci_hcd scsi_mod s=
dhci_pci
Jul 28 10:35:47 saldaea kernel:  sdhci e1000e ptp mmc_core pps_core usbcore=
 thermal usb_common thermal_sys
Jul 28 10:35:47 saldaea kernel: CPU: 2 PID: 4603 Comm: systemd-sleep Tainte=
d: G        W     3.16.0-rc7 #2
Jul 28 10:35:47 saldaea kernel: Hardware name: LENOVO 23250BM/23250BM, BIOS=
 G2ETA1WW (2.61 ) 04/22/2014
Jul 28 10:35:47 saldaea kernel:  0000000000000009 ffffffff814a1912 ffff8800=
beea3cf0 ffffffff81069512
Jul 28 10:35:47 saldaea kernel:  ffff8800ca000680 ffff8800beea3d40 ffff8800=
ca212880 00000000000674ff
Jul 28 10:35:47 saldaea kernel:  ffff8800ca2128d8 ffffffff81069577 ffffffff=
a06954f8 0000000000000028
Jul 28 10:35:47 saldaea kernel: Call Trace:
Jul 28 10:35:47 saldaea kernel:  [<ffffffff814a1912>] ? dump_stack+0x41/0x51
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81069512>] ? warn_slowpath_commo=
n+0x72/0x90
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81069577>] ? warn_slowpath_fmt+0=
x47/0x50
Jul 28 10:35:47 saldaea kernel:  [<ffffffffa0641a67>] ? ieee80211_bss_info_=
change_notify+0x27/0x1c0 [mac80211]
Jul 28 10:35:47 saldaea kernel:  [<ffffffffa066b3e0>] ? ieee80211_reconfig+=
0xb40/0x1500 [mac80211]
Jul 28 10:35:47 saldaea kernel:  [<ffffffffa051861a>] ? wiphy_resume+0x7a/0=
xf0 [cfg80211]
Jul 28 10:35:47 saldaea kernel:  [<ffffffffa05185a0>] ? addresses_show+0xa0=
/0xa0 [cfg80211]
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81373256>] ? dpm_run_callback+0x=
26/0xd0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff8137367d>] ? device_resume+0x7d/=
0x190
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81374d7c>] ? dpm_resume+0xec/0x2=
b0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff810abcc9>] ? hibernation_snapsho=
t+0x249/0x3b0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff810ac4df>] ? hibernate+0x12f/0x1=
a0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff810aa20c>] ? state_store+0xcc/0x=
e0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff811df10b>] ? kernfs_fop_write+0x=
db/0x160
Jul 28 10:35:47 saldaea kernel:  [<ffffffff81179f7d>] ? vfs_write+0xad/0x1e0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff8117aa8d>] ? SyS_write+0x3d/0xa0
Jul 28 10:35:47 saldaea kernel:  [<ffffffff814a89e2>] ? page_fault+0x22/0x30
Jul 28 10:35:47 saldaea kernel:  [<ffffffff814a7052>] ? system_call_fastpat=
h+0x16/0x1b
Jul 28 10:35:47 saldaea kernel: ---[ end trace 64eab003ea24e036 ]---


If you need more information, please do not hesitate to ask.


With best regards,
Julian Wollrath

--Sig_/j1oKKkaxa79uz2J4Res54DU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJT1rc3AAoJEFl2dmpRMS8z/pIIAIb1DoFlO24e5X72Ba3sVJsj
5tZNg6/qknPt9JnUsQskFM4wVm9MQPrMXtQEcE5rC/IuQnQ7zAv1xaWAgGywNpgp
HduaLWITR31C8j4rDv1LjSNlGINewqEh5d2vsM+NJ1q5Hqji1ixdzR2VJ72EM6FJ
BlFqb5fDRkQhb1OqMTmyHZ+0lW3Lf6Mwb3zl+/aHzvlW+2RtrzaJHNf3jVmQ/2+8
hcdQzDoXoWpT0bOnZIhetGnHlTsi13xlL0yGRbwMqBMXigtY1EYYDyhltcIeXjMq
SQHm/X+73uEbyIwqz7rOr4Z3UhNP0r0LMgVsj6pBzc+smx6/skYyIF884ojjnuI=
=Piki
-----END PGP SIGNATURE-----

--Sig_/j1oKKkaxa79uz2J4Res54DU--

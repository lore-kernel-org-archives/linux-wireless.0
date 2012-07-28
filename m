Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from os.inf.tu-dresden.de ([141.76.48.99]:51240 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab2G1LUD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jul 2012 07:20:03 -0400
Date: Sat, 28 Jul 2012 12:37:59 +0200
From: Udo Steinberg <udo@hypervisor.org>
To: linux-wireless@vger.kernel.org,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: Frequent WiFi hangs with Linux-3.5
Message-ID: <20120728123759.05d3fa4a@x220> (sfid-20120728_132049_357399_BABC4C39)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/G5bz/orOwwmP3xQwXyKJ4a5"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/G5bz/orOwwmP3xQwXyKJ4a5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

I'm running Linux-3.5.0 with iwlagn built into the kernel and I'm getting
frequent hangs of my WiFi card, which is an Intel Centrino Advanced-N 6205
(rev 34). This previously worked flawlessly with Linux-3.3.0

Is this a known problem, for which a patch already exists?

Cheers,
Udo

The following are two examples:


iwlwifi: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
iwlwifi: Copyright(c) 2003-2012 Intel Corporation
iwlwifi 0000:03:00.0: pci_resource_len =3D 0x00002000
iwlwifi 0000:03:00.0: pci_resource_base =3D ffffc9000007c000
iwlwifi 0000:03:00.0: HW Revision ID =3D 0x34
iwlwifi 0000:03:00.0: irq 45 for MSI/MSI-X

udevd[100]: starting version 182
iwlwifi 0000:03:00.0: loaded firmware version 17.168.5.3 build 42301
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Advanced-N 6205 AGN, RE=
V=3D0xB0
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: device EEPROM VER=3D0x715, CALIB=3D0x6
iwlwifi 0000:03:00.0: Device SKU: 0x1F0
iwlwifi 0000:03:00.0: Valid Tx ant: 0x3, Valid Rx ant: 0x3
iwlwifi 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels

cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eir=
p)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: DE
cfg80211: Regulatory domain changed to country: DE
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eir=
p)
cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5150000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
wlan0: authenticate with c0:25:06:6a:3d:86
wlan0: send auth to c0:25:06:6a:3d:86 (try 1/3)
wlan0: send auth to c0:25:06:6a:3d:86 (try 2/3)
wlan0: authenticated
iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x2000000.
iwlwifi 0000:03:00.0: CSR values:
iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_R=
EG)
iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00480303
iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X0000ff40
iwlwifi 0000:03:00.0:                     CSR_INT: 0X00000000
iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X00000000
iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000030
iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X000000b0
iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0X27d40ffd
iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00030001
iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080042
iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X000002f9
iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000078
iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X880fff5f
iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
iwlwifi 0000:03:00.0: FH register values:
iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0fff5d00
iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00fff5e0
iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000b8
iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80811104
iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
iwlwifi 0000:03:00.0: Loaded firmware version: 17.168.5.3 build 42301
iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
iwlwifi 0000:03:00.0: Status: 0x0000005C, count: 6
iwlwifi 0000:03:00.0: 0x000019A8 | ADVANCED_SYSASSERT         =20
iwlwifi 0000:03:00.0: 0x00015424 | uPc
iwlwifi 0000:03:00.0: 0x000093F4 | branchlink1
iwlwifi 0000:03:00.0: 0x000093F4 | branchlink2
iwlwifi 0000:03:00.0: 0x0000D1F2 | interruptlink1
iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
iwlwifi 0000:03:00.0: 0x00000001 | data1
iwlwifi 0000:03:00.0: 0x000B0002 | data2
iwlwifi 0000:03:00.0: 0x000000E2 | line
iwlwifi 0000:03:00.0: 0x00018D71 | beacon time
iwlwifi 0000:03:00.0: 0x0000028E | tsf low
iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
iwlwifi 0000:03:00.0: 0x00000000 | time gp1
iwlwifi 0000:03:00.0: 0x002D7A6A | time gp2
iwlwifi 0000:03:00.0: 0x00000000 | time gp3
iwlwifi 0000:03:00.0: 0x000111A8 | uCode version
iwlwifi 0000:03:00.0: 0x000000B0 | hw version
iwlwifi 0000:03:00.0: 0x00480303 | board version
iwlwifi 0000:03:00.0: 0x093E004E | hcmd
iwlwifi 0000:03:00.0: 0xA7C63080 | isr0
iwlwifi 0000:03:00.0: 0x0101E000 | isr1
iwlwifi 0000:03:00.0: 0x00000E02 | isr2
iwlwifi 0000:03:00.0: 0x0143B8C2 | isr3
iwlwifi 0000:03:00.0: 0x00000000 | isr4
iwlwifi 0000:03:00.0: 0x01000112 | isr_pref
iwlwifi 0000:03:00.0: 0x00014EAC | wait_event
iwlwifi 0000:03:00.0: 0x000008B0 | l2p_control
iwlwifi 0000:03:00.0: 0x0000013A | l2p_duration
iwlwifi 0000:03:00.0: 0x0000003F | l2p_mhvalid
iwlwifi 0000:03:00.0: 0x001155C0 | l2p_addr_match
iwlwifi 0000:03:00.0: 0x00000005 | lmpm_pmg_sel
iwlwifi 0000:03:00.0: 0x07061735 | timestamp
iwlwifi 0000:03:00.0: 0x0000B8C8 | flow_handler
iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 20 entries
iwlwifi 0000:03:00.0: EVT_LOGT:0002980080:0x00000000:0301
iwlwifi 0000:03:00.0: EVT_LOGT:0002980332:0x093d0018:0401
iwlwifi 0000:03:00.0: EVT_LOGT:0002980353:0x00020000:1550
iwlwifi 0000:03:00.0: EVT_LOGT:0002980356:0x00000011:1550
iwlwifi 0000:03:00.0: EVT_LOGT:0002980357:0x00020000:1555
iwlwifi 0000:03:00.0: EVT_LOGT:0002980358:0x00000000:1555
iwlwifi 0000:03:00.0: EVT_LOGT:0002980358:0x000001eb:1555
iwlwifi 0000:03:00.0: EVT_LOGT:0002980359:0x00020000:1552
iwlwifi 0000:03:00.0: EVT_LOGT:0002980360:0x00000000:1550
iwlwifi 0000:03:00.0: EVT_LOGT:0002980395:0x002d7a2b:1110
iwlwifi 0000:03:00.0: EVT_LOGT:0002980396:0x00000000:1110
iwlwifi 0000:03:00.0: EVT_LOGT:0002980438:0x00000022:1111
iwlwifi 0000:03:00.0: EVT_LOGT:0002980439:0x00000022:0454
iwlwifi 0000:03:00.0: EVT_LOGT:0002980440:0x00000000:0472
iwlwifi 0000:03:00.0: EVT_LOGT:0002980445:0x0000000b:0463
iwlwifi 0000:03:00.0: EVT_LOGT:0002980446:0x00000022:0487
iwlwifi 0000:03:00.0: EVT_LOGT:0002980448:0x00000000:0663
iwlwifi 0000:03:00.0: EVT_LOGT:0002980449:0x00000022:1592
iwlwifi 0000:03:00.0: EVT_LOGT:0002980452:0x093e004e:0401
iwlwifi 0000:03:00.0: EVT_LOGT:0002980477:0x00000000:0125
iwlwifi 0000:03:00.0: Error sending REPLY_TX_LINK_QUALITY_CMD: time out aft=
er 2000ms.
iwlwifi 0000:03:00.0: Current CMD queue read_ptr 62 write_ptr 63
iwlwifi 0000:03:00.0: Command REPLY_ADD_STA failed: FW Error
iwlwifi 0000:03:00.0: Adding station ff:ff:ff:ff:ff:ff failed.
ieee80211 phy0: Hardware restart was requested
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: Radio type=3D0x1-0x2-0x0
wlan0: associate with c0:25:06:6a:3d:86 (try 1/3)
wlan0: RX AssocResp from c0:25:06:6a:3d:86 (capab=3D0x431 status=3D0 aid=3D=
4)
wlan0: associated




cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eir=
p)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: DE
cfg80211: Regulatory domain changed to country: DE
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eir=
p)
cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5150000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
wlan0: authenticate with c0:25:06:6a:3d:86
wlan0: send auth to c0:25:06:6a:3d:86 (try 1/3)
wlan0: authenticated
wlan0: associate with c0:25:06:6a:3d:86 (try 1/3)
wlan0: RX AssocResp from c0:25:06:6a:3d:86 (capab=3D0x431 status=3D0 aid=3D=
1)
wlan0: associated
cfg80211: Calling CRDA for country: DE
cfg80211: Regulatory domain changed to country: DE
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eir=
p)
cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5150000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
iwlwifi 0000:03:00.0: fail to flush all tx fifo queues
iwlwifi 0000:03:00.0: Queue 11 stuck for 10000 ms.
iwlwifi 0000:03:00.0: Current SW read_ptr 43 write_ptr 201
iwlwifi 0000:03:00.0: Current HW read_ptr 43 write_ptr 201
iwlwifi 0000:03:00.0: Loaded firmware version: 17.168.5.3 build 42301
iwlwifi 0000:03:00.0: 0x00000000 | OK                         =20
iwlwifi 0000:03:00.0: 0x00000000 | uPc
iwlwifi 0000:03:00.0: 0x00000000 | branchlink1
iwlwifi 0000:03:00.0: 0x00000000 | branchlink2
iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
iwlwifi 0000:03:00.0: 0x00000000 | data1
iwlwifi 0000:03:00.0: 0x00000000 | data2
iwlwifi 0000:03:00.0: 0x00000000 | line
iwlwifi 0000:03:00.0: 0x00000000 | beacon time
iwlwifi 0000:03:00.0: 0x00000000 | tsf low
iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
iwlwifi 0000:03:00.0: 0x00000000 | time gp1
iwlwifi 0000:03:00.0: 0x00000000 | time gp2
iwlwifi 0000:03:00.0: 0x00000000 | time gp3
iwlwifi 0000:03:00.0: 0x00000000 | uCode version
iwlwifi 0000:03:00.0: 0x00000000 | hw version
iwlwifi 0000:03:00.0: 0x00000000 | board version
iwlwifi 0000:03:00.0: 0x00000000 | hcmd
iwlwifi 0000:03:00.0: 0x00000000 | isr0
iwlwifi 0000:03:00.0: 0x00000000 | isr1
iwlwifi 0000:03:00.0: 0x00000000 | isr2
iwlwifi 0000:03:00.0: 0x00000000 | isr3
iwlwifi 0000:03:00.0: 0x00000000 | isr4
iwlwifi 0000:03:00.0: 0x00000000 | isr_pref
iwlwifi 0000:03:00.0: 0x00000000 | wait_event
iwlwifi 0000:03:00.0: 0x00000000 | l2p_control
iwlwifi 0000:03:00.0: 0x00000000 | l2p_duration
iwlwifi 0000:03:00.0: 0x00000000 | l2p_mhvalid
iwlwifi 0000:03:00.0: 0x00000000 | l2p_addr_match
iwlwifi 0000:03:00.0: 0x00000000 | lmpm_pmg_sel
iwlwifi 0000:03:00.0: 0x00000000 | timestamp
iwlwifi 0000:03:00.0: 0x00000000 | flow_handler
iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 20 entries
iwlwifi 0000:03:00.0: EVT_LOGT:0665102403:0x00000000:0301
iwlwifi 0000:03:00.0: EVT_LOGT:0665102492:0x00000000:0301
iwlwifi 0000:03:00.0: EVT_LOGT:0665102579:0x00000000:0301
iwlwifi 0000:03:00.0: EVT_LOGT:0665102666:0x00000000:0301
iwlwifi 0000:03:00.0: EVT_LOGT:0665102753:0x00000000:0301
iwlwifi 0000:03:00.0: EVT_LOGT:0665102840:0x00000000:0301
iwlwifi 0000:03:00.0: EVT_LOGT:0665102932:0x00000000:0301
iwlwifi 0000:03:00.0: EVT_LOGT:0665103021:0x00000000:0301
iwlwifi 0000:03:00.0: EVT_LOGT:0665103108:0x00000000:0301
iwlwifi 0000:03:00.0: EVT_LOGT:0665103195:0x00000000:0301
iwlwifi 0000:03:00.0: EVT_LOGT:0665103282:0x00000000:0301
iwlwifi 0000:03:00.0: EVT_LOGT:0665103372:0x00000000:0301
iwlwifi 0000:03:00.0: EVT_LOGT:0665103716:0x00000000:0301
iwlwifi 0000:03:00.0: EVT_LOGT:0665103882:0x00000000:0301
iwlwifi 0000:03:00.0: EVT_LOGT:0665104048:0x00000000:0301
iwlwifi 0000:03:00.0: EVT_LOGT:0665104222:0x00000000:0301
iwlwifi 0000:03:00.0: EVT_LOGT:0665104404:0x00000000:0301
iwlwifi 0000:03:00.0: EVT_LOGT:0665104587:0x00000000:0301
iwlwifi 0000:03:00.0: EVT_LOGT:0665105004:0x00000000:0301
iwlwifi 0000:03:00.0: EVT_LOGT:0665105176:0x00000000:0301
ieee80211 phy0: Hardware restart was requested
iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
iwlwifi 0000:03:00.0: Radio type=3D0x1-0x2-0x0

--Sig_/G5bz/orOwwmP3xQwXyKJ4a5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlATwQcACgkQnhRzXSM7nSntPwCbBm+rmmq4OG4POKSBbqKGdQRp
urMAn2RGaBewvVTxAHjDM7rC7UEjbe/d
=5CqG
-----END PGP SIGNATURE-----

--Sig_/G5bz/orOwwmP3xQwXyKJ4a5--

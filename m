Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar-3.linta.de ([188.40.101.200]:36530 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750802AbbEYSS0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2015 14:18:26 -0400
Date: Mon, 25 May 2015 20:10:43 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: linux-wireless@vger.kernel.org
Subject: iwlwifi: Queue 16 stuck for 10000 ms - Microcode SW error detected.
Message-ID: <20150525181043.GA10755@light.dominikbrodowski.net> (sfid-20150525_201830_605057_D9CB0D9E)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey,

on my pretty new iwlwifi device 8086:08b1 (7260), the following error just
appeared twice in dmesg on 4.1.0-rc4+ (Linus' tree as of Saturday/Sunday
morning):

iwlwifi 0000:02:00.0: Queue 16 stuck for 10000 ms.
iwlwifi 0000:02:00.0: Current SW read_ptr 109 write_ptr 243
iwl data: 00000000: 00 00 00 00 00 00 00 00 00 e0 ff 1f 00 00 00 00  ......=
=2E.........
iwlwifi 0000:02:00.0: FH TRBs(0) =3D 0x80003019
iwlwifi 0000:02:00.0: FH TRBs(1) =3D 0xc011007c
iwlwifi 0000:02:00.0: FH TRBs(2) =3D 0x00000000
iwlwifi 0000:02:00.0: FH TRBs(3) =3D 0x80300015
iwlwifi 0000:02:00.0: FH TRBs(4) =3D 0x00000000
iwlwifi 0000:02:00.0: FH TRBs(5) =3D 0x00000000
iwlwifi 0000:02:00.0: FH TRBs(6) =3D 0x00000000
iwlwifi 0000:02:00.0: FH TRBs(7) =3D 0x007090d3
iwlwifi 0000:02:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [22,=
22]
iwlwifi 0000:02:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
iwlwifi 0000:02:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [187=
,187]
iwlwifi 0000:02:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [10,=
39]
iwlwifi 0000:02:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0=
,0]
iwlwifi 0000:02:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0=
,0]
iwlwifi 0000:02:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0=
,0]
iwlwifi 0000:02:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0=
,0]
iwlwifi 0000:02:00.0: Q 8 is inactive and mapped to fifo 0 ra_tid 0x0000 [0=
,0]
iwlwifi 0000:02:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [212=
,212]
iwlwifi 0000:02:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [=
0,0]
iwlwifi 0000:02:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [=
0,0]
iwlwifi 0000:02:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [=
0,0]
iwlwifi 0000:02:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [=
0,0]
iwlwifi 0000:02:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [=
0,0]
iwlwifi 0000:02:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,=
0]
iwlwifi 0000:02:00.0: Q 16 is active and mapped to fifo 1 ra_tid 0x0000 [10=
9,243]
iwlwifi 0000:02:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [=
0,0]
iwlwifi 0000:02:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [=
0,0]
iwlwifi 0000:02:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [=
0,0]
iwlwifi 0000:02:00.0: Microcode SW error detected.  Restarting 0x2000000.
iwlwifi 0000:02:00.0: CSR values:
iwlwifi 0000:02:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_R=
EG)
iwlwifi 0000:02:00.0:        CSR_HW_IF_CONFIG_REG: 0X40489204
iwlwifi 0000:02:00.0:          CSR_INT_COALESCING: 0X80000040
iwlwifi 0000:02:00.0:                     CSR_INT: 0X00000000
iwlwifi 0000:02:00.0:                CSR_INT_MASK: 0X00000000
iwlwifi 0000:02:00.0:           CSR_FH_INT_STATUS: 0X00000000
iwlwifi 0000:02:00.0:                 CSR_GPIO_IN: 0X00000000
iwlwifi 0000:02:00.0:                   CSR_RESET: 0X00000000
iwlwifi 0000:02:00.0:                CSR_GP_CNTRL: 0X080403c5
iwlwifi 0000:02:00.0:                  CSR_HW_REV: 0X00000144
iwlwifi 0000:02:00.0:              CSR_EEPROM_REG: 0X00000000
iwlwifi 0000:02:00.0:               CSR_EEPROM_GP: 0X80000000
iwlwifi 0000:02:00.0:              CSR_OTP_GP_REG: 0X803a0000
iwlwifi 0000:02:00.0:                 CSR_GIO_REG: 0X00080040
iwlwifi 0000:02:00.0:            CSR_GP_UCODE_REG: 0X00000000
iwlwifi 0000:02:00.0:           CSR_GP_DRIVER_REG: 0X00000000
iwlwifi 0000:02:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
iwlwifi 0000:02:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
iwlwifi 0000:02:00.0:                 CSR_LED_REG: 0X00000060
iwlwifi 0000:02:00.0:        CSR_DRAM_INT_TBL_REG: 0X8821408e
iwlwifi 0000:02:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
iwlwifi 0000:02:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
iwlwifi 0000:02:00.0:      CSR_MONITOR_STATUS_REG: 0X3c08019d
iwlwifi 0000:02:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
iwlwifi 0000:02:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
iwlwifi 0000:02:00.0: FH register values:
iwlwifi 0000:02:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X21418b00
iwlwifi 0000:02:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X021418a0
iwlwifi 0000:02:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000080
iwlwifi 0000:02:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
iwlwifi 0000:02:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
iwlwifi 0000:02:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
iwlwifi 0000:02:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
iwlwifi 0000:02:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
iwlwifi 0000:02:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
iwlwifi 0000:02:00.0: Start IWL Error Log Dump:
iwlwifi 0000:02:00.0: Status: 0x00000000, count: 6
iwlwifi 0000:02:00.0: Loaded firmware version: 25.24.13.0
iwlwifi 0000:02:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN      =20
iwlwifi 0000:02:00.0: 0x00000230 | uPc
iwlwifi 0000:02:00.0: 0x00000000 | branchlink1
iwlwifi 0000:02:00.0: 0x00000B2E | branchlink2
iwlwifi 0000:02:00.0: 0x00016210 | interruptlink1
iwlwifi 0000:02:00.0: 0x00016210 | interruptlink2
iwlwifi 0000:02:00.0: 0x00000000 | data1
iwlwifi 0000:02:00.0: 0x00000080 | data2
iwlwifi 0000:02:00.0: 0x07030000 | data3
iwlwifi 0000:02:00.0: 0x50C13A19 | beacon time
iwlwifi 0000:02:00.0: 0x0844762D | tsf low
iwlwifi 0000:02:00.0: 0x00000075 | tsf hi
iwlwifi 0000:02:00.0: 0x00000000 | time gp1
iwlwifi 0000:02:00.0: 0x4577111A | time gp2
iwlwifi 0000:02:00.0: 0x00000000 | time gp3
iwlwifi 0000:02:00.0: 0x00041918 | uCode version
iwlwifi 0000:02:00.0: 0x00000144 | hw version
iwlwifi 0000:02:00.0: 0x40489204 | board version
iwlwifi 0000:02:00.0: 0x09D30018 | hcmd
iwlwifi 0000:02:00.0: 0x24022003 | isr0
iwlwifi 0000:02:00.0: 0x01800000 | isr1
iwlwifi 0000:02:00.0: 0x0000000A | isr2
iwlwifi 0000:02:00.0: 0x004140C0 | isr3
iwlwifi 0000:02:00.0: 0x00000000 | isr4
iwlwifi 0000:02:00.0: 0x00000110 | isr_pref
iwlwifi 0000:02:00.0: 0x00000000 | wait_event
iwlwifi 0000:02:00.0: 0x00000080 | l2p_control
iwlwifi 0000:02:00.0: 0x00010030 | l2p_duration
iwlwifi 0000:02:00.0: 0x0000003F | l2p_mhvalid
iwlwifi 0000:02:00.0: 0x000000CE | l2p_addr_match
iwlwifi 0000:02:00.0: 0x00000005 | lmpm_pmg_sel
iwlwifi 0000:02:00.0: 0x09051509 | timestamp
iwlwifi 0000:02:00.0: 0x00348090 | flow_handler
ieee80211 phy0: Hardware restart was requested
iwlwifi 0000:02:00.0: L1 Enabled - LTR Disabled

wifi works fine afterwards (at maximum, a reconnect is required), but
still something seems to be at odds here...

Best,
	Dominik

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVY2WjAAoJEJqXYIlMjaMNrpIQALKBp95V5CoGDmtmp03TgDUB
1lzMvxFVPC9m+xxLvFYsh/GaurK1lpZJBQQtMsTfsrSkjb6sHCUm75fXb8DiSlMK
5vnTzc/5vq2oO3PQratqhb29PrDhaTNzRy+h5UFx8eFdmfIkdYDzAjRmPyEnxkru
sktjOQlDeQReHWq3dxKbdkJvK6QP5sIRXugov1eLLYdxWitcMmMN/rWPMaa/Fv+G
pbaAdBb1L5PU79URn9x8PICT+LlLC0V3Ta/kvV8X9iFlet2Fh9ebf/+/DDzrfDO9
hHTkMm/0yoRP3uoUiLMiOSi9GOLvc0bd6w4PF0NsQVfZ5Y3CWfZA54TWy0wzlNMg
X5scq1T6lhOFr8GkHtubPql5EXf3whOLlv2Zbshe2CW/1OWvliuICXdFQSZw0RRO
gscxHXnaZXIFSKp/VaX+bsrUmSMBUPy+Eugumf3+0IK20hfzk6OmAwBwCW8bTFA2
NnSuBvBLAkX5noRbC7rxxoC+9z29Z5PWMAfic8edN4XhP66InYG46adWU6EDjL/3
BWGib9jH+bIRaBAKQ9Zc+4DAVDRPpnNyYHy0MINDTd9EP21nJ8nRFOdVz0kQ5MAY
puPmF/c++a5oZ+x8W2RVElrD9tXqJ57DeMY36lAF70wS1df7fIQwMc3Ts2HCiNlx
MDDOVyzNflRWy3p5QqIf
=esjm
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--

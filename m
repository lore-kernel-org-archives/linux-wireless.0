Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar-3.linta.de ([188.40.101.200]:48153 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752882AbbE2UEn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 16:04:43 -0400
Date: Fri, 29 May 2015 22:04:06 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi: Queue 16 stuck for 10000 ms - Microcode SW error
 detected.
Message-ID: <20150529200405.GA27272@light.dominikbrodowski.net> (sfid-20150529_220447_537637_9AAB8FFD)
References: <20150525181043.GA10755@light.dominikbrodowski.net>
 <CANUX_P0+oGdKvY360xSekCmZjZFpe7PMS+shC9==-G-A-1O3sw@mail.gmail.com>
 <20150525184047.GA12142@light.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
In-Reply-To: <20150525184047.GA12142@light.dominikbrodowski.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 25, 2015 at 08:40:47PM +0200, Dominik Brodowski wrote:
> On Mon, May 25, 2015 at 09:27:39PM +0300, Emmanuel Grumbach wrote:
> > On Mon, May 25, 2015 at 9:10 PM, Dominik Brodowski
> > <linux@dominikbrodowski.net> wrote:
> > > Hey,
> > >
> > > on my pretty new iwlwifi device 8086:08b1 (7260), the following error=
 just
> > > appeared twice in dmesg on 4.1.0-rc4+ (Linus' tree as of Saturday/Sun=
day
> > > morning):
> >=20
> > Firmware problem. Please try to update your -13.ucode from the git
> > repository (https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/linux-=
firmware.git/)
>=20
> Thanks, will test.

No joy. Firmware 25.27.13.0 also is not happy at times:

iwlwifi 0000:02:00.0: invalid BA notification: Q 16, tid 0, flow 65535
iwlwifi 0000:02:00.0: invalid BA notification: Q 16, tid 0, flow 65535
iwlwifi 0000:02:00.0: invalid BA notification: Q 16, tid 0, flow 65535
iwlwifi 0000:02:00.0: Queue 2 stuck for 10000 ms.
iwlwifi 0000:02:00.0: Current SW read_ptr 36 write_ptr 67
iwl data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ......=
=2E.........
iwlwifi 0000:02:00.0: FH TRBs(0) =3D 0x00000000
iwlwifi 0000:02:00.0: FH TRBs(1) =3D 0xc01100b8
iwlwifi 0000:02:00.0: FH TRBs(2) =3D 0x00000000
iwlwifi 0000:02:00.0: FH TRBs(3) =3D 0x80300008
iwlwifi 0000:02:00.0: FH TRBs(4) =3D 0x00000000
iwlwifi 0000:02:00.0: FH TRBs(5) =3D 0x00000000
iwlwifi 0000:02:00.0: FH TRBs(6) =3D 0x00000000
iwlwifi 0000:02:00.0: FH TRBs(7) =3D 0x0070904c
iwlwifi 0000:02:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [9,9]
iwlwifi 0000:02:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
iwlwifi 0000:02:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [36,=
67]
iwlwifi 0000:02:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
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
iwlwifi 0000:02:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [77,=
77]
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
iwlwifi 0000:02:00.0: Q 16 is active and mapped to fifo 1 ra_tid 0x0000 [16=
9,230]
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
iwlwifi 0000:02:00.0:        CSR_DRAM_INT_TBL_REG: 0X8821408c
iwlwifi 0000:02:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
iwlwifi 0000:02:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
iwlwifi 0000:02:00.0:      CSR_MONITOR_STATUS_REG: 0X3c08019d
iwlwifi 0000:02:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
iwlwifi 0000:02:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
iwlwifi 0000:02:00.0: FH register values:
iwlwifi 0000:02:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0d9f3000
iwlwifi 0000:02:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00d9f2f0
iwlwifi 0000:02:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000e0
iwlwifi 0000:02:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
iwlwifi 0000:02:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
iwlwifi 0000:02:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
iwlwifi 0000:02:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
iwlwifi 0000:02:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
iwlwifi 0000:02:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
iwlwifi 0000:02:00.0: Start IWL Error Log Dump:
iwlwifi 0000:02:00.0: Status: 0x00000000, count: 6
iwlwifi 0000:02:00.0: Loaded firmware version: 25.27.13.0
iwlwifi 0000:02:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN      =20
iwlwifi 0000:02:00.0: 0x00A002F0 | uPc
iwlwifi 0000:02:00.0: 0x00000000 | branchlink1
iwlwifi 0000:02:00.0: 0x00000B2E | branchlink2
iwlwifi 0000:02:00.0: 0x00016218 | interruptlink1
iwlwifi 0000:02:00.0: 0x00016218 | interruptlink2
iwlwifi 0000:02:00.0: 0x00000000 | data1
iwlwifi 0000:02:00.0: 0x00000080 | data2
iwlwifi 0000:02:00.0: 0x07030000 | data3
iwlwifi 0000:02:00.0: 0xC600F06D | beacon time
iwlwifi 0000:02:00.0: 0x95A5CF83 | tsf low
iwlwifi 0000:02:00.0: 0x00000003 | tsf hi
iwlwifi 0000:02:00.0: 0x00000000 | time gp1
iwlwifi 0000:02:00.0: 0x164C8D06 | time gp2
iwlwifi 0000:02:00.0: 0x00000000 | time gp3
iwlwifi 0000:02:00.0: 0x0004191B | uCode version
iwlwifi 0000:02:00.0: 0x00000144 | hw version
iwlwifi 0000:02:00.0: 0x40489204 | board version
iwlwifi 0000:02:00.0: 0x10A9001C | hcmd
iwlwifi 0000:02:00.0: 0x00022002 | isr0
iwlwifi 0000:02:00.0: 0x01800000 | isr1
iwlwifi 0000:02:00.0: 0x0000000A | isr2
iwlwifi 0000:02:00.0: 0x004174C0 | isr3
iwlwifi 0000:02:00.0: 0x00000000 | isr4
iwlwifi 0000:02:00.0: 0x00000110 | isr_pref
iwlwifi 0000:02:00.0: 0x00000000 | wait_event
iwlwifi 0000:02:00.0: 0x0000024D | l2p_control
iwlwifi 0000:02:00.0: 0x00000020 | l2p_duration
iwlwifi 0000:02:00.0: 0x00000003 | l2p_mhvalid
iwlwifi 0000:02:00.0: 0x000000EE | l2p_addr_match
iwlwifi 0000:02:00.0: 0x00000005 | lmpm_pmg_sel
iwlwifi 0000:02:00.0: 0x21051936 | timestamp
iwlwifi 0000:02:00.0: 0x0034E0E8 | flow_handler
ieee80211 phy0: Hardware restart was requested
iwlwifi 0000:02:00.0: L1 Enabled - LTR Disabled
iwlwifi 0000:02:00.0: L1 Enabled - LTR Disabled
iwlwifi 0000:02:00.0: L1 Enabled - LTR Disabled
iwlwifi 0000:02:00.0: L1 Enabled - LTR Disabled

Best,
	Dominik

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVaMY1AAoJEJqXYIlMjaMN4tQP/jfVoIZEuTM2YhdeBjetQ4An
v8dkimvFRJULO9/qf/g4JOaDKphn58s8JBoF9FZWii+l2oJAxiC/mu1AVI8lyNKK
tA9am612kyTFHLpewUM1FxOSeRQYQRvQ0Fk/WgHe8oyN8VAaebXOnD4r0ajW1ZvP
r7R4sJNWwM/oI+sedCdmH2HrWx5w6vlVmgY3UbDkgt1fmKuYk6T5y5Hjc6vEw2lg
p6y0m9QeLAdXDjjHRwDtVUT6P0UkGFJoJ0B4wM+I2TuBRMNS15wgorfglEvJXt5M
WiaiaYO2wM6FnbCIPOVqt+wJcqT5plWfYhKvf0X/Z6eAbt7LsNpzf5g+H4XtSUmw
4MmGwVnY3QX70bvFdx+YOFHExwNaDYk66FFeS6DxtfpJtx4wcyYSCYAeZzCPh7ca
sexdxF9l7BvCzQJ7VoE92+UiSB1PUdiafVhJpH7BjzNrwZev5D1TQJpoApzlyzEX
CONXzeCiOcfcaQc2vp9yyShvXJEIM9X2hJTbEXddjkcOBJtw2ybnzJTNqnM4saG1
g/qt4rcA/3MOm6ccX2mtU7EcL3YiqIc+1DSO34H6OSOM6/kdNtvzOg8g/hFxEJgn
/A6yUUWEnpEa2YwWYaiPqrEf+gsiPUS2pCpu6WX1ShSgJJfRrMZm5zxTIWguEFzh
oEHo+jheP+EcVolMPiUO
=8AXf
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from betelgeuse.uberspace.de ([185.26.156.37]:39383 "EHLO
	betelgeuse.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbcGJLVX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jul 2016 07:21:23 -0400
Subject: Re: Problem: iwlwifi: Microcode SW error detected. Restarting
 0x2000000
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
References: <57820E4A.3010102@ytvwld.de>
 <0BA3FCBA62E2DC44AF3030971E174FB346688F92@hasmsx107.ger.corp.intel.com>
 <57822467.30500@ytvwld.de>
 <0BA3FCBA62E2DC44AF3030971E174FB346689061@hasmsx107.ger.corp.intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linuxwifi <linuxwifi@intel.com>
From: Niklas Sombert <niklas@ytvwld.de>
Message-ID: <57822F84.7060103@ytvwld.de> (sfid-20160710_132202_941091_BA13A52A)
Date: Sun, 10 Jul 2016 13:20:36 +0200
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB346689061@hasmsx107.ger.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JjmT0pQc4XrNF80mv7uVLnGx4K9olFgxB"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JjmT0pQc4XrNF80mv7uVLnGx4K9olFgxB
Content-Type: multipart/mixed; boundary="jUIa0DUc0Em6xgCr4Hr3CixIKScwua0eB"
From: Niklas Sombert <niklas@ytvwld.de>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 linuxwifi <linuxwifi@intel.com>
Message-ID: <57822F84.7060103@ytvwld.de>
Subject: Re: Problem: iwlwifi: Microcode SW error detected. Restarting
 0x2000000
References: <57820E4A.3010102@ytvwld.de>
 <0BA3FCBA62E2DC44AF3030971E174FB346688F92@hasmsx107.ger.corp.intel.com>
 <57822467.30500@ytvwld.de>
 <0BA3FCBA62E2DC44AF3030971E174FB346689061@hasmsx107.ger.corp.intel.com>
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB346689061@hasmsx107.ger.corp.intel.com>

--jUIa0DUc0Em6xgCr4Hr3CixIKScwua0eB
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Emmanuel Grumbach wrote:
> In that case, please try -21.ucode and send me again the output of the =
firmware error.

$ dmesg | grep iwlwifi
[   14.858440] iwlwifi 0000:04:00.0: Unsupported splx structure
[   14.863591] iwlwifi 0000:04:00.0: loaded firmware version 21.361477.0
op_mode iwlmvm
[   14.891553] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band
Wireless AC 7265, REV=3D0x210
[   14.893883] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[   14.894346] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[   24.346547] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[   24.347232] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[   24.413520] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[   24.414081] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  455.386139] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  455.386709] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  455.610758] iwlwifi 0000:04:00.0: Microcode SW error detected.
Restarting 0x2000000.
[  455.610761] iwlwifi 0000:04:00.0: CSR values:
[  455.610763] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is
CSR_INT_PERIODIC_REG)
[  455.610787] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c89=
200
[  455.610842] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000=
040
[  455.610893] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000=
000
[  455.610944] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000=
000
[  455.610995] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000=
000
[  455.611046] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000=
000
[  455.611097] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000=
000
[  455.611149] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X08040=
3c5
[  455.611200] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000=
210
[  455.611251] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd5555=
5d5
[  455.611302] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000=
000
[  455.611353] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd5555=
5d5
[  455.611404] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080=
042
[  455.611455] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000=
000
[  455.611506] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000=
000
[  455.611557] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000=
000
[  455.611608] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000=
000
[  455.611660] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000=
018
[  455.611711] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X88128=
8b0
[  455.611762] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800=
200
[  455.611813] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd5555=
5d5
[  455.611867] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xd3b7f=
f77
[  455.611921] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X00010=
01a
[  455.611971] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0=
000
[  455.611973] iwlwifi 0000:04:00.0: FH register values:
[  455.612035] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0b357d00
[  455.612047] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00b2de60
[  455.612058] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_WPTR: 0X00000000
[  455.612070] iwlwifi 0000:04:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[  455.612082] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  455.612093] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[  455.612105] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  455.612117] iwlwifi 0000:04:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  455.612128] iwlwifi 0000:04:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[  455.612237] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[  455.612239] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[  455.612240] iwlwifi 0000:04:00.0: Loaded firmware version: 21.361477.0=

[  455.612242] iwlwifi 0000:04:00.0: 0x00000034 | NMI_INTERRUPT_WDG

[  455.612243] iwlwifi 0000:04:00.0: 0x000002F0 | trm_hw_status0
[  455.612245] iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status1
[  455.612246] iwlwifi 0000:04:00.0: 0x000401CE | branchlink2
[  455.612247] iwlwifi 0000:04:00.0: 0x0004446C | interruptlink1
[  455.612249] iwlwifi 0000:04:00.0: 0x00005C9A | interruptlink2
[  455.612250] iwlwifi 0000:04:00.0: 0x00000000 | data1
[  455.612251] iwlwifi 0000:04:00.0: 0x00000002 | data2
[  455.612252] iwlwifi 0000:04:00.0: 0x07030000 | data3
[  455.612254] iwlwifi 0000:04:00.0: 0x003CB2E5 | beacon time
[  455.612255] iwlwifi 0000:04:00.0: 0x00034D19 | tsf low
[  455.612256] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
[  455.612257] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[  455.612259] iwlwifi 0000:04:00.0: 0x00034D1A | time gp2
[  455.612260] iwlwifi 0000:04:00.0: 0x00000000 | uCode revision type
[  455.612261] iwlwifi 0000:04:00.0: 0x00000015 | uCode version major
[  455.612263] iwlwifi 0000:04:00.0: 0x00058405 | uCode version minor
[  455.612264] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[  455.612265] iwlwifi 0000:04:00.0: 0x00C89200 | board version
[  455.612267] iwlwifi 0000:04:00.0: 0x0902006A | hcmd
[  455.612268] iwlwifi 0000:04:00.0: 0x02023080 | isr0
[  455.612269] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[  455.612270] iwlwifi 0000:04:00.0: 0x00000002 | isr2
[  455.612272] iwlwifi 0000:04:00.0: 0x404000C0 | isr3
[  455.612273] iwlwifi 0000:04:00.0: 0x00000080 | isr4
[  455.612274] iwlwifi 0000:04:00.0: 0x01800112 | last cmd Id
[  455.612275] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[  455.612277] iwlwifi 0000:04:00.0: 0x0000E226 | l2p_control
[  455.612278] iwlwifi 0000:04:00.0: 0x00000000 | l2p_duration
[  455.612279] iwlwifi 0000:04:00.0: 0x00000000 | l2p_mhvalid
[  455.612281] iwlwifi 0000:04:00.0: 0x00000000 | l2p_addr_match
[  455.612282] iwlwifi 0000:04:00.0: 0x00000007 | lmpm_pmg_sel
[  455.612283] iwlwifi 0000:04:00.0: 0x09071913 | timestamp
[  455.612284] iwlwifi 0000:04:00.0: 0x00340010 | flow_handler
[  455.612301] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
[  455.640984] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  455.641544] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  455.866112] iwlwifi 0000:04:00.0: Microcode SW error detected.
Restarting 0x2000000.
[  455.866120] iwlwifi 0000:04:00.0: CSR values:
[  455.866124] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is
CSR_INT_PERIODIC_REG)
[  455.866206] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c89=
200
[  455.866263] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000=
040
[  455.866319] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000=
000
[  455.866374] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000=
000
[  455.866429] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000=
000
[  455.866484] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000=
000
[  455.866539] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000=
000
[  455.866595] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X08040=
3c5
[  455.866650] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000=
210
[  455.866705] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd5555=
5d5
[  455.866760] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000=
000
[  455.866815] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd5555=
5d5
[  455.866871] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080=
042
[  455.866925] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000=
000
[  455.866980] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000=
000
[  455.867036] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000=
000
[  455.867102] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000=
000
[  455.867251] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000=
018
[  455.867306] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X88128=
8b0
[  455.867361] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800=
200
[  455.867416] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd5555=
5d5
[  455.867472] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xd3b7f=
fd7
[  455.867527] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X00010=
01a
[  455.867582] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0=
000
[  455.867585] iwlwifi 0000:04:00.0: FH register values:
[  455.867649] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0b357d00
[  455.867714] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00b2de60
[  455.867779] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_WPTR: 0X00000000
[  455.867840] iwlwifi 0000:04:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[  455.867901] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  455.867962] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[  455.868024] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  455.868088] iwlwifi 0000:04:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  455.868307] iwlwifi 0000:04:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[  455.868469] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[  455.868472] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[  455.868475] iwlwifi 0000:04:00.0: Loaded firmware version: 21.361477.0=

[  455.868478] iwlwifi 0000:04:00.0: 0x00000034 | NMI_INTERRUPT_WDG

[  455.868480] iwlwifi 0000:04:00.0: 0x000002F0 | trm_hw_status0
[  455.868483] iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status1
[  455.868485] iwlwifi 0000:04:00.0: 0x000401CE | branchlink2
[  455.868488] iwlwifi 0000:04:00.0: 0x0004446C | interruptlink1
[  455.868490] iwlwifi 0000:04:00.0: 0x0000B08E | interruptlink2
[  455.868492] iwlwifi 0000:04:00.0: 0x00000000 | data1
[  455.868494] iwlwifi 0000:04:00.0: 0x00000002 | data2
[  455.868497] iwlwifi 0000:04:00.0: 0x07030000 | data3
[  455.868499] iwlwifi 0000:04:00.0: 0x003CB0C8 | beacon time
[  455.868502] iwlwifi 0000:04:00.0: 0x00034F36 | tsf low
[  455.868504] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
[  455.868506] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[  455.868509] iwlwifi 0000:04:00.0: 0x00034F37 | time gp2
[  455.868511] iwlwifi 0000:04:00.0: 0x00000000 | uCode revision type
[  455.868513] iwlwifi 0000:04:00.0: 0x00000015 | uCode version major
[  455.868516] iwlwifi 0000:04:00.0: 0x00058405 | uCode version minor
[  455.868518] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[  455.868520] iwlwifi 0000:04:00.0: 0x00C89200 | board version
[  455.868523] iwlwifi 0000:04:00.0: 0x0902006A | hcmd
[  455.868525] iwlwifi 0000:04:00.0: 0x02023080 | isr0
[  455.868527] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[  455.868529] iwlwifi 0000:04:00.0: 0x00000002 | isr2
[  455.868532] iwlwifi 0000:04:00.0: 0x404000C0 | isr3
[  455.868534] iwlwifi 0000:04:00.0: 0x00000080 | isr4
[  455.868536] iwlwifi 0000:04:00.0: 0x01800112 | last cmd Id
[  455.868539] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[  455.868541] iwlwifi 0000:04:00.0: 0x0000E226 | l2p_control
[  455.868543] iwlwifi 0000:04:00.0: 0x00000000 | l2p_duration
[  455.868546] iwlwifi 0000:04:00.0: 0x00000000 | l2p_mhvalid
[  455.868548] iwlwifi 0000:04:00.0: 0x00000000 | l2p_addr_match
[  455.868550] iwlwifi 0000:04:00.0: 0x00000007 | lmpm_pmg_sel
[  455.868552] iwlwifi 0000:04:00.0: 0x09071913 | timestamp
[  455.868555] iwlwifi 0000:04:00.0: 0x00340010 | flow_handler
[  455.868631] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
[  455.874206] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  455.874662] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  456.099339] iwlwifi 0000:04:00.0: Microcode SW error detected.
Restarting 0x2000000.
[  456.099347] iwlwifi 0000:04:00.0: CSR values:
[  456.099351] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is
CSR_INT_PERIODIC_REG)
[  456.099400] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c89=
200
[  456.099457] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000=
040
[  456.099512] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000=
000
[  456.099567] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000=
000
[  456.099622] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000=
000
[  456.099677] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000=
000
[  456.099732] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000=
000
[  456.099788] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X08040=
3c5
[  456.099844] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000=
210
[  456.099899] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd5555=
5d5
[  456.099954] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000=
000
[  456.100009] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd5555=
5d5
[  456.100064] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080=
042
[  456.100119] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000=
000
[  456.100174] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000=
000
[  456.100229] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000=
000
[  456.100285] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000=
000
[  456.100340] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000=
018
[  456.100395] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X88128=
8b0
[  456.100450] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800=
200
[  456.100505] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd5555=
5d5
[  456.100571] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xd3b7f=
7d7
[  456.100720] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X00010=
01a
[  456.100775] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0=
000
[  456.100778] iwlwifi 0000:04:00.0: FH register values:
[  456.100842] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0b357d00
[  456.100903] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00b2de60
[  456.100964] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_WPTR: 0X00000000
[  456.101024] iwlwifi 0000:04:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[  456.101084] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  456.101144] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[  456.101206] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  456.101266] iwlwifi 0000:04:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  456.101327] iwlwifi 0000:04:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[  456.101490] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[  456.101493] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[  456.101497] iwlwifi 0000:04:00.0: Loaded firmware version: 21.361477.0=

[  456.101500] iwlwifi 0000:04:00.0: 0x00000034 | NMI_INTERRUPT_WDG

[  456.101503] iwlwifi 0000:04:00.0: 0x000002F0 | trm_hw_status0
[  456.101505] iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status1
[  456.101508] iwlwifi 0000:04:00.0: 0x000401CE | branchlink2
[  456.101510] iwlwifi 0000:04:00.0: 0x0004446C | interruptlink1
[  456.101513] iwlwifi 0000:04:00.0: 0x0000B0B8 | interruptlink2
[  456.101516] iwlwifi 0000:04:00.0: 0x00000000 | data1
[  456.101518] iwlwifi 0000:04:00.0: 0x00000002 | data2
[  456.101521] iwlwifi 0000:04:00.0: 0x07030000 | data3
[  456.101523] iwlwifi 0000:04:00.0: 0x003CB088 | beacon time
[  456.101526] iwlwifi 0000:04:00.0: 0x00034F76 | tsf low
[  456.101528] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
[  456.101531] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[  456.101533] iwlwifi 0000:04:00.0: 0x00034F77 | time gp2
[  456.101536] iwlwifi 0000:04:00.0: 0x00000000 | uCode revision type
[  456.101539] iwlwifi 0000:04:00.0: 0x00000015 | uCode version major
[  456.101541] iwlwifi 0000:04:00.0: 0x00058405 | uCode version minor
[  456.101544] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[  456.101546] iwlwifi 0000:04:00.0: 0x00C89200 | board version
[  456.101549] iwlwifi 0000:04:00.0: 0x0902006A | hcmd
[  456.101551] iwlwifi 0000:04:00.0: 0x02023080 | isr0
[  456.101554] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[  456.101556] iwlwifi 0000:04:00.0: 0x00000002 | isr2
[  456.101559] iwlwifi 0000:04:00.0: 0x404000C0 | isr3
[  456.101561] iwlwifi 0000:04:00.0: 0x00000080 | isr4
[  456.101564] iwlwifi 0000:04:00.0: 0x01800112 | last cmd Id
[  456.101567] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[  456.101569] iwlwifi 0000:04:00.0: 0x0000E226 | l2p_control
[  456.101572] iwlwifi 0000:04:00.0: 0x00000000 | l2p_duration
[  456.101574] iwlwifi 0000:04:00.0: 0x00000000 | l2p_mhvalid
[  456.101577] iwlwifi 0000:04:00.0: 0x00000000 | l2p_addr_match
[  456.101579] iwlwifi 0000:04:00.0: 0x00000007 | lmpm_pmg_sel
[  456.101582] iwlwifi 0000:04:00.0: 0x09071913 | timestamp
[  456.101584] iwlwifi 0000:04:00.0: 0x00340010 | flow_handler
[  456.101669] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
[  466.053923] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  466.054483] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  466.278862] iwlwifi 0000:04:00.0: Microcode SW error detected.
Restarting 0x2000000.
[  466.278870] iwlwifi 0000:04:00.0: CSR values:
[  466.278874] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is
CSR_INT_PERIODIC_REG)
[  466.278985] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c89=
200
[  466.279041] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000=
040
[  466.279097] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000=
000
[  466.279151] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000=
000
[  466.279207] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000=
000
[  466.279262] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000=
000
[  466.279317] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000=
000
[  466.279372] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X08040=
3c5
[  466.279427] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000=
210
[  466.279482] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd5555=
5d5
[  466.279537] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000=
000
[  466.279592] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd5555=
5d5
[  466.279648] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080=
042
[  466.279703] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000=
000
[  466.279758] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000=
000
[  466.279813] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000=
000
[  466.279868] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000=
000
[  466.279923] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000=
018
[  466.279978] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X88128=
8b0
[  466.280033] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800=
200
[  466.280089] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd5555=
5d5
[  466.280144] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xd3b7f=
7d7
[  466.280260] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X00010=
01a
[  466.280416] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0=
000
[  466.280422] iwlwifi 0000:04:00.0: FH register values:
[  466.280586] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0b357d00
[  466.280653] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00b2de60
[  466.280721] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_WPTR: 0X00000000
[  466.280789] iwlwifi 0000:04:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[  466.280857] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  466.280925] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[  466.280993] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  466.281062] iwlwifi 0000:04:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  466.281130] iwlwifi 0000:04:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[  466.281403] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[  466.281410] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[  466.281416] iwlwifi 0000:04:00.0: Loaded firmware version: 21.361477.0=

[  466.281422] iwlwifi 0000:04:00.0: 0x00000034 | NMI_INTERRUPT_WDG

[  466.281428] iwlwifi 0000:04:00.0: 0x000002F0 | trm_hw_status0
[  466.281434] iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status1
[  466.281439] iwlwifi 0000:04:00.0: 0x000401CE | branchlink2
[  466.281444] iwlwifi 0000:04:00.0: 0x0004446C | interruptlink1
[  466.281449] iwlwifi 0000:04:00.0: 0x00005C8C | interruptlink2
[  466.281454] iwlwifi 0000:04:00.0: 0x00000000 | data1
[  466.281459] iwlwifi 0000:04:00.0: 0x00000002 | data2
[  466.281464] iwlwifi 0000:04:00.0: 0x07030000 | data3
[  466.281470] iwlwifi 0000:04:00.0: 0x003CB043 | beacon time
[  466.281475] iwlwifi 0000:04:00.0: 0x00034FBB | tsf low
[  466.281481] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
[  466.281486] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[  466.281492] iwlwifi 0000:04:00.0: 0x00034FBC | time gp2
[  466.281498] iwlwifi 0000:04:00.0: 0x00000000 | uCode revision type
[  466.281503] iwlwifi 0000:04:00.0: 0x00000015 | uCode version major
[  466.281508] iwlwifi 0000:04:00.0: 0x00058405 | uCode version minor
[  466.281514] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[  466.281520] iwlwifi 0000:04:00.0: 0x00C89200 | board version
[  466.281525] iwlwifi 0000:04:00.0: 0x0902006A | hcmd
[  466.281531] iwlwifi 0000:04:00.0: 0x02023080 | isr0
[  466.281536] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[  466.281542] iwlwifi 0000:04:00.0: 0x00000002 | isr2
[  466.281547] iwlwifi 0000:04:00.0: 0x404000C0 | isr3
[  466.281553] iwlwifi 0000:04:00.0: 0x00000080 | isr4
[  466.281558] iwlwifi 0000:04:00.0: 0x01800112 | last cmd Id
[  466.281564] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[  466.281569] iwlwifi 0000:04:00.0: 0x0000E226 | l2p_control
[  466.281574] iwlwifi 0000:04:00.0: 0x00000000 | l2p_duration
[  466.281580] iwlwifi 0000:04:00.0: 0x00000000 | l2p_mhvalid
[  466.281588] iwlwifi 0000:04:00.0: 0x00000000 | l2p_addr_match
[  466.281593] iwlwifi 0000:04:00.0: 0x00000007 | lmpm_pmg_sel
[  466.281599] iwlwifi 0000:04:00.0: 0x09071913 | timestamp
[  466.281604] iwlwifi 0000:04:00.0: 0x00340010 | flow_handler
[  466.281663] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
[  466.288524] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  466.288980] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  466.513482] iwlwifi 0000:04:00.0: Microcode SW error detected.
Restarting 0x2000000.
[  466.513487] iwlwifi 0000:04:00.0: CSR values:
[  466.513490] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is
CSR_INT_PERIODIC_REG)
[  466.513525] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c89=
200
[  466.513579] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000=
040
[  466.513634] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000=
000
[  466.513689] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000=
000
[  466.513744] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000=
000
[  466.513799] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000=
000
[  466.513854] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000=
000
[  466.513910] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X08040=
3c5
[  466.513965] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000=
210
[  466.514020] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd5555=
5d5
[  466.514075] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000=
000
[  466.514130] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd5555=
5d5
[  466.514185] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080=
042
[  466.514240] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000=
000
[  466.514295] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000=
000
[  466.514351] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000=
000
[  466.514406] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000=
000
[  466.514461] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000=
018
[  466.514516] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X88128=
8b0
[  466.514571] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800=
200
[  466.514626] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd5555=
5d5
[  466.514681] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xd3b7f=
f77
[  466.514737] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X00010=
01a
[  466.514792] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0=
000
[  466.514794] iwlwifi 0000:04:00.0: FH register values:
[  466.514858] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0b357d00
[  466.514919] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00b2de60
[  466.514979] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_WPTR: 0X00000000
[  466.515039] iwlwifi 0000:04:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[  466.515099] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  466.515159] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[  466.515220] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  466.515280] iwlwifi 0000:04:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  466.515341] iwlwifi 0000:04:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[  466.515502] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[  466.515506] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[  466.515508] iwlwifi 0000:04:00.0: Loaded firmware version: 21.361477.0=

[  466.515511] iwlwifi 0000:04:00.0: 0x00000034 | NMI_INTERRUPT_WDG

[  466.515513] iwlwifi 0000:04:00.0: 0x000002F0 | trm_hw_status0
[  466.515515] iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status1
[  466.515517] iwlwifi 0000:04:00.0: 0x000401CE | branchlink2
[  466.515519] iwlwifi 0000:04:00.0: 0x0004446C | interruptlink1
[  466.515522] iwlwifi 0000:04:00.0: 0x0000B0BA | interruptlink2
[  466.515524] iwlwifi 0000:04:00.0: 0x00000000 | data1
[  466.515526] iwlwifi 0000:04:00.0: 0x00000002 | data2
[  466.515528] iwlwifi 0000:04:00.0: 0x07030000 | data3
[  466.515531] iwlwifi 0000:04:00.0: 0x003CB09D | beacon time
[  466.515533] iwlwifi 0000:04:00.0: 0x00034F61 | tsf low
[  466.515535] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
[  466.515537] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[  466.515540] iwlwifi 0000:04:00.0: 0x00034F62 | time gp2
[  466.515542] iwlwifi 0000:04:00.0: 0x00000000 | uCode revision type
[  466.515544] iwlwifi 0000:04:00.0: 0x00000015 | uCode version major
[  466.515547] iwlwifi 0000:04:00.0: 0x00058405 | uCode version minor
[  466.515549] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[  466.515551] iwlwifi 0000:04:00.0: 0x00C89200 | board version
[  466.515554] iwlwifi 0000:04:00.0: 0x0902006A | hcmd
[  466.515556] iwlwifi 0000:04:00.0: 0x02023080 | isr0
[  466.515558] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[  466.515560] iwlwifi 0000:04:00.0: 0x00000002 | isr2
[  466.515563] iwlwifi 0000:04:00.0: 0x404000C0 | isr3
[  466.515565] iwlwifi 0000:04:00.0: 0x00000080 | isr4
[  466.515567] iwlwifi 0000:04:00.0: 0x01800112 | last cmd Id
[  466.515569] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[  466.515572] iwlwifi 0000:04:00.0: 0x0000E226 | l2p_control
[  466.515574] iwlwifi 0000:04:00.0: 0x00000000 | l2p_duration
[  466.515576] iwlwifi 0000:04:00.0: 0x00000000 | l2p_mhvalid
[  466.515579] iwlwifi 0000:04:00.0: 0x00000000 | l2p_addr_match
[  466.515581] iwlwifi 0000:04:00.0: 0x00000007 | lmpm_pmg_sel
[  466.515583] iwlwifi 0000:04:00.0: 0x09071913 | timestamp
[  466.515586] iwlwifi 0000:04:00.0: 0x00340010 | flow_handler
[  466.515616] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
[  477.053714] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  477.054287] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  477.278754] iwlwifi 0000:04:00.0: Microcode SW error detected.
Restarting 0x2000000.
[  477.278763] iwlwifi 0000:04:00.0: CSR values:
[  477.278767] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is
CSR_INT_PERIODIC_REG)
[  477.278875] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c89=
200
[  477.278931] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000=
040
[  477.279046] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000=
000
[  477.279198] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000=
000
[  477.279254] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000=
000
[  477.279309] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000=
000
[  477.279364] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000=
000
[  477.279419] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X08040=
3c5
[  477.279474] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000=
210
[  477.279529] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd5555=
5d5
[  477.279584] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000=
000
[  477.279639] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd5555=
5d5
[  477.279695] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080=
042
[  477.279750] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000=
000
[  477.279805] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000=
000
[  477.279860] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000=
000
[  477.279915] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000=
000
[  477.279970] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000=
018
[  477.280026] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X88128=
8b0
[  477.280080] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800=
200
[  477.280137] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd5555=
5d5
[  477.280199] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xd3b7f=
777
[  477.280356] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X00010=
01a
[  477.280412] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0=
000
[  477.280416] iwlwifi 0000:04:00.0: FH register values:
[  477.280739] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0b357d00
[  477.280804] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00b2de60
[  477.280865] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_WPTR: 0X00000000
[  477.280925] iwlwifi 0000:04:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[  477.280985] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  477.281050] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[  477.281111] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  477.281171] iwlwifi 0000:04:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  477.281288] iwlwifi 0000:04:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[  477.281451] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[  477.281455] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[  477.281458] iwlwifi 0000:04:00.0: Loaded firmware version: 21.361477.0=

[  477.281461] iwlwifi 0000:04:00.0: 0x00000034 | NMI_INTERRUPT_WDG

[  477.281463] iwlwifi 0000:04:00.0: 0x000002F0 | trm_hw_status0
[  477.281466] iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status1
[  477.281469] iwlwifi 0000:04:00.0: 0x000401CE | branchlink2
[  477.281471] iwlwifi 0000:04:00.0: 0x0004446C | interruptlink1
[  477.281474] iwlwifi 0000:04:00.0: 0x00005C9A | interruptlink2
[  477.281476] iwlwifi 0000:04:00.0: 0x00000000 | data1
[  477.281479] iwlwifi 0000:04:00.0: 0x00000002 | data2
[  477.281481] iwlwifi 0000:04:00.0: 0x07030000 | data3
[  477.281484] iwlwifi 0000:04:00.0: 0x003CB163 | beacon time
[  477.281486] iwlwifi 0000:04:00.0: 0x00034E9B | tsf low
[  477.281489] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
[  477.281491] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[  477.281494] iwlwifi 0000:04:00.0: 0x00034E9C | time gp2
[  477.281497] iwlwifi 0000:04:00.0: 0x00000000 | uCode revision type
[  477.281499] iwlwifi 0000:04:00.0: 0x00000015 | uCode version major
[  477.281512] iwlwifi 0000:04:00.0: 0x00058405 | uCode version minor
[  477.281515] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[  477.281517] iwlwifi 0000:04:00.0: 0x00C89200 | board version
[  477.281519] iwlwifi 0000:04:00.0: 0x0902006A | hcmd
[  477.281521] iwlwifi 0000:04:00.0: 0x02023080 | isr0
[  477.281523] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[  477.281525] iwlwifi 0000:04:00.0: 0x00000002 | isr2
[  477.281528] iwlwifi 0000:04:00.0: 0x404000C0 | isr3
[  477.281533] iwlwifi 0000:04:00.0: 0x00000080 | isr4
[  477.281535] iwlwifi 0000:04:00.0: 0x01800112 | last cmd Id
[  477.281538] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[  477.281540] iwlwifi 0000:04:00.0: 0x0000E226 | l2p_control
[  477.281542] iwlwifi 0000:04:00.0: 0x00000000 | l2p_duration
[  477.281544] iwlwifi 0000:04:00.0: 0x00000000 | l2p_mhvalid
[  477.281546] iwlwifi 0000:04:00.0: 0x00000000 | l2p_addr_match
[  477.281548] iwlwifi 0000:04:00.0: 0x00000007 | lmpm_pmg_sel
[  477.281551] iwlwifi 0000:04:00.0: 0x09071913 | timestamp
[  477.281553] iwlwifi 0000:04:00.0: 0x00340010 | flow_handler
[  477.281568] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
[  477.287139] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  477.287594] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  477.511590] iwlwifi 0000:04:00.0: Microcode SW error detected.
Restarting 0x2000000.
[  477.511598] iwlwifi 0000:04:00.0: CSR values:
[  477.511603] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is
CSR_INT_PERIODIC_REG)
[  477.511712] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c89=
200
[  477.511873] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000=
040
[  477.512032] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000=
000
[  477.512088] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000=
000
[  477.512145] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000=
000
[  477.512200] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000=
000
[  477.512255] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000=
000
[  477.512310] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X08040=
3c5
[  477.512365] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000=
210
[  477.512421] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd5555=
5d5
[  477.512476] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000=
000
[  477.512531] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd5555=
5d5
[  477.512586] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080=
042
[  477.512652] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000=
000
[  477.512801] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000=
000
[  477.512860] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000=
000
[  477.512915] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000=
000
[  477.512966] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000=
018
[  477.513017] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X88128=
8b0
[  477.513068] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800=
200
[  477.513120] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd5555=
5d5
[  477.513184] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xd3b7f=
7d7
[  477.513333] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X00010=
01a
[  477.513388] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0=
000
[  477.513391] iwlwifi 0000:04:00.0: FH register values:
[  477.513557] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0b357d00
[  477.513622] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00b2de60
[  477.513687] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_WPTR: 0X00000000
[  477.513752] iwlwifi 0000:04:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[  477.513817] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  477.513882] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[  477.513949] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  477.514016] iwlwifi 0000:04:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  477.514083] iwlwifi 0000:04:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[  477.514513] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[  477.514516] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[  477.514519] iwlwifi 0000:04:00.0: Loaded firmware version: 21.361477.0=

[  477.514522] iwlwifi 0000:04:00.0: 0x00000034 | NMI_INTERRUPT_WDG

[  477.514525] iwlwifi 0000:04:00.0: 0x000002F0 | trm_hw_status0
[  477.514527] iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status1
[  477.514529] iwlwifi 0000:04:00.0: 0x000401CE | branchlink2
[  477.514532] iwlwifi 0000:04:00.0: 0x0004446C | interruptlink1
[  477.514534] iwlwifi 0000:04:00.0: 0x0000B096 | interruptlink2
[  477.514536] iwlwifi 0000:04:00.0: 0x00000000 | data1
[  477.514539] iwlwifi 0000:04:00.0: 0x00000002 | data2
[  477.514541] iwlwifi 0000:04:00.0: 0x07030000 | data3
[  477.514544] iwlwifi 0000:04:00.0: 0x003CB2EF | beacon time
[  477.514546] iwlwifi 0000:04:00.0: 0x00034D0F | tsf low
[  477.514548] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
[  477.514550] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[  477.514553] iwlwifi 0000:04:00.0: 0x00034D10 | time gp2
[  477.514555] iwlwifi 0000:04:00.0: 0x00000000 | uCode revision type
[  477.514558] iwlwifi 0000:04:00.0: 0x00000015 | uCode version major
[  477.514560] iwlwifi 0000:04:00.0: 0x00058405 | uCode version minor
[  477.514562] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[  477.514565] iwlwifi 0000:04:00.0: 0x00C89200 | board version
[  477.514567] iwlwifi 0000:04:00.0: 0x0902006A | hcmd
[  477.514569] iwlwifi 0000:04:00.0: 0x02023080 | isr0
[  477.514572] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[  477.514574] iwlwifi 0000:04:00.0: 0x00000002 | isr2
[  477.514576] iwlwifi 0000:04:00.0: 0x404000C0 | isr3
[  477.514579] iwlwifi 0000:04:00.0: 0x00000080 | isr4
[  477.514581] iwlwifi 0000:04:00.0: 0x01800112 | last cmd Id
[  477.514583] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[  477.514586] iwlwifi 0000:04:00.0: 0x0000E226 | l2p_control
[  477.514588] iwlwifi 0000:04:00.0: 0x00000000 | l2p_duration
[  477.514590] iwlwifi 0000:04:00.0: 0x00000000 | l2p_mhvalid
[  477.514593] iwlwifi 0000:04:00.0: 0x00000000 | l2p_addr_match
[  477.514595] iwlwifi 0000:04:00.0: 0x00000007 | lmpm_pmg_sel
[  477.514598] iwlwifi 0000:04:00.0: 0x09071913 | timestamp
[  477.514600] iwlwifi 0000:04:00.0: 0x00340010 | flow_handler
[  477.514631] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
[  488.062248] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  488.062811] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  488.287024] iwlwifi 0000:04:00.0: Microcode SW error detected.
Restarting 0x2000000.
[  488.287037] iwlwifi 0000:04:00.0: CSR values:
[  488.287043] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is
CSR_INT_PERIODIC_REG)
[  488.287150] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c89=
200
[  488.287310] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000=
040
[  488.287368] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000=
000
[  488.287432] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000=
000
[  488.287586] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000=
000
[  488.287641] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000=
000
[  488.287696] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000=
000
[  488.287751] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X08040=
3c5
[  488.287807] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000=
210
[  488.287862] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd5555=
5d5
[  488.287917] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000=
000
[  488.287973] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd5555=
5d5
[  488.288028] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080=
042
[  488.288093] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000=
000
[  488.288242] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000=
000
[  488.288294] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000=
000
[  488.288345] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000=
000
[  488.288396] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000=
018
[  488.288447] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X88128=
8b0
[  488.288498] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800=
200
[  488.288549] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd5555=
5d5
[  488.288601] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xd3b7f=
757
[  488.288652] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X00010=
01a
[  488.288703] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0=
000
[  488.288704] iwlwifi 0000:04:00.0: FH register values:
[  488.288765] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0b357d00
[  488.288791] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00b2de60
[  488.288948] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_WPTR: 0X00000000
[  488.289013] iwlwifi 0000:04:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[  488.289078] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  488.289144] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[  488.289209] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  488.289274] iwlwifi 0000:04:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  488.289339] iwlwifi 0000:04:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[  488.289505] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[  488.289509] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[  488.289513] iwlwifi 0000:04:00.0: Loaded firmware version: 21.361477.0=

[  488.289517] iwlwifi 0000:04:00.0: 0x00000034 | NMI_INTERRUPT_WDG

[  488.289520] iwlwifi 0000:04:00.0: 0x000002F0 | trm_hw_status0
[  488.289523] iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status1
[  488.289527] iwlwifi 0000:04:00.0: 0x000401CE | branchlink2
[  488.289530] iwlwifi 0000:04:00.0: 0x0004446C | interruptlink1
[  488.289533] iwlwifi 0000:04:00.0: 0x0000B0BA | interruptlink2
[  488.289537] iwlwifi 0000:04:00.0: 0x00000000 | data1
[  488.289540] iwlwifi 0000:04:00.0: 0x00000002 | data2
[  488.289543] iwlwifi 0000:04:00.0: 0x07030000 | data3
[  488.289546] iwlwifi 0000:04:00.0: 0x003CB1AA | beacon time
[  488.289550] iwlwifi 0000:04:00.0: 0x00034E54 | tsf low
[  488.289553] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
[  488.289556] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[  488.289559] iwlwifi 0000:04:00.0: 0x00034E55 | time gp2
[  488.289562] iwlwifi 0000:04:00.0: 0x00000000 | uCode revision type
[  488.289566] iwlwifi 0000:04:00.0: 0x00000015 | uCode version major
[  488.289569] iwlwifi 0000:04:00.0: 0x00058405 | uCode version minor
[  488.289572] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[  488.289576] iwlwifi 0000:04:00.0: 0x00C89200 | board version
[  488.289579] iwlwifi 0000:04:00.0: 0x0902006A | hcmd
[  488.289582] iwlwifi 0000:04:00.0: 0x02023080 | isr0
[  488.289585] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[  488.289589] iwlwifi 0000:04:00.0: 0x00000002 | isr2
[  488.289592] iwlwifi 0000:04:00.0: 0x404000C0 | isr3
[  488.289595] iwlwifi 0000:04:00.0: 0x00000080 | isr4
[  488.289598] iwlwifi 0000:04:00.0: 0x01800112 | last cmd Id
[  488.289601] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[  488.289605] iwlwifi 0000:04:00.0: 0x0000E226 | l2p_control
[  488.289608] iwlwifi 0000:04:00.0: 0x00000000 | l2p_duration
[  488.289611] iwlwifi 0000:04:00.0: 0x00000000 | l2p_mhvalid
[  488.289614] iwlwifi 0000:04:00.0: 0x00000000 | l2p_addr_match
[  488.289618] iwlwifi 0000:04:00.0: 0x00000007 | lmpm_pmg_sel
[  488.289621] iwlwifi 0000:04:00.0: 0x09071913 | timestamp
[  488.289624] iwlwifi 0000:04:00.0: 0x00340010 | flow_handler
[  488.289652] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
[  488.297263] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  488.297720] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  488.521867] iwlwifi 0000:04:00.0: Microcode SW error detected.
Restarting 0x2000000.
[  488.521876] iwlwifi 0000:04:00.0: CSR values:
[  488.521880] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is
CSR_INT_PERIODIC_REG)
[  488.521990] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c89=
200
[  488.522047] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000=
040
[  488.522102] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000=
000
[  488.522212] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000=
000
[  488.522361] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000=
000
[  488.522416] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000=
000
[  488.522471] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000=
000
[  488.522527] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X08040=
3c5
[  488.522582] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000=
210
[  488.522637] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd5555=
5d5
[  488.522692] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000=
000
[  488.522747] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd5555=
5d5
[  488.522802] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080=
042
[  488.522857] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000=
000
[  488.522912] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000=
000
[  488.522968] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000=
000
[  488.523028] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000=
000
[  488.523187] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000=
018
[  488.523247] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X88128=
8b0
[  488.523416] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800=
200
[  488.523566] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd5555=
5d5
[  488.523623] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xd3b7f=
757
[  488.523680] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X00010=
01a
[  488.523738] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0=
000
[  488.523742] iwlwifi 0000:04:00.0: FH register values:
[  488.523907] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0b357d00
[  488.523973] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00b2de60
[  488.524033] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_WPTR: 0X00000000
[  488.524094] iwlwifi 0000:04:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[  488.524155] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  488.524272] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[  488.524333] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  488.524556] iwlwifi 0000:04:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  488.524616] iwlwifi 0000:04:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[  488.524778] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[  488.524781] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[  488.524783] iwlwifi 0000:04:00.0: Loaded firmware version: 21.361477.0=

[  488.524786] iwlwifi 0000:04:00.0: 0x00000034 | NMI_INTERRUPT_WDG

[  488.524789] iwlwifi 0000:04:00.0: 0x000002F0 | trm_hw_status0
[  488.524791] iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status1
[  488.524793] iwlwifi 0000:04:00.0: 0x000401CE | branchlink2
[  488.524795] iwlwifi 0000:04:00.0: 0x0004446C | interruptlink1
[  488.524797] iwlwifi 0000:04:00.0: 0x00005C9E | interruptlink2
[  488.524799] iwlwifi 0000:04:00.0: 0x00000000 | data1
[  488.524801] iwlwifi 0000:04:00.0: 0x00000002 | data2
[  488.524803] iwlwifi 0000:04:00.0: 0x07030000 | data3
[  488.524806] iwlwifi 0000:04:00.0: 0x003CB231 | beacon time
[  488.524808] iwlwifi 0000:04:00.0: 0x00034DCD | tsf low
[  488.524810] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
[  488.524812] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[  488.524814] iwlwifi 0000:04:00.0: 0x00034DCE | time gp2
[  488.524816] iwlwifi 0000:04:00.0: 0x00000000 | uCode revision type
[  488.524818] iwlwifi 0000:04:00.0: 0x00000015 | uCode version major
[  488.524820] iwlwifi 0000:04:00.0: 0x00058405 | uCode version minor
[  488.524823] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[  488.524825] iwlwifi 0000:04:00.0: 0x00C89200 | board version
[  488.524827] iwlwifi 0000:04:00.0: 0x0902006A | hcmd
[  488.524829] iwlwifi 0000:04:00.0: 0x02023080 | isr0
[  488.524831] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[  488.524833] iwlwifi 0000:04:00.0: 0x00000002 | isr2
[  488.524835] iwlwifi 0000:04:00.0: 0x404000C0 | isr3
[  488.524837] iwlwifi 0000:04:00.0: 0x00000080 | isr4
[  488.524839] iwlwifi 0000:04:00.0: 0x01800112 | last cmd Id
[  488.524842] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[  488.524844] iwlwifi 0000:04:00.0: 0x0000E226 | l2p_control
[  488.524846] iwlwifi 0000:04:00.0: 0x00000000 | l2p_duration
[  488.524848] iwlwifi 0000:04:00.0: 0x00000000 | l2p_mhvalid
[  488.524850] iwlwifi 0000:04:00.0: 0x00000000 | l2p_addr_match
[  488.524852] iwlwifi 0000:04:00.0: 0x00000007 | lmpm_pmg_sel
[  488.524854] iwlwifi 0000:04:00.0: 0x09071913 | timestamp
[  488.524856] iwlwifi 0000:04:00.0: 0x00340010 | flow_handler
[  488.524873] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
[  499.069575] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  499.070135] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  499.294218] iwlwifi 0000:04:00.0: Microcode SW error detected.
Restarting 0x2000000.
[  499.294222] iwlwifi 0000:04:00.0: CSR values:
[  499.294223] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is
CSR_INT_PERIODIC_REG)
[  499.294355] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c89=
200
[  499.294409] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000=
040
[  499.294460] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000=
000
[  499.294511] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000=
000
[  499.294562] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000=
000
[  499.294613] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000=
000
[  499.294664] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000=
000
[  499.294715] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X08040=
3c5
[  499.294767] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000=
210
[  499.294818] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd5555=
5d5
[  499.294869] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000=
000
[  499.294920] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd5555=
5d5
[  499.294971] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080=
042
[  499.295022] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000=
000
[  499.295073] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000=
000
[  499.295124] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000=
000
[  499.295175] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000=
000
[  499.295227] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000=
018
[  499.295278] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X88128=
8b0
[  499.295329] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800=
200
[  499.295380] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd5555=
5d5
[  499.295431] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xd3b7f=
777
[  499.295482] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X00010=
01a
[  499.295533] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0=
000
[  499.295535] iwlwifi 0000:04:00.0: FH register values:
[  499.295596] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0b357d00
[  499.295608] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00b2de60
[  499.295619] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_WPTR: 0X00000000
[  499.295632] iwlwifi 0000:04:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[  499.295643] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  499.295655] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[  499.295667] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  499.295678] iwlwifi 0000:04:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  499.295690] iwlwifi 0000:04:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[  499.295799] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[  499.295801] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[  499.295803] iwlwifi 0000:04:00.0: Loaded firmware version: 21.361477.0=

[  499.295804] iwlwifi 0000:04:00.0: 0x00000034 | NMI_INTERRUPT_WDG

[  499.295806] iwlwifi 0000:04:00.0: 0x000002F0 | trm_hw_status0
[  499.295807] iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status1
[  499.295808] iwlwifi 0000:04:00.0: 0x000401CE | branchlink2
[  499.295810] iwlwifi 0000:04:00.0: 0x0004446C | interruptlink1
[  499.295811] iwlwifi 0000:04:00.0: 0x00005C94 | interruptlink2
[  499.295812] iwlwifi 0000:04:00.0: 0x00000000 | data1
[  499.295813] iwlwifi 0000:04:00.0: 0x00000002 | data2
[  499.295815] iwlwifi 0000:04:00.0: 0x07030000 | data3
[  499.295816] iwlwifi 0000:04:00.0: 0x003CB25F | beacon time
[  499.295817] iwlwifi 0000:04:00.0: 0x00034D9F | tsf low
[  499.295819] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
[  499.295820] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[  499.295821] iwlwifi 0000:04:00.0: 0x00034DA0 | time gp2
[  499.295823] iwlwifi 0000:04:00.0: 0x00000000 | uCode revision type
[  499.295824] iwlwifi 0000:04:00.0: 0x00000015 | uCode version major
[  499.295825] iwlwifi 0000:04:00.0: 0x00058405 | uCode version minor
[  499.295826] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[  499.295828] iwlwifi 0000:04:00.0: 0x00C89200 | board version
[  499.295829] iwlwifi 0000:04:00.0: 0x0902006A | hcmd
[  499.295830] iwlwifi 0000:04:00.0: 0x02023080 | isr0
[  499.295832] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[  499.295833] iwlwifi 0000:04:00.0: 0x00000002 | isr2
[  499.295834] iwlwifi 0000:04:00.0: 0x404000C0 | isr3
[  499.295835] iwlwifi 0000:04:00.0: 0x00000080 | isr4
[  499.295837] iwlwifi 0000:04:00.0: 0x01800112 | last cmd Id
[  499.295838] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[  499.295839] iwlwifi 0000:04:00.0: 0x0000E226 | l2p_control
[  499.295841] iwlwifi 0000:04:00.0: 0x00000000 | l2p_duration
[  499.295842] iwlwifi 0000:04:00.0: 0x00000000 | l2p_mhvalid
[  499.295843] iwlwifi 0000:04:00.0: 0x00000000 | l2p_addr_match
[  499.295844] iwlwifi 0000:04:00.0: 0x00000007 | lmpm_pmg_sel
[  499.295846] iwlwifi 0000:04:00.0: 0x09071913 | timestamp
[  499.295847] iwlwifi 0000:04:00.0: 0x00340010 | flow_handler
[  499.295861] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
[  499.302867] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  499.303325] iwlwifi 0000:04:00.0: L1 Enabled - LTR Enabled
[  499.527947] iwlwifi 0000:04:00.0: Microcode SW error detected.
Restarting 0x2000000.
[  499.527955] iwlwifi 0000:04:00.0: CSR values:
[  499.527959] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is
CSR_INT_PERIODIC_REG)
[  499.528068] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c89=
200
[  499.528125] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000=
040
[  499.528181] iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000=
000
[  499.528236] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000=
000
[  499.528291] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000=
000
[  499.528346] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000=
000
[  499.528401] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000=
000
[  499.528456] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X08040=
3c5
[  499.528511] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000=
210
[  499.528566] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0Xd5555=
5d5
[  499.528621] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X00000=
000
[  499.528676] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0Xd5555=
5d5
[  499.528732] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080=
042
[  499.528787] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000=
000
[  499.528842] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000=
000
[  499.528897] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000=
000
[  499.528952] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000=
000
[  499.529007] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000=
018
[  499.529062] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X88128=
8b0
[  499.529118] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800=
200
[  499.529173] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0Xd5555=
5d5
[  499.529228] iwlwifi 0000:04:00.0:      CSR_MONITOR_STATUS_REG: 0Xd3b7f=
ff7
[  499.529283] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X00010=
01a
[  499.529338] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0=
000
[  499.529341] iwlwifi 0000:04:00.0: FH register values:
[  499.529566] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0b357d00
[  499.529735] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00b2de60
[  499.529904] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_WPTR: 0X00000000
[  499.529971] iwlwifi 0000:04:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
[  499.530040] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  499.530107] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[  499.530177] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  499.530346] iwlwifi 0000:04:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  499.530674] iwlwifi 0000:04:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[  499.530843] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[  499.530848] iwlwifi 0000:04:00.0: Status: 0x00000000, count: 6
[  499.530854] iwlwifi 0000:04:00.0: Loaded firmware version: 21.361477.0=

[  499.530860] iwlwifi 0000:04:00.0: 0x00000034 | NMI_INTERRUPT_WDG

[  499.530865] iwlwifi 0000:04:00.0: 0x000002F0 | trm_hw_status0
[  499.530870] iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status1
[  499.530875] iwlwifi 0000:04:00.0: 0x000401CE | branchlink2
[  499.530881] iwlwifi 0000:04:00.0: 0x0004446C | interruptlink1
[  499.530885] iwlwifi 0000:04:00.0: 0x0000B0B8 | interruptlink2
[  499.530890] iwlwifi 0000:04:00.0: 0x00000000 | data1
[  499.530894] iwlwifi 0000:04:00.0: 0x00000002 | data2
[  499.530900] iwlwifi 0000:04:00.0: 0x07030000 | data3
[  499.530905] iwlwifi 0000:04:00.0: 0x003CB06F | beacon time
[  499.530911] iwlwifi 0000:04:00.0: 0x00034F8F | tsf low
[  499.530916] iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
[  499.530920] iwlwifi 0000:04:00.0: 0x00000000 | time gp1
[  499.530926] iwlwifi 0000:04:00.0: 0x00034F90 | time gp2
[  499.530931] iwlwifi 0000:04:00.0: 0x00000000 | uCode revision type
[  499.530936] iwlwifi 0000:04:00.0: 0x00000015 | uCode version major
[  499.530941] iwlwifi 0000:04:00.0: 0x00058405 | uCode version minor
[  499.530946] iwlwifi 0000:04:00.0: 0x00000210 | hw version
[  499.530951] iwlwifi 0000:04:00.0: 0x00C89200 | board version
[  499.530955] iwlwifi 0000:04:00.0: 0x0902006A | hcmd
[  499.530960] iwlwifi 0000:04:00.0: 0x02023080 | isr0
[  499.530965] iwlwifi 0000:04:00.0: 0x00000000 | isr1
[  499.530970] iwlwifi 0000:04:00.0: 0x00000002 | isr2
[  499.530975] iwlwifi 0000:04:00.0: 0x404000C0 | isr3
[  499.530980] iwlwifi 0000:04:00.0: 0x00000080 | isr4
[  499.530984] iwlwifi 0000:04:00.0: 0x01800112 | last cmd Id
[  499.530989] iwlwifi 0000:04:00.0: 0x00000000 | wait_event
[  499.530992] iwlwifi 0000:04:00.0: 0x0000E226 | l2p_control
[  499.530999] iwlwifi 0000:04:00.0: 0x00000000 | l2p_duration
[  499.531001] iwlwifi 0000:04:00.0: 0x00000000 | l2p_mhvalid
[  499.531004] iwlwifi 0000:04:00.0: 0x00000000 | l2p_addr_match
[  499.531007] iwlwifi 0000:04:00.0: 0x00000007 | lmpm_pmg_sel
[  499.531010] iwlwifi 0000:04:00.0: 0x09071913 | timestamp
[  499.531013] iwlwifi 0000:04:00.0: 0x00340010 | flow_handler
[  499.531063] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5


--jUIa0DUc0Em6xgCr4Hr3CixIKScwua0eB--

--JjmT0pQc4XrNF80mv7uVLnGx4K9olFgxB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEbBAEBCAAGBQJXgi+OAAoJEIOFK7hVFsHHm80H9356/8ga9TzCHh4ZFEGFjWhb
gfIf6gAPLMMggcm8D1qpZnjZSaXh2nPjOfEhEsTmn2grbThSaiaqj4VqfA9yBldb
LyiYrBq2tLRwaNKl7ODGT78UJPpSZboi7Xg8WTJTZq6CIacIh5K7oIQFRslOSxq7
JaXpNKgFESBFwCoD0Rd3UbYN7SObU23Sxwtmiy6vi4fwkwK6k5Pc+wXHy9A8e8Qw
SYlw7zKFFgS2WCzMClfUCLFpS5tdUZoOAL2I6+a8kZBa1N2WdnLyszXsB3nF6u2Z
ty7S6brQFbzMNNm8Vd9PmMUFG9QoaCQNMtPRUWt5kMqcQanRLeRn+bTfR0uLKA==
=VYkm
-----END PGP SIGNATURE-----

--JjmT0pQc4XrNF80mv7uVLnGx4K9olFgxB--

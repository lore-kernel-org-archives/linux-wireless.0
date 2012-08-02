Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:56866 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab2HBO52 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 10:57:28 -0400
Date: Thu, 2 Aug 2012 16:54:29 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Ch. Hanisch" <ch-hanisch@t-online.de>,
	linux-wireless@vger.kernel.org
Subject: Re: No WLAN on DELL XPS L702x with Ubuntu 12.04LTS (64Bit)
Message-ID: <20120802165429.29839020@dualc.maya.org> (sfid-20120802_165742_726106_9E82C7E4)
In-Reply-To: <CANUX_P10yfdy+d9txsp1RV9niKex_5WAr0VFsjsMiPosv6M+mA@mail.gmail.com>
References: <5016F03F.1020508@t-online.de> <5016F59E.9070101@01019freenet.de> <CANUX_P2CZW5ji--KkXoyBZUuZfOqkPk_A8Ui9tw4rNeuY=mebQ@mail.gmail.com> <5019EC7D.5030208@01019freenet.de> <CANUX_P10yfdy+d9txsp1RV9niKex_5WAr0VFsjsMiPosv6M+mA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach wrote:
>>
>> He wrote, too, that the installation of compat-wireless
>> (unfortunately, he didn't told me which version), didn't changed the
>> situation.
>>
>> I attached for him the output of
>> options iwlwifi debug=0xffffffff
>>
>> The last part of it:
> 
> what about the logs *before* that?

What are you missing? The attachment contains of 1739 lines. It seems to
be the complete output from dmesg from 0 to 675 seconds!

Please take a look for the complete output here:
http://article.gmane.org/gmane.linux.kernel.wireless.general/95671

This is a reduced output with lines containing iwlwifi:

[   31.283053] iwlwifi 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   31.283063] iwlwifi 0000:03:00.0: setting latency timer to 64
[   31.283088] iwlwifi 0000:03:00.0: pci_resource_len = 0x00002000
[   31.283090] iwlwifi 0000:03:00.0: pci_resource_base = ffffc900050a0000
[   31.283092] iwlwifi 0000:03:00.0: HW Revision ID = 0x0
[   31.283177] iwlwifi 0000:03:00.0: irq 55 for MSI/MSI-X
[   31.283215] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Wireless-N 1000 BGN, REV=0x6C
[   31.283264] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   31.304161] iwlwifi 0000:03:00.0: device EEPROM VER=0x15d, CALIB=0x6
[   31.304164] iwlwifi 0000:03:00.0: Device SKU: 0X50
[   31.304166] iwlwifi 0000:03:00.0: Valid Tx ant: 0X1, Valid Rx ant: 0X3
[   31.304189] iwlwifi 0000:03:00.0: Tunable channels: 13 802.11bg, 0 802.11a channels
[   31.358015] iwlwifi 0000:03:00.0: loaded firmware version 39.31.5.1 build 35138
[   36.162014] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   36.179146] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[   36.179150] iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
[   36.179235] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[   36.179236] iwlwifi 0000:03:00.0: Status: 0x00040224, count: 5
[   36.179238] iwlwifi 0000:03:00.0: 0x00000005 | SYSASSERT                   
[   36.179239] iwlwifi 0000:03:00.0: 0x00016E00 | uPc
[   36.179240] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink1
[   36.179241] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink2
[   36.179243] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[   36.179244] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[   36.179245] iwlwifi 0000:03:00.0: 0x00000000 | data1
[   36.179246] iwlwifi 0000:03:00.0: 0x00000000 | data2
[   36.179247] iwlwifi 0000:03:00.0: 0x00000616 | line
[   36.179248] iwlwifi 0000:03:00.0: 0x00018BC9 | beacon time
[   36.179249] iwlwifi 0000:03:00.0: 0x00000437 | tsf low
[   36.179250] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[   36.179251] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[   36.179252] iwlwifi 0000:03:00.0: 0x0000043B | time gp2
[   36.179253] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[   36.179254] iwlwifi 0000:03:00.0: 0x0001271F | uCode version
[   36.179256] iwlwifi 0000:03:00.0: 0x0000006C | hw version
[   36.179257] iwlwifi 0000:03:00.0: 0x00880300 | board version
[   36.179258] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[   36.179259] iwlwifi 0000:03:00.0: CSR values:
[   36.179260] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[   36.179265] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[   36.179270] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[   36.179275] iwlwifi 0000:03:00.0:                     CSR_INT: 0X80000000
[   36.179279] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[   36.179283] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X40010000
[   36.179288] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[   36.179292] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[   36.179297] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[   36.179302] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
[   36.179306] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xc63f3885
[   36.179311] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[   36.179315] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00210801
[   36.179320] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[   36.179324] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[   36.179329] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[   36.179334] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[   36.179339] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[   36.179344] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[   36.179348] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[   36.179352] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[   36.179356] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00880300
[   36.179360] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[   36.179365] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[   36.179367] iwlwifi 0000:03:00.0: FH register values:
[   36.179380] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1336ff00
[   36.179394] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01336fe0
[   36.179409] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
[   36.179424] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[   36.179437] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[   36.179452] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[   36.179467] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[   36.179480] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[   36.179495] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[   36.179552] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 5 entries
[   36.179572] iwlwifi 0000:03:00.0: EVT_LOGT:0000000000:0x0000028c:0117
[   36.179583] iwlwifi 0000:03:00.0: EVT_LOGT:0000000021:0x00000000:1208
[   36.179595] iwlwifi 0000:03:00.0: EVT_LOGT:0000001004:0x00000001:0071
[   36.179605] iwlwifi 0000:03:00.0: EVT_LOGT:0000001080:0x00000002:0071
[   36.179617] iwlwifi 0000:03:00.0: EVT_LOGT:0000001086:0x00000000:0125
[   36.179932] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[   36.180011] iwlwifi 0000:03:00.0: Unable to initialize device.
[   36.324239] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   36.339543] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[   36.339548] iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
[   36.339627] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[   36.339630] iwlwifi 0000:03:00.0: Status: 0x00040224, count: 5
[   36.339632] iwlwifi 0000:03:00.0: 0x00000005 | SYSASSERT                   
[   36.339634] iwlwifi 0000:03:00.0: 0x00016E00 | uPc
[   36.339636] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink1
[   36.339638] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink2
[   36.339639] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[   36.339641] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[   36.339643] iwlwifi 0000:03:00.0: 0x00000000 | data1
[   36.339644] iwlwifi 0000:03:00.0: 0x00000000 | data2
[   36.339646] iwlwifi 0000:03:00.0: 0x00000616 | line
[   36.339647] iwlwifi 0000:03:00.0: 0x00018BC8 | beacon time
[   36.339649] iwlwifi 0000:03:00.0: 0x00000438 | tsf low
[   36.339650] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[   36.339652] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[   36.339653] iwlwifi 0000:03:00.0: 0x0000043C | time gp2
[   36.339655] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[   36.339657] iwlwifi 0000:03:00.0: 0x0001271F | uCode version
[   36.339658] iwlwifi 0000:03:00.0: 0x0000006C | hw version
[   36.339660] iwlwifi 0000:03:00.0: 0x00880300 | board version
[   36.339662] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[   36.339663] iwlwifi 0000:03:00.0: CSR values:
[   36.339665] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[   36.339670] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[   36.339675] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[   36.339680] iwlwifi 0000:03:00.0:                     CSR_INT: 0X80000000
[   36.339684] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[   36.339689] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X40010000
[   36.339694] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[   36.339699] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[   36.339704] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[   36.339709] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
[   36.339714] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xc63f3885
[   36.339719] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[   36.339724] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00210801
[   36.339729] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[   36.339733] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[   36.339738] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[   36.339742] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[   36.339747] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[   36.339751] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[   36.339756] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[   36.339761] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[   36.339765] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[   36.339770] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[   36.339775] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[   36.339776] iwlwifi 0000:03:00.0: FH register values:
[   36.339790] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1336ff00
[   36.339804] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01336fe0
[   36.339818] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
[   36.339832] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[   36.339846] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[   36.339860] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[   36.339874] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[   36.339888] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[   36.339901] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[   36.339956] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 5 entries
[   36.339976] iwlwifi 0000:03:00.0: EVT_LOGT:0000000000:0x0000028c:0117
[   36.339987] iwlwifi 0000:03:00.0: EVT_LOGT:0000000021:0x00000000:1208
[   36.339998] iwlwifi 0000:03:00.0: EVT_LOGT:0000001005:0x00000001:0071
[   36.340009] iwlwifi 0000:03:00.0: EVT_LOGT:0000001081:0x00000002:0071
[   36.340020] iwlwifi 0000:03:00.0: EVT_LOGT:0000001087:0x00000000:0125
[   36.340618] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[   36.340698] iwlwifi 0000:03:00.0: Unable to initialize device.
[   36.340940] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   36.356366] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[   36.356369] iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
[   36.356457] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[   36.356458] iwlwifi 0000:03:00.0: Status: 0x00040224, count: 5
[   36.356460] iwlwifi 0000:03:00.0: 0x00000005 | SYSASSERT                   
[   36.356461] iwlwifi 0000:03:00.0: 0x00016E00 | uPc
[   36.356462] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink1
[   36.356463] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink2
[   36.356464] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[   36.356465] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[   36.356466] iwlwifi 0000:03:00.0: 0x00000000 | data1
[   36.356467] iwlwifi 0000:03:00.0: 0x00000000 | data2
[   36.356468] iwlwifi 0000:03:00.0: 0x00000616 | line
[   36.356469] iwlwifi 0000:03:00.0: 0x00018BCA | beacon time
[   36.356470] iwlwifi 0000:03:00.0: 0x00000436 | tsf low
[   36.356471] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[   36.356472] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[   36.356473] iwlwifi 0000:03:00.0: 0x0000043A | time gp2
[   36.356474] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[   36.356475] iwlwifi 0000:03:00.0: 0x0001271F | uCode version
[   36.356476] iwlwifi 0000:03:00.0: 0x0000006C | hw version
[   36.356477] iwlwifi 0000:03:00.0: 0x00880300 | board version
[   36.356478] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[   36.356479] iwlwifi 0000:03:00.0: CSR values:
[   36.356480] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[   36.356485] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[   36.356490] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[   36.356494] iwlwifi 0000:03:00.0:                     CSR_INT: 0X80000000
[   36.356499] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[   36.356503] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X40010000
[   36.356507] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[   36.356512] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[   36.356516] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[   36.356520] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
[   36.356524] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xc63f3885
[   36.356529] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[   36.356534] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00210801
[   36.356537] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[   36.356542] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[   36.356546] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[   36.356550] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[   36.356555] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[   36.356559] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[   36.356563] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[   36.356567] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[   36.356572] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[   36.356576] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[   36.356580] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[   36.356581] iwlwifi 0000:03:00.0: FH register values:
[   36.356596] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1336ff00
[   36.356610] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01336fe0
[   36.356623] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
[   36.356637] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[   36.356650] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[   36.356665] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[   36.356678] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[   36.356691] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[   36.356705] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[   36.356761] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 5 entries
[   36.356780] iwlwifi 0000:03:00.0: EVT_LOGT:0000000000:0x0000028c:0117
[   36.356790] iwlwifi 0000:03:00.0: EVT_LOGT:0000000021:0x00000000:1208
[   36.356801] iwlwifi 0000:03:00.0: EVT_LOGT:0000001003:0x00000001:0071
[   36.356812] iwlwifi 0000:03:00.0: EVT_LOGT:0000001079:0x00000002:0071
[   36.356825] iwlwifi 0000:03:00.0: EVT_LOGT:0000001085:0x00000000:0125
[   36.357138] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[   36.357200] iwlwifi 0000:03:00.0: Unable to initialize device.
[   51.388051] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   51.407506] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[   51.407511] iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
[   51.407615] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[   51.407618] iwlwifi 0000:03:00.0: Status: 0x00040224, count: 5
[   51.407621] iwlwifi 0000:03:00.0: 0x00000005 | SYSASSERT                   
[   51.407625] iwlwifi 0000:03:00.0: 0x00016E00 | uPc
[   51.407628] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink1
[   51.407631] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink2
[   51.407633] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[   51.407637] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[   51.407640] iwlwifi 0000:03:00.0: 0x00000000 | data1
[   51.407642] iwlwifi 0000:03:00.0: 0x00000000 | data2
[   51.407645] iwlwifi 0000:03:00.0: 0x00000616 | line
[   51.407648] iwlwifi 0000:03:00.0: 0x00018BC8 | beacon time
[   51.407651] iwlwifi 0000:03:00.0: 0x00000438 | tsf low
[   51.407654] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[   51.407656] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[   51.407659] iwlwifi 0000:03:00.0: 0x0000043C | time gp2
[   51.407662] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[   51.407665] iwlwifi 0000:03:00.0: 0x0001271F | uCode version
[   51.407668] iwlwifi 0000:03:00.0: 0x0000006C | hw version
[   51.407671] iwlwifi 0000:03:00.0: 0x00880300 | board version
[   51.407674] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[   51.407677] iwlwifi 0000:03:00.0: CSR values:
[   51.407680] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[   51.407686] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[   51.407693] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[   51.407700] iwlwifi 0000:03:00.0:                     CSR_INT: 0X80000000
[   51.407706] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[   51.407714] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X40010000
[   51.407720] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[   51.407727] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[   51.407734] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[   51.407741] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
[   51.407748] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xc63f3885
[   51.407755] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[   51.407762] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00210801
[   51.407768] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[   51.407774] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[   51.407781] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[   51.407788] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[   51.407795] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[   51.407802] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[   51.407809] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[   51.407814] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[   51.407820] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[   51.407824] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[   51.407833] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[   51.407835] iwlwifi 0000:03:00.0: FH register values:
[   51.407850] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1336ff00
[   51.407867] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01336fe0
[   51.407883] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
[   51.407898] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[   51.407915] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[   51.407934] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[   51.407950] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[   51.407967] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[   51.407982] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[   51.408043] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 5 entries
[   51.408065] iwlwifi 0000:03:00.0: EVT_LOGT:0000000000:0x0000028c:0117
[   51.408078] iwlwifi 0000:03:00.0: EVT_LOGT:0000000021:0x00000000:1208
[   51.408090] iwlwifi 0000:03:00.0: EVT_LOGT:0000001005:0x00000001:0071
[   51.408103] iwlwifi 0000:03:00.0: EVT_LOGT:0000001081:0x00000002:0071
[   51.408115] iwlwifi 0000:03:00.0: EVT_LOGT:0000001087:0x00000000:0125
[   51.408785] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[   51.408869] iwlwifi 0000:03:00.0: Unable to initialize device.
[   56.235154] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   56.250787] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[   56.250799] iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
[   56.250892] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[   56.250893] iwlwifi 0000:03:00.0: Status: 0x00040224, count: 5
[   56.250895] iwlwifi 0000:03:00.0: 0x00000005 | SYSASSERT                   
[   56.250896] iwlwifi 0000:03:00.0: 0x00016E00 | uPc
[   56.250897] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink1
[   56.250898] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink2
[   56.250899] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[   56.250900] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[   56.250901] iwlwifi 0000:03:00.0: 0x00000000 | data1
[   56.250902] iwlwifi 0000:03:00.0: 0x00000000 | data2
[   56.250903] iwlwifi 0000:03:00.0: 0x00000616 | line
[   56.250904] iwlwifi 0000:03:00.0: 0x00018BC9 | beacon time
[   56.250905] iwlwifi 0000:03:00.0: 0x00000437 | tsf low
[   56.250906] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[   56.250907] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[   56.250908] iwlwifi 0000:03:00.0: 0x0000043B | time gp2
[   56.250909] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[   56.250910] iwlwifi 0000:03:00.0: 0x0001271F | uCode version
[   56.250911] iwlwifi 0000:03:00.0: 0x0000006C | hw version
[   56.250912] iwlwifi 0000:03:00.0: 0x00880300 | board version
[   56.250913] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[   56.250914] iwlwifi 0000:03:00.0: CSR values:
[   56.250915] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[   56.250920] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[   56.250923] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[   56.250928] iwlwifi 0000:03:00.0:                     CSR_INT: 0X80000000
[   56.250932] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[   56.250936] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X40010000
[   56.250940] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[   56.250944] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[   56.250949] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[   56.250953] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
[   56.250958] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xc63f3885
[   56.250963] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[   56.250967] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00210801
[   56.250971] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[   56.250975] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[   56.250979] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[   56.250982] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[   56.250986] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[   56.250991] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[   56.250994] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[   56.250998] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[   56.251002] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[   56.251006] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[   56.251010] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[   56.251012] iwlwifi 0000:03:00.0: FH register values:
[   56.251024] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1336ff00
[   56.251037] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01336fe0
[   56.251050] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
[   56.251062] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[   56.251076] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[   56.251090] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[   56.251102] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[   56.251115] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[   56.251128] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[   56.251181] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 5 entries
[   56.251200] iwlwifi 0000:03:00.0: EVT_LOGT:0000000000:0x0000028c:0117
[   56.251211] iwlwifi 0000:03:00.0: EVT_LOGT:0000000021:0x00000000:1208
[   56.251222] iwlwifi 0000:03:00.0: EVT_LOGT:0000001004:0x00000001:0071
[   56.251232] iwlwifi 0000:03:00.0: EVT_LOGT:0000001080:0x00000002:0071
[   56.251242] iwlwifi 0000:03:00.0: EVT_LOGT:0000001086:0x00000000:0125
[   56.251546] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[   56.251623] iwlwifi 0000:03:00.0: Unable to initialize device.
[   61.231571] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   61.247056] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[   61.247059] iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
[   61.247147] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[   61.247148] iwlwifi 0000:03:00.0: Status: 0x00040224, count: 5
[   61.247150] iwlwifi 0000:03:00.0: 0x00000005 | SYSASSERT                   
[   61.247151] iwlwifi 0000:03:00.0: 0x00016E00 | uPc
[   61.247152] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink1
[   61.247154] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink2
[   61.247155] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[   61.247156] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[   61.247157] iwlwifi 0000:03:00.0: 0x00000000 | data1
[   61.247158] iwlwifi 0000:03:00.0: 0x00000000 | data2
[   61.247159] iwlwifi 0000:03:00.0: 0x00000616 | line
[   61.247160] iwlwifi 0000:03:00.0: 0x00018BC8 | beacon time
[   61.247161] iwlwifi 0000:03:00.0: 0x00000438 | tsf low
[   61.247162] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[   61.247163] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[   61.247164] iwlwifi 0000:03:00.0: 0x0000043C | time gp2
[   61.247165] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[   61.247167] iwlwifi 0000:03:00.0: 0x0001271F | uCode version
[   61.247168] iwlwifi 0000:03:00.0: 0x0000006C | hw version
[   61.247169] iwlwifi 0000:03:00.0: 0x00880300 | board version
[   61.247170] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[   61.247171] iwlwifi 0000:03:00.0: CSR values:
[   61.247172] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[   61.247177] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[   61.247182] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[   61.247186] iwlwifi 0000:03:00.0:                     CSR_INT: 0X80000000
[   61.247191] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[   61.247196] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X40010000
[   61.247201] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[   61.247206] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[   61.247210] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[   61.247215] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
[   61.247220] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xc63f3885
[   61.247224] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[   61.247229] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00210801
[   61.247233] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[   61.247238] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[   61.247243] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[   61.247247] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[   61.247252] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[   61.247257] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[   61.247261] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[   61.247266] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[   61.247271] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[   61.247275] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[   61.247280] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[   61.247282] iwlwifi 0000:03:00.0: FH register values:
[   61.247296] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1336ff00
[   61.247311] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01336fe0
[   61.247325] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
[   61.247340] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[   61.247361] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[   61.247375] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[   61.247390] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[   61.247403] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[   61.247418] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[   61.247478] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 5 entries
[   61.247497] iwlwifi 0000:03:00.0: EVT_LOGT:0000000000:0x0000028c:0117
[   61.247509] iwlwifi 0000:03:00.0: EVT_LOGT:0000000021:0x00000000:1208
[   61.247520] iwlwifi 0000:03:00.0: EVT_LOGT:0000001005:0x00000001:0071
[   61.247532] iwlwifi 0000:03:00.0: EVT_LOGT:0000001081:0x00000002:0071
[   61.247552] iwlwifi 0000:03:00.0: EVT_LOGT:0000001087:0x00000000:0125
[   61.247876] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[   61.247955] iwlwifi 0000:03:00.0: Unable to initialize device.
[   66.225700] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   66.241481] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[   66.241493] iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
[   66.241600] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[   66.241601] iwlwifi 0000:03:00.0: Status: 0x00040224, count: 5
[   66.241603] iwlwifi 0000:03:00.0: 0x00000005 | SYSASSERT                   
[   66.241604] iwlwifi 0000:03:00.0: 0x00016E00 | uPc
[   66.241605] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink1
[   66.241606] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink2
[   66.241608] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[   66.241609] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[   66.241610] iwlwifi 0000:03:00.0: 0x00000000 | data1
[   66.241611] iwlwifi 0000:03:00.0: 0x00000000 | data2
[   66.241612] iwlwifi 0000:03:00.0: 0x00000616 | line
[   66.241613] iwlwifi 0000:03:00.0: 0x00018BC8 | beacon time
[   66.241614] iwlwifi 0000:03:00.0: 0x00000438 | tsf low
[   66.241615] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[   66.241616] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[   66.241617] iwlwifi 0000:03:00.0: 0x0000043C | time gp2
[   66.241618] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[   66.241619] iwlwifi 0000:03:00.0: 0x0001271F | uCode version
[   66.241621] iwlwifi 0000:03:00.0: 0x0000006C | hw version
[   66.241622] iwlwifi 0000:03:00.0: 0x00880300 | board version
[   66.241623] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[   66.241624] iwlwifi 0000:03:00.0: CSR values:
[   66.241625] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[   66.241631] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[   66.241636] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[   66.241640] iwlwifi 0000:03:00.0:                     CSR_INT: 0X80000000
[   66.241645] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[   66.241650] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X40010000
[   66.241655] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[   66.241660] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[   66.241665] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[   66.241670] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
[   66.241675] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xc63f3885
[   66.241680] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[   66.241685] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00210801
[   66.241690] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[   66.241695] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[   66.241700] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[   66.241704] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[   66.241709] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[   66.241714] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[   66.241719] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[   66.241724] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[   66.241729] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[   66.241734] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[   66.241739] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[   66.241740] iwlwifi 0000:03:00.0: FH register values:
[   66.241756] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1336ff00
[   66.241771] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01336fe0
[   66.241786] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
[   66.241801] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[   66.241817] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[   66.241832] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[   66.241848] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[   66.241863] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[   66.241878] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[   66.241941] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 5 entries
[   66.241961] iwlwifi 0000:03:00.0: EVT_LOGT:0000000000:0x0000028c:0117
[   66.241973] iwlwifi 0000:03:00.0: EVT_LOGT:0000000021:0x00000000:1208
[   66.241985] iwlwifi 0000:03:00.0: EVT_LOGT:0000001005:0x00000001:0071
[   66.241998] iwlwifi 0000:03:00.0: EVT_LOGT:0000001081:0x00000002:0071
[   66.242010] iwlwifi 0000:03:00.0: EVT_LOGT:0000001087:0x00000000:0125
[   66.242345] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[   66.242434] iwlwifi 0000:03:00.0: Unable to initialize device.
[   71.219216] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   71.234827] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[   71.234838] iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
[   71.234945] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[   71.234946] iwlwifi 0000:03:00.0: Status: 0x00040224, count: 5
[   71.234948] iwlwifi 0000:03:00.0: 0x00000005 | SYSASSERT                   
[   71.234949] iwlwifi 0000:03:00.0: 0x00016E00 | uPc
[   71.234950] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink1
[   71.234951] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink2
[   71.234952] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[   71.234953] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[   71.234954] iwlwifi 0000:03:00.0: 0x00000000 | data1
[   71.234955] iwlwifi 0000:03:00.0: 0x00000000 | data2
[   71.234956] iwlwifi 0000:03:00.0: 0x00000616 | line
[   71.234957] iwlwifi 0000:03:00.0: 0x00018BCA | beacon time
[   71.234958] iwlwifi 0000:03:00.0: 0x00000436 | tsf low
[   71.234959] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[   71.234960] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[   71.234961] iwlwifi 0000:03:00.0: 0x0000043A | time gp2
[   71.234962] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[   71.234963] iwlwifi 0000:03:00.0: 0x0001271F | uCode version
[   71.234964] iwlwifi 0000:03:00.0: 0x0000006C | hw version
[   71.234965] iwlwifi 0000:03:00.0: 0x00880300 | board version
[   71.234966] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[   71.234967] iwlwifi 0000:03:00.0: CSR values:
[   71.234968] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[   71.234973] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[   71.234978] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[   71.234983] iwlwifi 0000:03:00.0:                     CSR_INT: 0X80000000
[   71.234988] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[   71.234993] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X40010000
[   71.234998] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[   71.235003] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[   71.235008] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[   71.235012] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
[   71.235017] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xc63f3885
[   71.235022] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[   71.235027] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00210801
[   71.235032] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[   71.235037] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[   71.235042] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[   71.235046] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[   71.235051] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[   71.235056] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[   71.235061] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[   71.235066] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[   71.235071] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[   71.235076] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[   71.235080] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[   71.235082] iwlwifi 0000:03:00.0: FH register values:
[   71.235097] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1336ff00
[   71.235112] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01336fe0
[   71.235127] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
[   71.235142] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[   71.235158] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[   71.235173] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[   71.235188] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[   71.235204] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[   71.235219] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[   71.235281] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 5 entries
[   71.235301] iwlwifi 0000:03:00.0: EVT_LOGT:0000000000:0x0000028c:0117
[   71.235313] iwlwifi 0000:03:00.0: EVT_LOGT:0000000021:0x00000000:1208
[   71.235325] iwlwifi 0000:03:00.0: EVT_LOGT:0000001003:0x00000001:0071
[   71.235337] iwlwifi 0000:03:00.0: EVT_LOGT:0000001079:0x00000002:0071
[   71.235349] iwlwifi 0000:03:00.0: EVT_LOGT:0000001085:0x00000000:0125
[   71.235687] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[   71.235751] iwlwifi 0000:03:00.0: Unable to initialize device.
[  271.021326] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[  271.037759] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[  271.037772] iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
[  271.037872] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[  271.037878] iwlwifi 0000:03:00.0: Status: 0x00040224, count: 5
[  271.037883] iwlwifi 0000:03:00.0: 0x00000005 | SYSASSERT                   
[  271.037888] iwlwifi 0000:03:00.0: 0x00016E00 | uPc
[  271.037893] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink1
[  271.037897] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink2
[  271.037901] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[  271.037905] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[  271.037909] iwlwifi 0000:03:00.0: 0x00000000 | data1
[  271.037913] iwlwifi 0000:03:00.0: 0x00000000 | data2
[  271.037917] iwlwifi 0000:03:00.0: 0x00000616 | line
[  271.037921] iwlwifi 0000:03:00.0: 0x00018BC8 | beacon time
[  271.037925] iwlwifi 0000:03:00.0: 0x00000438 | tsf low
[  271.037929] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[  271.037933] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[  271.037937] iwlwifi 0000:03:00.0: 0x0000043C | time gp2
[  271.037941] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[  271.037946] iwlwifi 0000:03:00.0: 0x0001271F | uCode version
[  271.037950] iwlwifi 0000:03:00.0: 0x0000006C | hw version
[  271.037954] iwlwifi 0000:03:00.0: 0x00880300 | board version
[  271.037958] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[  271.037962] iwlwifi 0000:03:00.0: CSR values:
[  271.037966] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[  271.037976] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[  271.037985] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[  271.037994] iwlwifi 0000:03:00.0:                     CSR_INT: 0X80000000
[  271.038003] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[  271.038013] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X40010000
[  271.038021] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[  271.038030] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[  271.038039] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[  271.038048] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
[  271.038056] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xc63f3885
[  271.038065] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[  271.038074] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00210801
[  271.038082] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[  271.038091] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[  271.038100] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[  271.038108] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[  271.038117] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[  271.038126] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[  271.038134] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[  271.038142] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[  271.038151] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[  271.038160] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[  271.038168] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[  271.038173] iwlwifi 0000:03:00.0: FH register values:
[  271.038193] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1336ff00
[  271.038213] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01336fe0
[  271.038233] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
[  271.038253] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[  271.038273] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  271.038296] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[  271.038319] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  271.038342] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  271.038364] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[  271.038433] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 5 entries
[  271.038459] iwlwifi 0000:03:00.0: EVT_LOGT:0000000000:0x0000028c:0117
[  271.038476] iwlwifi 0000:03:00.0: EVT_LOGT:0000000021:0x00000000:1208
[  271.038491] iwlwifi 0000:03:00.0: EVT_LOGT:0000001005:0x00000001:0071
[  271.038507] iwlwifi 0000:03:00.0: EVT_LOGT:0000001081:0x00000002:0071
[  271.038523] iwlwifi 0000:03:00.0: EVT_LOGT:0000001087:0x00000000:0125
[  271.038920] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[  271.039025] iwlwifi 0000:03:00.0: Unable to initialize device.
[  475.791935] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[  475.808222] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[  475.808234] iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
[  475.808333] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[  475.808339] iwlwifi 0000:03:00.0: Status: 0x00040224, count: 5
[  475.808345] iwlwifi 0000:03:00.0: 0x00000005 | SYSASSERT                   
[  475.808350] iwlwifi 0000:03:00.0: 0x00016E00 | uPc
[  475.808354] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink1
[  475.808358] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink2
[  475.808363] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[  475.808367] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[  475.808371] iwlwifi 0000:03:00.0: 0x00000000 | data1
[  475.808375] iwlwifi 0000:03:00.0: 0x00000000 | data2
[  475.808379] iwlwifi 0000:03:00.0: 0x00000616 | line
[  475.808383] iwlwifi 0000:03:00.0: 0x00018BC9 | beacon time
[  475.808387] iwlwifi 0000:03:00.0: 0x00000437 | tsf low
[  475.808391] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[  475.808395] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[  475.808399] iwlwifi 0000:03:00.0: 0x0000043B | time gp2
[  475.808403] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[  475.808407] iwlwifi 0000:03:00.0: 0x0001271F | uCode version
[  475.808411] iwlwifi 0000:03:00.0: 0x0000006C | hw version
[  475.808416] iwlwifi 0000:03:00.0: 0x00880300 | board version
[  475.808420] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[  475.808424] iwlwifi 0000:03:00.0: CSR values:
[  475.808428] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[  475.808438] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[  475.808447] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[  475.808456] iwlwifi 0000:03:00.0:                     CSR_INT: 0X80000000
[  475.808465] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[  475.808474] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X40010000
[  475.808483] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[  475.808491] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[  475.808500] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[  475.808508] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
[  475.808517] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xc63f3885
[  475.808526] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[  475.808535] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00210801
[  475.808543] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[  475.808552] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[  475.808561] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[  475.808569] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[  475.808578] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[  475.808587] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[  475.808595] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[  475.808604] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[  475.808612] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[  475.808621] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[  475.808630] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[  475.808634] iwlwifi 0000:03:00.0: FH register values:
[  475.808653] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1336ff00
[  475.808673] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01336fe0
[  475.808693] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
[  475.808713] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[  475.808732] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  475.808752] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[  475.808772] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  475.808791] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  475.808811] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[  475.808880] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 5 entries
[  475.808906] iwlwifi 0000:03:00.0: EVT_LOGT:0000000000:0x0000028c:0117
[  475.808922] iwlwifi 0000:03:00.0: EVT_LOGT:0000000021:0x00000000:1208
[  475.808939] iwlwifi 0000:03:00.0: EVT_LOGT:0000001004:0x00000001:0071
[  475.808955] iwlwifi 0000:03:00.0: EVT_LOGT:0000001080:0x00000002:0071
[  475.808971] iwlwifi 0000:03:00.0: EVT_LOGT:0000001086:0x00000000:0125
[  475.809389] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[  475.809506] iwlwifi 0000:03:00.0: Unable to initialize device.
[  675.577322] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[  675.593589] iwlwifi 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
[  675.593602] iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
[  675.593701] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[  675.593707] iwlwifi 0000:03:00.0: Status: 0x00040224, count: 5
[  675.593713] iwlwifi 0000:03:00.0: 0x00000005 | SYSASSERT                   
[  675.593718] iwlwifi 0000:03:00.0: 0x00016E00 | uPc
[  675.593723] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink1
[  675.593727] iwlwifi 0000:03:00.0: 0x00016E00 | branchlink2
[  675.593731] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[  675.593735] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[  675.593739] iwlwifi 0000:03:00.0: 0x00000000 | data1
[  675.593743] iwlwifi 0000:03:00.0: 0x00000000 | data2
[  675.593747] iwlwifi 0000:03:00.0: 0x00000616 | line
[  675.593751] iwlwifi 0000:03:00.0: 0x00018BC8 | beacon time
[  675.593756] iwlwifi 0000:03:00.0: 0x00000438 | tsf low
[  675.593761] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[  675.593767] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[  675.593773] iwlwifi 0000:03:00.0: 0x0000043C | time gp2
[  675.593780] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[  675.593787] iwlwifi 0000:03:00.0: 0x0001271F | uCode version
[  675.593795] iwlwifi 0000:03:00.0: 0x0000006C | hw version
[  675.593803] iwlwifi 0000:03:00.0: 0x00880300 | board version
[  675.593809] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[  675.593815] iwlwifi 0000:03:00.0: CSR values:
[  675.593822] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[  675.593839] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00880300
[  675.593851] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
[  675.593860] iwlwifi 0000:03:00.0:                     CSR_INT: 0X80000000
[  675.593869] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[  675.593878] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X40010000
[  675.593886] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[  675.593895] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[  675.593904] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[  675.593912] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
[  675.593921] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0Xc63f3885
[  675.593930] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
[  675.593939] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00210801
[  675.593947] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[  675.593956] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[  675.593965] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[  675.593973] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[  675.593982] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[  675.593991] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000018
[  675.593999] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
[  675.594008] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[  675.594017] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[  675.594026] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[  675.594034] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[  675.594039] iwlwifi 0000:03:00.0: FH register values:
[  675.594059] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X1336ff00
[  675.594079] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01336fe0
[  675.594099] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
[  675.594119] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[  675.594138] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  675.594158] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[  675.594178] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  675.594198] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  675.594218] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[  675.594286] iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 5 entries
[  675.594313] iwlwifi 0000:03:00.0: EVT_LOGT:0000000000:0x0000028c:0117
[  675.594329] iwlwifi 0000:03:00.0: EVT_LOGT:0000000021:0x00000000:1208
[  675.594345] iwlwifi 0000:03:00.0: EVT_LOGT:0000001005:0x00000001:0071
[  675.594361] iwlwifi 0000:03:00.0: EVT_LOGT:0000001081:0x00000002:0071
[  675.594377] iwlwifi 0000:03:00.0: EVT_LOGT:0000001087:0x00000000:0125
[  675.594758] iwlwifi 0000:03:00.0: Failed to run INIT ucode: -5
[  675.594863] iwlwifi 0000:03:00.0: Unable to initialize device.



Thanks,
kind regards,
Andreas

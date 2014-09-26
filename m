Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:51381 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbaIZT43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 15:56:29 -0400
Received: by mail-ob0-f178.google.com with SMTP id va2so10651678obc.9
        for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2014 12:56:28 -0700 (PDT)
Date: Fri, 26 Sep 2014 14:56:16 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Keno =?utf-8?Q?Br=C3=BCggemann?= <post@kenobrueggemann.de>
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: Re: Ubuntu 14.04 and the =?utf-8?Q?Intel?=
 =?utf-8?B?wq4gQ2VudHJpbm/Crg==?= Advanced-N 6200
Message-ID: <20140926195616.GB138943@ubuntu-hedt> (sfid-20140926_215635_799497_B6BFDAED)
References: <542470A1.5070406@kenobrueggemann.de>
 <20140926125812.GA138943@ubuntu-hedt>
 <5425B7BD.5000000@kenobrueggemann.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5425B7BD.5000000@kenobrueggemann.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 26, 2014 at 09:00:13PM +0200, Keno Brüggemann wrote:
> Hello Seth,
> 
> thanks for helping me.

Looks like something is going bad when trying to initialize the
firmware. I'm cc-ing the Intel folks to see if they can tell what's
going on.

Can you tell us what kernel version you're running (uname -a)? If you
haven't yet, try installing 3.17-rc6 and see if it has the same
problems. We have prebuilt packages for Ubuntu at
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.17-rc6-utopic/.

Thanks,
Seth

> lspci -nn
> ---------------------------------------------------
> 
> 00:00.0 Host bridge [0600]: Intel Corporation Core Processor DMI
> [8086:d132] (rev 11)
> 00:03.0 PCI bridge [0604]: Intel Corporation Core Processor PCI
> Express Root Port 1 [8086:d138] (rev 11)
> 00:08.0 System peripheral [0880]: Intel Corporation Core Processor
> System Management Registers [8086:d155] (rev 11)
> 00:08.1 System peripheral [0880]: Intel Corporation Core Processor
> Semaphore and Scratchpad Registers [8086:d156] (rev 11)
> 00:08.2 System peripheral [0880]: Intel Corporation Core Processor
> System Control and Status Registers [8086:d157] (rev 11)
> 00:08.3 System peripheral [0880]: Intel Corporation Core Processor
> Miscellaneous Registers [8086:d158] (rev 11)
> 00:10.0 System peripheral [0880]: Intel Corporation Core Processor
> QPI Link [8086:d150] (rev 11)
> 00:10.1 System peripheral [0880]: Intel Corporation Core Processor
> QPI Routing and Protocol Registers [8086:d151] (rev 11)
> 00:16.0 Communication controller [0780]: Intel Corporation 5
> Series/3400 Series Chipset HECI Controller [8086:3b64] (rev 06)
> 00:1a.0 USB controller [0c03]: Intel Corporation 5 Series/3400
> Series Chipset USB2 Enhanced Host Controller [8086:3b3c] (rev 06)
> 00:1b.0 Audio device [0403]: Intel Corporation 5 Series/3400 Series
> Chipset High Definition Audio [8086:3b56] (rev 06)
> 00:1c.0 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series
> Chipset PCI Express Root Port 1 [8086:3b42] (rev 06)
> 00:1c.1 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series
> Chipset PCI Express Root Port 2 [8086:3b44] (rev 06)
> 00:1c.3 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series
> Chipset PCI Express Root Port 4 [8086:3b48] (rev 06)
> 00:1c.4 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series
> Chipset PCI Express Root Port 5 [8086:3b4a] (rev 06)
> 00:1c.5 PCI bridge [0604]: Intel Corporation 5 Series/3400 Series
> Chipset PCI Express Root Port 6 [8086:3b4c] (rev 06)
> 00:1d.0 USB controller [0c03]: Intel Corporation 5 Series/3400
> Series Chipset USB2 Enhanced Host Controller [8086:3b34] (rev 06)
> 00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge
> [8086:2448] (rev a6)
> 00:1f.0 ISA bridge [0601]: Intel Corporation Mobile 5 Series Chipset
> LPC Interface Controller [8086:3b0b] (rev 06)
> 00:1f.2 SATA controller [0106]: Intel Corporation 5 Series/3400
> Series Chipset 6 port SATA AHCI Controller [8086:3b2f] (rev 06)
> 00:1f.3 SMBus [0c05]: Intel Corporation 5 Series/3400 Series Chipset
> SMBus Controller [8086:3b30] (rev 06)
> 02:00.0 VGA compatible controller [0300]: NVIDIA Corporation GF106M
> [GeForce GT 445M] [10de:0dd2] (rev a1)
> 02:00.1 Audio device [0403]: NVIDIA Corporation GF106 High
> Definition Audio Controller [10de:0be9] (rev a1)
> 04:00.0 Network controller [0280]: Intel Corporation Centrino
> Advanced-N 6200 [8086:422c] (rev 35)
> 06:00.0 USB controller [0c03]: NEC Corporation uPD720200 USB 3.0
> Host Controller [1033:0194] (rev 03)
> 0a:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
> RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller
> [10ec:8168] (rev 06)
> ff:00.0 Host bridge [0600]: Intel Corporation Core Processor
> QuickPath Architecture Generic Non-Core Registers [8086:2c52] (rev
> 04)
> ff:00.1 Host bridge [0600]: Intel Corporation Core Processor
> QuickPath Architecture System Address Decoder [8086:2c81] (rev 04)
> ff:02.0 Host bridge [0600]: Intel Corporation Core Processor QPI
> Link 0 [8086:2c90] (rev 04)
> ff:02.1 Host bridge [0600]: Intel Corporation Core Processor QPI
> Physical 0 [8086:2c91] (rev 04)
> ff:03.0 Host bridge [0600]: Intel Corporation Core Processor
> Integrated Memory Controller [8086:2c98] (rev 04)
> ff:03.1 Host bridge [0600]: Intel Corporation Core Processor
> Integrated Memory Controller Target Address Decoder [8086:2c99] (rev
> 04)
> ff:03.4 Host bridge [0600]: Intel Corporation Core Processor
> Integrated Memory Controller Test Registers [8086:2c9c] (rev 04)
> ff:04.0 Host bridge [0600]: Intel Corporation Core Processor
> Integrated Memory Controller Channel 0 Control Registers [8086:2ca0]
> (rev 04)
> ff:04.1 Host bridge [0600]: Intel Corporation Core Processor
> Integrated Memory Controller Channel 0 Address Registers [8086:2ca1]
> (rev 04)
> ff:04.2 Host bridge [0600]: Intel Corporation Core Processor
> Integrated Memory Controller Channel 0 Rank Registers [8086:2ca2]
> (rev 04)
> ff:04.3 Host bridge [0600]: Intel Corporation Core Processor
> Integrated Memory Controller Channel 0 Thermal Control Registers
> [8086:2ca3] (rev 04)
> ff:05.0 Host bridge [0600]: Intel Corporation Core Processor
> Integrated Memory Controller Channel 1 Control Registers [8086:2ca8]
> (rev 04)
> ff:05.1 Host bridge [0600]: Intel Corporation Core Processor
> Integrated Memory Controller Channel 1 Address Registers [8086:2ca9]
> (rev 04)
> ff:05.2 Host bridge [0600]: Intel Corporation Core Processor
> Integrated Memory Controller Channel 1 Rank Registers [8086:2caa]
> (rev 04)
> ff:05.3 Host bridge [0600]: Intel Corporation Core Processor
> Integrated Memory Controller Channel 1 Thermal Control Registers
> [8086:2cab] (rev 04)
> 
> 
> 
> --------------------------------------------------
> dmesg is attached.
> 
> 
> 
> -------------------------------------------------
> 
> lsmod | grep "iwl"
> iwldvm                232285  0
> mac80211              626557  1 iwldvm
> iwlwifi               169932  1 iwldvm
> cfg80211              484040  3 iwlwifi,mac80211,iwldvm
> 
> Greetings
> Keno Brüggemann
> 
> Am 26.09.2014 um 14:58 schrieb Seth Forshee:
> >On Thu, Sep 25, 2014 at 09:44:33PM +0200, Keno Brüggemann wrote:
> >>Hello,
> >>
> >>i switched from an Intel® Centrino® Wireless-N 1000
> >>to the Intel® Centrino® Advanced-N 6200 Wireless Card Adapter.
> >>
> >>My System. Dell xps l701x, ubuntu 14.04
> >>
> >>The Problem is, this Adpater won't work under Ubuntu 14.04. I've
> >>installed both versions of this Firmware.
> >>Nothing. Seems to be dead.
> >>Under Windows 7 the Card works well.
> >>
> >>Can i try something else to get it work?
> >>Please help.
> >It certainly ought to work, there are plenty of people using Intel 6200
> >hardware with Ubuntu 14.04.
> >
> >A few pieces of information would be useful to start - the output of
> >'lspci -nn', dmesg, and whether or not the iwlwifi and iwldvm modules
> >are loaded (i.e. are they listed in the output from lsmod).
> >
> >Or you might just want to file a bug against Ubuntu by running
> >'ubuntu-bug linux' while on a wired connection. This will automatically
> >attach all the information I just asked for to the bug report. You can
> >subscribe me to the bug and I'll help you out there.
> >
> >Thanks,
> >Seth
> >
> 

> dmesg
> [27954.226463] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27954.226467] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27954.227288] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27954.227388] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27954.227883] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27954.234695] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27954.271026] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27954.271034] iwlwifi 0000:04:00.0: CSR values:
> [27954.271039] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27954.271049] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27954.271060] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27954.271070] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27954.271080] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27954.271090] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27954.271101] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27954.271111] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27954.271121] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27954.271131] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27954.271142] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27954.271152] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27954.271161] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27954.271171] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27954.271242] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27954.271252] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27954.271266] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27954.271276] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27954.271286] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27954.271303] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27954.271318] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27954.271328] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27954.271338] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27954.271349] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27954.271353] iwlwifi 0000:04:00.0: FH register values:
> [27954.271389] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27954.271425] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27954.271460] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27954.271495] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27954.271532] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27954.271568] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27954.271604] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27954.271640] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27954.271676] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27954.271682] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27954.271687] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27954.271692] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27954.271703] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27954.272468] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27954.272589] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27954.274697] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27954.281617] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27954.318011] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27954.318019] iwlwifi 0000:04:00.0: CSR values:
> [27954.318024] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27954.318034] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27954.318045] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27954.318055] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27954.318065] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27954.318076] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27954.318086] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27954.318096] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27954.318106] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27954.318116] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27954.318125] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27954.318135] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27954.318145] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27954.318155] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27954.318165] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27954.318175] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27954.318186] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27954.318198] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27954.318211] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27954.318224] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27954.318235] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27954.318248] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27954.318260] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27954.318274] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27954.318280] iwlwifi 0000:04:00.0: FH register values:
> [27954.318316] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27954.318351] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27954.318387] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27954.318423] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27954.318459] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27954.318495] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27954.318530] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27954.318566] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27954.318602] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27954.318608] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27954.318613] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27954.318618] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27954.318628] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27954.319557] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27954.319662] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27954.320068] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27954.326831] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27954.361717] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27954.361723] iwlwifi 0000:04:00.0: CSR values:
> [27954.361725] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27954.361734] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27954.361742] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27954.361751] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27954.361759] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27954.361767] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27954.361775] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27954.361784] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27954.361792] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27954.361800] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27954.361808] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27954.361816] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27954.361825] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27954.361833] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27954.361841] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27954.361849] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27954.361857] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27954.361866] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27954.361874] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27954.361882] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27954.361890] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27954.361898] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27954.361907] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27954.361915] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27954.361918] iwlwifi 0000:04:00.0: FH register values:
> [27954.361952] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27954.361985] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27954.362019] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27954.362053] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27954.362086] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27954.362120] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27954.362154] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27954.362186] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27954.362220] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27954.362223] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27954.362227] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27954.362230] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27954.362237] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27954.362949] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27954.363054] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27954.364481] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27954.371275] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27954.406767] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27954.406771] iwlwifi 0000:04:00.0: CSR values:
> [27954.406773] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27954.406780] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27954.406787] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27954.406794] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27954.406801] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27954.406807] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27954.406814] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27954.406821] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27954.406828] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27954.406835] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27954.406842] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27954.406848] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27954.406855] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27954.406862] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27954.406868] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27954.406875] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27954.406882] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27954.406888] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27954.406895] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27954.406902] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27954.406909] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27954.406915] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27954.406922] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27954.406929] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27954.406930] iwlwifi 0000:04:00.0: FH register values:
> [27954.406962] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27954.406994] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27954.407025] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27954.407057] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27954.407089] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27954.407124] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27954.407154] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27954.407187] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27954.407219] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27954.407221] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27954.407224] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27954.407226] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27954.407230] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27954.407950] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27954.408070] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27954.408535] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27954.415333] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27954.449045] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27954.449053] iwlwifi 0000:04:00.0: CSR values:
> [27954.449058] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27954.449068] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27954.449078] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27954.449088] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27954.449098] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27954.449108] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27954.449119] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27954.449129] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27954.449139] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27954.449149] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27954.449159] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27954.449169] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27954.449179] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27954.449189] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27954.449199] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27954.449210] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27954.449220] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27954.449229] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27954.449240] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27954.449250] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27954.449260] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27954.449270] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27954.449280] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27954.449290] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27954.449295] iwlwifi 0000:04:00.0: FH register values:
> [27954.449331] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27954.449366] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27954.449401] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27954.449463] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27954.449500] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27954.449536] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27954.449577] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27954.449622] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27954.449662] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27954.449667] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27954.449671] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27954.449675] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27954.449683] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27954.450534] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27954.450656] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27954.452567] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27954.459412] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27954.493699] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27954.493703] iwlwifi 0000:04:00.0: CSR values:
> [27954.493705] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27954.493712] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27954.493719] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27954.493726] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27954.493733] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27954.493739] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27954.493746] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27954.493753] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27954.493759] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27954.493766] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27954.493773] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27954.493780] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27954.493786] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27954.493793] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27954.493800] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27954.493806] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27954.493813] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27954.493820] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27954.493826] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27954.493833] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27954.493840] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27954.493847] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27954.493853] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27954.493860] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27954.493862] iwlwifi 0000:04:00.0: FH register values:
> [27954.493893] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27954.493926] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27954.493957] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27954.493990] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27954.494022] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27954.494054] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27954.494085] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27954.494233] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27954.494282] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27954.494285] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27954.494288] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27954.494291] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27954.494298] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27954.495052] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27954.495153] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27954.495539] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27954.502303] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27954.537491] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27954.537500] iwlwifi 0000:04:00.0: CSR values:
> [27954.537505] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27954.537515] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27954.537526] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27954.537536] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27954.537546] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27954.537556] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27954.537566] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27954.537577] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27954.537586] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27954.537597] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27954.537607] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27954.537617] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27954.537628] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27954.537638] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27954.537648] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27954.537658] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27954.537668] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27954.537678] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27954.537688] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27954.537699] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27954.537709] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27954.537719] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27954.537729] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27954.537739] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27954.537743] iwlwifi 0000:04:00.0: FH register values:
> [27954.537780] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27954.537814] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27954.537850] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27954.537886] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27954.537920] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27954.537954] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27954.537989] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27954.538023] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27954.538056] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27954.538062] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27954.538068] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27954.538073] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27954.538084] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27954.538860] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27954.538982] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27954.541015] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27954.547819] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27954.583122] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27954.583130] iwlwifi 0000:04:00.0: CSR values:
> [27954.583135] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27954.583145] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27954.583156] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27954.583166] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27954.583176] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27954.583186] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27954.583196] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27954.583206] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27954.583216] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27954.583226] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27954.583236] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27954.583246] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27954.583257] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27954.583267] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27954.583277] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27954.583287] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27954.583297] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27954.583308] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27954.583318] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27954.583328] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27954.583338] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27954.583348] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27954.583358] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27954.583368] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27954.583372] iwlwifi 0000:04:00.0: FH register values:
> [27954.583408] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27954.583445] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27954.583479] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27954.583515] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27954.583551] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27954.583585] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27954.583621] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27954.583657] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27954.583693] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27954.583698] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27954.583704] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27954.583709] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27954.583719] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27954.584555] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27954.584678] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27954.585127] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27954.591905] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27954.627671] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27954.627679] iwlwifi 0000:04:00.0: CSR values:
> [27954.627684] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27954.627697] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27954.627708] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27954.627718] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27954.627728] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27954.627739] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27954.627749] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27954.627759] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27954.627769] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27954.627779] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27954.627789] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27954.627799] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27954.627810] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27954.627820] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27954.627830] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27954.627840] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27954.627850] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27954.627860] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27954.627870] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27954.627881] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27954.627890] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27954.627900] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27954.627911] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27954.627921] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27954.627925] iwlwifi 0000:04:00.0: FH register values:
> [27954.627961] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27954.627997] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27954.628031] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27954.628067] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27954.628103] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27954.628139] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27954.628175] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27954.628209] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27954.628245] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27954.628250] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27954.628256] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27954.628261] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27954.628271] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27954.629038] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27954.629160] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27954.631220] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27954.638011] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27954.673965] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27954.673973] iwlwifi 0000:04:00.0: CSR values:
> [27954.673977] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27954.673988] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27954.673998] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27954.674009] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27954.674019] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27954.674029] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27954.674039] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27954.674049] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27954.674059] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27954.674069] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27954.674079] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27954.674089] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27954.674100] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27954.674110] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27954.674120] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27954.674130] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27954.674140] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27954.674150] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27954.674160] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27954.674171] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27954.674180] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27954.674191] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27954.674201] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27954.674211] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27954.674215] iwlwifi 0000:04:00.0: FH register values:
> [27954.674250] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27954.674286] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27954.674321] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27954.674357] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27954.674393] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27954.674429] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27954.674464] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27954.674500] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27954.674536] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27954.674541] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27954.674547] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27954.674552] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27954.674561] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27954.675331] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27954.675429] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27954.675752] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27954.682520] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27954.718459] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27954.718467] iwlwifi 0000:04:00.0: CSR values:
> [27954.718472] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27954.718485] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27954.718496] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27954.718506] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27954.718516] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27954.718527] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27954.718536] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27954.718546] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27954.718556] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27954.718566] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27954.718576] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27954.718586] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27954.718596] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27954.718606] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27954.718616] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27954.718627] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27954.718637] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27954.718647] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27954.718657] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27954.718667] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27954.718678] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27954.718687] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27954.718698] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27954.718708] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27954.718712] iwlwifi 0000:04:00.0: FH register values:
> [27954.718748] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27954.718784] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27954.718820] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27954.718856] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27954.718891] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27954.718927] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27954.718963] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27954.719001] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27954.719037] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27954.719043] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27954.719048] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27954.719053] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27954.719063] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27954.719889] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27954.720011] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27954.721991] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27954.728772] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27954.764162] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27954.764170] iwlwifi 0000:04:00.0: CSR values:
> [27954.764174] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27954.764185] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27954.764195] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27954.764205] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27954.764216] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27954.764226] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27954.764236] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27954.764246] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27954.764256] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27954.764266] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27954.764276] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27954.764286] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27954.764297] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27954.764306] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27954.764317] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27954.764327] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27954.764337] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27954.764347] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27954.764357] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27954.764367] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27954.764377] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27954.764387] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27954.764398] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27954.764407] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27954.764412] iwlwifi 0000:04:00.0: FH register values:
> [27954.764448] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27954.764483] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27954.764519] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27954.764554] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27954.764590] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27954.764625] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27954.764661] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27954.764695] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27954.764731] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27954.764737] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27954.764742] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27954.764747] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27954.764757] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27954.765572] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27954.765714] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27954.766199] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27954.773019] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27954.809198] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27954.809206] iwlwifi 0000:04:00.0: CSR values:
> [27954.809210] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27954.809221] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27954.809231] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27954.809241] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27954.809251] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27954.809285] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27954.809296] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27954.809306] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27954.809316] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27954.809326] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27954.809336] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27954.809346] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27954.809356] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27954.809366] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27954.809379] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27954.809396] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27954.809415] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27954.809431] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27954.809441] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27954.809451] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27954.809462] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27954.809471] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27954.809481] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27954.809496] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27954.809504] iwlwifi 0000:04:00.0: FH register values:
> [27954.809540] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27954.809581] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27954.809617] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27954.809657] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27954.809696] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27954.809734] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27954.809773] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27954.809813] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27954.809851] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27954.809860] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27954.809868] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27954.809875] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27954.809890] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27954.810661] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27954.810766] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27954.812368] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27954.819123] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27954.853377] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27954.853385] iwlwifi 0000:04:00.0: CSR values:
> [27954.853390] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27954.853399] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27954.853410] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27954.853420] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27954.853430] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27954.853441] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27954.853451] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27954.853461] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27954.853471] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27954.853481] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27954.853491] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27954.853501] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27954.853511] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27954.853521] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27954.853531] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27954.853541] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27954.853552] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27954.853562] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27954.853572] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27954.853582] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27954.853592] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27954.853602] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27954.853613] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27954.853622] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27954.853627] iwlwifi 0000:04:00.0: FH register values:
> [27954.853663] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27954.853699] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27954.853735] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27954.853771] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27954.853806] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27954.853842] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27954.853877] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27954.853912] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27954.853948] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27954.853953] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27954.853958] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27954.853963] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27954.853973] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27954.854742] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27954.854864] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27954.855337] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27954.862123] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27954.898204] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27954.898212] iwlwifi 0000:04:00.0: CSR values:
> [27954.898217] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27954.898230] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27954.898241] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27954.898251] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27954.898261] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27954.898272] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27954.898281] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27954.898292] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27954.898302] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27954.898312] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27954.898322] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27954.898332] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27954.898342] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27954.898352] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27954.898362] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27954.898372] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27954.898382] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27954.898392] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27954.898402] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27954.898412] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27954.898423] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27954.898433] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27954.898443] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27954.898453] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27954.898457] iwlwifi 0000:04:00.0: FH register values:
> [27954.898492] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27954.898528] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27954.898563] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27954.898599] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27954.898634] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27954.898670] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27954.898706] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27954.898742] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27954.898778] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27954.898784] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27954.898789] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27954.898794] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27954.898805] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27954.899534] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27954.899675] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27954.901792] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27954.908579] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27954.944823] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27954.944831] iwlwifi 0000:04:00.0: CSR values:
> [27954.944836] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27954.944846] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27954.944857] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27954.944867] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27954.944877] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27954.944887] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27954.944898] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27954.944908] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27954.944918] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27954.944928] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27954.944938] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27954.944948] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27954.944958] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27954.944968] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27954.944978] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27954.944988] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27954.944998] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27954.945008] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27954.945019] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27954.945029] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27954.945039] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27954.945049] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27954.945060] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27954.945070] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27954.945074] iwlwifi 0000:04:00.0: FH register values:
> [27954.945110] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27954.945146] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27954.945182] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27954.945242] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27954.945278] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27954.945314] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27954.945357] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27954.945401] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27954.945440] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27954.945445] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27954.945451] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27954.945456] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27954.945465] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27954.946259] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27954.946381] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27954.946894] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27954.953689] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27954.989800] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27954.989810] iwlwifi 0000:04:00.0: CSR values:
> [27954.989817] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27954.989833] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27954.989849] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27954.989861] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27954.989875] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27954.989887] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27954.989897] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27954.989907] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27954.989923] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27954.989933] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27954.989943] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27954.989953] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27954.989963] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27954.989973] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27954.989983] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27954.989993] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27954.990003] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27954.990013] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27954.990024] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27954.990036] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27954.990048] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27954.990061] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27954.990074] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27954.990087] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27954.990093] iwlwifi 0000:04:00.0: FH register values:
> [27954.990133] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27954.990169] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27954.990204] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27954.990238] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27954.990274] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27954.990310] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27954.990344] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27954.990380] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27954.990416] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27954.990421] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27954.990427] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27954.990432] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27954.990441] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27954.991258] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27954.991378] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27954.993594] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.000384] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27955.036550] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27955.036558] iwlwifi 0000:04:00.0: CSR values:
> [27955.036563] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27955.036576] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27955.036587] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27955.036598] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27955.036608] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27955.036618] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27955.036628] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27955.036638] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27955.036649] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27955.036659] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27955.036669] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27955.036679] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27955.036690] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27955.036700] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27955.036710] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27955.036720] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27955.036730] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27955.036740] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27955.036750] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27955.036761] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27955.036771] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27955.036781] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27955.036791] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27955.036801] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27955.036806] iwlwifi 0000:04:00.0: FH register values:
> [27955.036840] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27955.036876] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27955.036911] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27955.036947] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27955.036983] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27955.037019] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27955.037055] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27955.037091] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27955.037127] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27955.037132] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27955.037137] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27955.037142] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27955.037152] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27955.037923] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27955.038044] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27955.038529] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.045343] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27955.081432] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27955.081442] iwlwifi 0000:04:00.0: CSR values:
> [27955.081448] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27955.081462] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27955.081472] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27955.081482] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27955.081493] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27955.081502] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27955.081512] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27955.081522] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27955.081533] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27955.081542] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27955.081553] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27955.081563] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27955.081573] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27955.081583] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27955.081593] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27955.081604] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27955.081613] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27955.081624] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27955.081634] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27955.081644] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27955.081654] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27955.081664] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27955.081674] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27955.081684] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27955.081688] iwlwifi 0000:04:00.0: FH register values:
> [27955.081724] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27955.081760] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27955.081794] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27955.081830] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27955.081866] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27955.081902] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27955.081938] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27955.081974] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27955.082010] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27955.082015] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27955.082020] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27955.082025] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27955.082035] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27955.082804] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27955.082927] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27955.085011] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.091790] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27955.127850] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27955.127858] iwlwifi 0000:04:00.0: CSR values:
> [27955.127862] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27955.127876] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27955.127886] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27955.127897] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27955.127907] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27955.127917] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27955.127927] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27955.127938] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27955.127948] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27955.127958] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27955.127968] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27955.127978] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27955.127988] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27955.127998] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27955.128008] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27955.128018] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27955.128028] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27955.128039] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27955.128049] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27955.128059] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27955.128069] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27955.128079] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27955.128089] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27955.128099] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27955.128104] iwlwifi 0000:04:00.0: FH register values:
> [27955.128140] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27955.128175] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27955.128210] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27955.128246] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27955.128281] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27955.128317] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27955.128353] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27955.128389] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27955.128425] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27955.128430] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27955.128436] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27955.128441] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27955.128451] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27955.129265] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27955.129388] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27955.129915] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.136781] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27955.172773] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27955.172781] iwlwifi 0000:04:00.0: CSR values:
> [27955.172786] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27955.172797] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27955.172807] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27955.172817] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27955.172910] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27955.172920] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27955.172935] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27955.172945] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27955.172955] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27955.172965] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27955.172975] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27955.172985] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27955.172995] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27955.173005] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27955.173015] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27955.173026] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27955.173035] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27955.173045] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27955.173055] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27955.173065] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27955.173075] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27955.173085] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27955.173096] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27955.173134] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27955.173139] iwlwifi 0000:04:00.0: FH register values:
> [27955.173175] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27955.173211] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27955.173245] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27955.173288] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27955.173322] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27955.173358] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27955.173400] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27955.173435] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27955.173471] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27955.173476] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27955.173482] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27955.173487] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27955.173495] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27955.174245] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27955.174344] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27955.176294] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.183118] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27955.217471] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27955.217479] iwlwifi 0000:04:00.0: CSR values:
> [27955.217484] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27955.217495] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27955.217505] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27955.217515] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27955.217525] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27955.217536] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27955.217546] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27955.217555] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27955.217566] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27955.217576] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27955.217586] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27955.217596] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27955.217607] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27955.217617] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27955.217627] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27955.217637] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27955.217647] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27955.217657] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27955.217667] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27955.217677] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27955.217687] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27955.217697] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27955.217707] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27955.217717] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27955.217722] iwlwifi 0000:04:00.0: FH register values:
> [27955.217758] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27955.217794] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27955.217828] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27955.217864] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27955.217900] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27955.217936] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27955.217972] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27955.218008] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27955.218043] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27955.218049] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27955.218054] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27955.218059] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27955.218069] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27955.218852] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27955.218975] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27955.219485] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.226308] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27955.262490] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27955.262498] iwlwifi 0000:04:00.0: CSR values:
> [27955.262502] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27955.262513] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27955.262523] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27955.262534] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27955.262544] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27955.262554] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27955.262564] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27955.262574] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27955.262584] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27955.262594] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27955.262604] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27955.262614] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27955.262624] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27955.262634] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27955.262645] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27955.262654] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27955.262665] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27955.262675] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27955.262685] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27955.262695] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27955.262705] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27955.262715] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27955.262724] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27955.262735] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27955.262739] iwlwifi 0000:04:00.0: FH register values:
> [27955.262775] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27955.262811] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27955.262847] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27955.262882] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27955.262918] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27955.262953] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27955.262989] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27955.263025] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27955.263060] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27955.263066] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27955.263072] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27955.263077] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27955.263087] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27955.263883] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27955.264004] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27955.266127] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.272927] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27955.308776] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27955.308784] iwlwifi 0000:04:00.0: CSR values:
> [27955.308789] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27955.308799] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27955.308810] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27955.308820] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27955.308831] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27955.308841] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27955.308851] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27955.308861] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27955.308871] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27955.308881] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27955.308891] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27955.308901] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27955.308911] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27955.308921] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27955.308932] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27955.308942] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27955.308952] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27955.308962] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27955.308972] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27955.308983] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27955.308993] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27955.309003] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27955.309013] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27955.309023] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27955.309028] iwlwifi 0000:04:00.0: FH register values:
> [27955.309090] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27955.309127] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27955.309167] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27955.309210] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27955.309254] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27955.309289] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27955.309325] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27955.309361] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27955.309397] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27955.309402] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27955.309408] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27955.309413] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27955.309421] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27955.310131] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27955.310229] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27955.310581] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.317413] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27955.353332] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27955.353340] iwlwifi 0000:04:00.0: CSR values:
> [27955.353344] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27955.353354] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27955.353364] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27955.353374] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27955.353383] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27955.353393] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27955.353402] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27955.353411] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27955.353421] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27955.353430] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27955.353439] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27955.353449] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27955.353458] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27955.353468] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27955.353477] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27955.353486] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27955.353496] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27955.353506] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27955.353515] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27955.353524] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27955.353534] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27955.353543] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27955.353553] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27955.353563] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27955.353567] iwlwifi 0000:04:00.0: FH register values:
> [27955.353602] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27955.353637] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27955.353673] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27955.353708] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27955.353743] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27955.353778] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27955.353812] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27955.353847] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27955.353882] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27955.353888] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27955.353893] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27955.353897] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27955.353907] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27955.354627] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27955.354733] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27955.356666] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.363458] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27955.399296] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27955.399304] iwlwifi 0000:04:00.0: CSR values:
> [27955.399309] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27955.399320] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27955.399331] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27955.399341] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27955.399352] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27955.399362] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27955.399372] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27955.399382] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27955.399392] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27955.399402] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27955.399412] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27955.399423] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27955.399432] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27955.399443] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27955.399453] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27955.399462] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27955.399473] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27955.399483] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27955.399493] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27955.399503] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27955.399513] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27955.399523] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27955.399533] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27955.399544] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27955.399548] iwlwifi 0000:04:00.0: FH register values:
> [27955.399585] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27955.399620] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27955.399656] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27955.399691] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27955.399726] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27955.399761] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27955.399796] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27955.399831] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27955.399867] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27955.399873] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27955.399878] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27955.399884] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27955.399894] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27955.400604] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27955.400703] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27955.401151] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.407948] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27955.444041] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27955.444049] iwlwifi 0000:04:00.0: CSR values:
> [27955.444054] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27955.444064] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27955.444075] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27955.444085] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27955.444095] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27955.444105] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27955.444115] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27955.444125] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27955.444135] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27955.444145] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27955.444155] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27955.444165] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27955.444175] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27955.444185] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27955.444196] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27955.444209] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27955.444222] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27955.444234] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27955.444255] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27955.444266] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27955.444279] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27955.444292] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27955.444312] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27955.444326] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27955.444331] iwlwifi 0000:04:00.0: FH register values:
> [27955.444367] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27955.444403] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27955.444438] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27955.444473] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27955.444509] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27955.444545] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27955.444581] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27955.444617] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27955.444653] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27955.444658] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27955.444664] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27955.444669] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27955.444678] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27955.445508] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27955.445672] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27955.447820] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.454610] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27955.489178] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27955.489184] iwlwifi 0000:04:00.0: CSR values:
> [27955.489188] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27955.489198] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27955.489207] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27955.489216] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27955.489225] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27955.489235] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27955.489243] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27955.489253] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27955.489262] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27955.489271] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27955.489280] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27955.489290] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27955.489299] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27955.489308] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27955.489317] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27955.489326] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27955.489335] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27955.489344] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27955.489353] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27955.489362] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27955.489371] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27955.489380] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27955.489389] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27955.489398] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27955.489401] iwlwifi 0000:04:00.0: FH register values:
> [27955.489436] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27955.489471] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27955.489506] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27955.489541] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27955.489575] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27955.489610] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27955.489643] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27955.489678] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27955.489711] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27955.489715] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27955.489720] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27955.489724] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27955.489732] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27955.490446] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27955.490545] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27955.490894] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.497652] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27955.533347] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27955.533350] iwlwifi 0000:04:00.0: CSR values:
> [27955.533352] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27955.533359] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27955.533366] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27955.533373] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27955.533380] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27955.533387] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27955.533393] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27955.533400] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27955.533407] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27955.533414] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27955.533420] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27955.533427] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27955.533434] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27955.533440] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27955.533447] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27955.533454] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27955.533460] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27955.533467] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27955.533474] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27955.533481] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27955.533487] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27955.533494] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27955.533501] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27955.533507] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27955.533509] iwlwifi 0000:04:00.0: FH register values:
> [27955.533540] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27955.533573] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27955.533605] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27955.533637] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27955.533671] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27955.533705] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27955.533739] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27955.533772] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27955.533806] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27955.533809] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27955.533814] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27955.533817] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27955.533823] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27955.534638] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27955.534767] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27955.537011] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.543794] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27955.580041] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27955.580049] iwlwifi 0000:04:00.0: CSR values:
> [27955.580053] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27955.580064] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27955.580075] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27955.580085] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27955.580096] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27955.580106] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27955.580116] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27955.580126] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27955.580136] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27955.580146] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27955.580157] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27955.580167] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27955.580177] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27955.580187] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27955.580197] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27955.580207] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27955.580217] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27955.580227] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27955.580237] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27955.580247] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27955.580258] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27955.580268] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27955.580278] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27955.580288] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27955.580293] iwlwifi 0000:04:00.0: FH register values:
> [27955.580329] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27955.580365] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27955.580401] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27955.580437] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27955.580471] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27955.580507] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27955.580543] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27955.580579] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27955.580613] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27955.580618] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27955.580624] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27955.580629] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27955.580639] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27955.581545] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27955.581681] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27955.582176] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.589021] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27955.625045] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27955.625053] iwlwifi 0000:04:00.0: CSR values:
> [27955.625058] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27955.625068] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27955.625079] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27955.625089] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27955.625099] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27955.625110] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27955.625120] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27955.625130] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27955.625140] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27955.625150] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27955.625160] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27955.625171] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27955.625180] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27955.625191] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27955.625201] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27955.625211] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27955.625221] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27955.625231] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27955.625241] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27955.625251] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27955.625261] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27955.625271] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27955.625282] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27955.625292] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27955.625296] iwlwifi 0000:04:00.0: FH register values:
> [27955.625333] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27955.625368] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27955.625404] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27955.625440] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27955.625475] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27955.625509] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27955.625545] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27955.625580] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27955.625616] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27955.625622] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27955.625627] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27955.625632] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27955.625642] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27955.626412] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27955.626516] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27955.628211] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.635068] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27955.669618] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27955.669626] iwlwifi 0000:04:00.0: CSR values:
> [27955.669631] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27955.669641] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27955.669652] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27955.669662] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27955.669672] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27955.669682] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27955.669693] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27955.669703] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27955.669713] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27955.669724] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27955.669734] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27955.669744] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27955.669754] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27955.669764] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27955.669774] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27955.669784] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27955.669794] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27955.669804] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27955.669815] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27955.669825] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27955.669835] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27955.669845] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27955.669855] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27955.669865] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27955.669870] iwlwifi 0000:04:00.0: FH register values:
> [27955.669906] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27955.669942] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27955.669978] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27955.670014] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27955.670050] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27955.670085] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27955.670121] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27955.670157] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27955.670193] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27955.670199] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27955.670204] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27955.670209] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27955.670220] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27955.671024] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27955.671146] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27955.671662] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.678461] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27955.714462] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27955.714470] iwlwifi 0000:04:00.0: CSR values:
> [27955.714474] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27955.714488] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27955.714498] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27955.714509] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27955.714519] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27955.714529] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27955.714539] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27955.714550] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27955.714560] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27955.714570] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27955.714580] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27955.714590] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27955.714600] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27955.714610] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27955.714620] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27955.714630] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27955.714640] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27955.714650] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27955.714660] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27955.714670] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27955.714680] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27955.714690] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27955.714700] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27955.714710] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27955.714714] iwlwifi 0000:04:00.0: FH register values:
> [27955.714750] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27955.714786] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27955.714820] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27955.714855] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27955.714891] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27955.714925] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27955.714961] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27955.714997] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27955.715031] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27955.715037] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27955.715042] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27955.715047] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27955.715057] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27955.715824] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27955.715944] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27955.718037] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.724826] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27955.760960] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27955.760967] iwlwifi 0000:04:00.0: CSR values:
> [27955.760972] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27955.760983] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27955.760994] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27955.761004] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27955.761014] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27955.761025] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27955.761035] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27955.761045] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27955.761055] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27955.761065] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27955.761075] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27955.761085] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27955.761095] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27955.761105] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27955.761115] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27955.761125] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27955.761134] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27955.761144] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27955.761155] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27955.761165] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27955.761175] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27955.761185] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27955.761196] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27955.761206] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27955.761210] iwlwifi 0000:04:00.0: FH register values:
> [27955.761246] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27955.761282] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27955.761318] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27955.761354] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27955.761388] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27955.761424] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27955.761460] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27955.761496] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27955.761529] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27955.761534] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27955.761540] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27955.761545] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27955.761555] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27955.762339] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27955.762437] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27955.762778] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.769652] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27955.804937] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27955.804945] iwlwifi 0000:04:00.0: CSR values:
> [27955.804950] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27955.804960] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27955.804971] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27955.804981] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27955.804991] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27955.805001] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27955.805011] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27955.805021] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27955.805032] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27955.805042] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27955.805052] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27955.805062] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27955.805072] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27955.805083] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27955.805093] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27955.805103] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27955.805113] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27955.805123] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27955.805132] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27955.805143] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27955.805152] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27955.805162] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27955.805172] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27955.805182] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27955.805187] iwlwifi 0000:04:00.0: FH register values:
> [27955.805223] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27955.805259] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27955.805294] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27955.805330] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27955.805366] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27955.805402] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27955.805437] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27955.805473] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27955.805507] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27955.805512] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27955.805518] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27955.805523] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27955.805533] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27955.806316] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27955.806437] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27955.808476] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.815319] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27955.850618] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27955.850626] iwlwifi 0000:04:00.0: CSR values:
> [27955.850631] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27955.850641] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27955.850652] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27955.850662] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27955.850673] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27955.850683] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27955.850693] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27955.850703] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27955.850713] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27955.850723] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27955.850733] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27955.850743] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27955.850753] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27955.850763] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27955.850773] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27955.850784] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27955.850794] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27955.850804] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27955.850814] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27955.850824] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27955.850834] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27955.850845] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27955.850854] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27955.850865] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27955.850869] iwlwifi 0000:04:00.0: FH register values:
> [27955.850905] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27955.850941] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27955.850977] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27955.851013] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27955.851049] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27955.851085] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27955.851121] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27955.851155] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27955.851191] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27955.851196] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27955.851202] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27955.851207] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27955.851217] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27955.852014] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27955.852227] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27955.852748] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.859562] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27955.894907] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27955.894915] iwlwifi 0000:04:00.0: CSR values:
> [27955.894920] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27955.894931] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27955.894941] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27955.894951] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27955.894962] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27955.894972] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27955.894982] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27955.894992] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27955.895003] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27955.895013] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27955.895023] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27955.895033] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27955.895043] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27955.895053] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27955.895063] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27955.895073] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27955.895083] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27955.895094] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27955.895104] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27955.895114] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27955.895124] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27955.895134] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27955.895144] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27955.895155] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27955.895159] iwlwifi 0000:04:00.0: FH register values:
> [27955.895195] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27955.895231] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27955.895267] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27955.895303] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27955.895339] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27955.895375] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27955.895486] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27955.895522] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27955.895556] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27955.895562] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27955.895567] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27955.895572] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27955.895584] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27955.896355] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27955.896467] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27955.898231] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.905040] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27955.940997] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27955.941005] iwlwifi 0000:04:00.0: CSR values:
> [27955.941010] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27955.941021] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27955.941031] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27955.941042] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27955.941052] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27955.941063] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27955.941073] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27955.941083] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27955.941093] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27955.941103] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27955.941114] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27955.941123] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27955.941133] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27955.941143] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27955.941153] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27955.941163] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27955.941173] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27955.941183] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27955.941193] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27955.941204] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27955.941214] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27955.941224] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27955.941235] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27955.941245] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27955.941249] iwlwifi 0000:04:00.0: FH register values:
> [27955.941286] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27955.941322] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27955.941358] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27955.941393] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27955.941430] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27955.941467] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27955.941503] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27955.941537] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27955.941573] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27955.941579] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27955.941584] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27955.941589] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27955.941599] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27955.942368] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27955.942490] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27955.942986] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.949802] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27955.985917] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27955.985925] iwlwifi 0000:04:00.0: CSR values:
> [27955.985930] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27955.985940] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27955.985950] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27955.985961] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27955.985971] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27955.985981] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27955.985991] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27955.986001] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27955.986012] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27955.986022] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27955.986032] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27955.986042] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27955.986053] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27955.986063] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27955.986073] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27955.986083] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27955.986093] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27955.986103] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27955.986113] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27955.986123] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27955.986133] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27955.986143] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27955.986153] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27955.986163] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27955.986167] iwlwifi 0000:04:00.0: FH register values:
> [27955.986204] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27955.986240] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27955.986276] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27955.986311] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27955.986346] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27955.986382] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27955.986416] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27955.986452] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27955.986488] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27955.986494] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27955.986499] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27955.986504] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27955.986514] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27955.987284] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27955.987405] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27955.989464] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27955.996204] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27956.032441] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27956.032449] iwlwifi 0000:04:00.0: CSR values:
> [27956.032454] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27956.032464] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27956.032475] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27956.032485] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27956.032495] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27956.032506] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27956.032516] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27956.032526] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27956.032536] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27956.032547] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27956.032557] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27956.032567] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27956.032577] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27956.032587] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27956.032597] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27956.032607] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27956.032617] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27956.032628] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27956.032638] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27956.032648] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27956.032658] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27956.032669] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27956.032679] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27956.032689] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27956.032693] iwlwifi 0000:04:00.0: FH register values:
> [27956.032729] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27956.032788] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27956.032823] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27956.032859] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27956.032896] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27956.032942] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27956.032982] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27956.033018] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27956.033054] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27956.033060] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27956.033065] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27956.033070] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27956.033079] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27956.033855] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27956.033976] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27956.034504] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27956.041325] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27956.077417] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27956.077425] iwlwifi 0000:04:00.0: CSR values:
> [27956.077430] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27956.077440] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27956.077451] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27956.077461] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27956.077471] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27956.077482] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27956.077492] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27956.077502] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27956.077512] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27956.077522] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27956.077533] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27956.077543] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27956.077553] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27956.077563] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27956.077573] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27956.077583] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27956.077593] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27956.077603] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27956.077613] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27956.077623] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27956.077634] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27956.077643] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27956.077654] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27956.077664] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27956.077668] iwlwifi 0000:04:00.0: FH register values:
> [27956.077704] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27956.077740] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27956.077776] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27956.077811] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27956.077847] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27956.077883] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27956.077919] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27956.077955] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27956.077990] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27956.077996] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27956.078001] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27956.078007] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27956.078017] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27956.078788] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27956.078909] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27956.080774] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27956.087572] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27956.123653] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27956.123661] iwlwifi 0000:04:00.0: CSR values:
> [27956.123666] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27956.123677] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27956.123687] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27956.123698] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27956.123708] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27956.123718] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27956.123728] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27956.123738] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27956.123748] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27956.123758] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27956.123768] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27956.123779] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27956.123789] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27956.123799] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27956.123809] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27956.123819] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27956.123830] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27956.123840] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27956.123850] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27956.123860] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27956.123870] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27956.123880] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27956.123890] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27956.123900] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27956.123905] iwlwifi 0000:04:00.0: FH register values:
> [27956.123941] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27956.123977] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27956.124012] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27956.124048] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27956.124084] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27956.124120] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27956.124156] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27956.124192] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27956.124298] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27956.124304] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27956.124309] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27956.124314] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27956.124325] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27956.125210] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27956.125368] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27956.126036] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27956.132826] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27956.168776] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27956.168784] iwlwifi 0000:04:00.0: CSR values:
> [27956.168788] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27956.168799] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27956.168809] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27956.168820] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27956.168830] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27956.168840] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27956.168850] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27956.168861] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27956.168870] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27956.168881] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27956.168890] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27956.168901] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27956.168911] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27956.168921] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27956.168931] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27956.168941] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27956.168951] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27956.168961] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27956.168971] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27956.168982] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27956.168992] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27956.169002] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27956.169012] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27956.169022] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27956.169027] iwlwifi 0000:04:00.0: FH register values:
> [27956.169063] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27956.169099] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27956.169135] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27956.169170] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27956.169205] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27956.169238] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27956.169274] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27956.169310] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27956.169346] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27956.169352] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27956.169357] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27956.169362] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27956.169372] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27956.170131] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27956.170229] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27956.171849] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27956.178610] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27956.213079] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27956.213087] iwlwifi 0000:04:00.0: CSR values:
> [27956.213091] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27956.213102] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27956.213112] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27956.213123] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27956.213133] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27956.213143] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27956.213153] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27956.213163] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27956.213174] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27956.213184] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27956.213194] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27956.213204] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27956.213214] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27956.213225] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27956.213234] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27956.213245] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27956.213255] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27956.213264] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27956.213274] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27956.213284] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27956.213295] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27956.213304] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27956.213315] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27956.213325] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27956.213329] iwlwifi 0000:04:00.0: FH register values:
> [27956.213365] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27956.213401] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27956.213436] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27956.213472] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27956.213507] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27956.213543] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27956.213579] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27956.213615] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27956.213649] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27956.213655] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27956.213660] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27956.213665] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27956.213675] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27956.214437] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27956.214543] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27956.214993] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27956.221802] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27956.257887] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27956.257894] iwlwifi 0000:04:00.0: CSR values:
> [27956.257899] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27956.257910] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27956.257920] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27956.257931] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27956.257941] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27956.257951] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27956.257961] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27956.257971] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27956.257981] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27956.257992] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27956.258001] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27956.258015] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27956.258025] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27956.258035] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27956.258045] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27956.258055] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27956.258065] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27956.258075] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27956.258085] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27956.258096] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27956.258106] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27956.258116] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27956.258126] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27956.258136] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27956.258140] iwlwifi 0000:04:00.0: FH register values:
> [27956.258176] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27956.258212] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27956.258248] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27956.258284] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27956.258318] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27956.258352] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27956.258388] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27956.258424] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27956.258460] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27956.258466] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27956.258471] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27956.258476] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27956.258486] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27956.259261] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27956.259383] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27956.261551] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27956.268321] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27956.302901] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27956.302909] iwlwifi 0000:04:00.0: CSR values:
> [27956.302914] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27956.302923] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27956.302934] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27956.302944] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27956.302954] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27956.302965] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27956.302975] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27956.302985] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27956.302996] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27956.303006] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27956.303016] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27956.303026] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27956.303036] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27956.303046] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27956.303055] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27956.303065] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27956.303075] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27956.303084] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27956.303094] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27956.303104] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27956.303114] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27956.303124] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27956.303134] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27956.303145] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27956.303149] iwlwifi 0000:04:00.0: FH register values:
> [27956.303183] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27956.303220] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27956.303255] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27956.303291] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27956.303326] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27956.303361] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27956.303397] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27956.303431] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27956.303467] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27956.303473] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27956.303478] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27956.303483] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27956.303493] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27956.304254] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27956.304361] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27956.304704] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27956.311476] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27956.347303] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27956.347308] iwlwifi 0000:04:00.0: CSR values:
> [27956.347311] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27956.347318] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27956.347327] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27956.347335] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27956.347343] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27956.347350] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27956.347358] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27956.347366] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27956.347374] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27956.347382] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27956.347390] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27956.347397] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27956.347405] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27956.347413] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27956.347421] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27956.347429] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27956.347436] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27956.347444] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27956.347452] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27956.347460] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27956.347468] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27956.347476] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27956.347484] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27956.347492] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27956.347494] iwlwifi 0000:04:00.0: FH register values:
> [27956.347526] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27956.347559] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27956.347593] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27956.347626] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27956.347659] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27956.347693] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27956.347726] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27956.347759] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27956.347792] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27956.347796] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27956.347799] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27956.347802] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27956.347807] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27956.348523] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27956.348681] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27956.350104] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27956.356911] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27956.391160] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27956.391168] iwlwifi 0000:04:00.0: CSR values:
> [27956.391173] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27956.391184] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27956.391194] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27956.391205] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27956.391215] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27956.391225] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27956.391235] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27956.391245] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27956.391256] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27956.391266] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27956.391276] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27956.391286] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27956.391296] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27956.391306] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27956.391317] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27956.391326] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27956.391337] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27956.391347] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27956.391357] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27956.391366] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27956.391377] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27956.391387] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27956.391397] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27956.391407] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27956.391412] iwlwifi 0000:04:00.0: FH register values:
> [27956.391446] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27956.391482] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27956.391519] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27956.391554] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27956.391588] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27956.391624] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27956.391660] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27956.391694] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27956.391730] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27956.391736] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27956.391741] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27956.391746] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27956.391757] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27956.392528] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27956.392723] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27956.393141] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27956.400001] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27956.435883] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27956.435891] iwlwifi 0000:04:00.0: CSR values:
> [27956.435896] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27956.435907] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27956.435918] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27956.435928] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27956.435938] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27956.435949] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27956.435959] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27956.435969] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27956.435979] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27956.435989] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27956.436000] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27956.436009] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27956.436020] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27956.436030] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27956.436040] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27956.436050] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27956.436060] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27956.436070] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27956.436081] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27956.436091] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27956.436101] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27956.436111] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27956.436122] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27956.436132] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27956.436136] iwlwifi 0000:04:00.0: FH register values:
> [27956.436171] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27956.436207] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27956.436242] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27956.436278] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27956.436314] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27956.436350] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27956.436386] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27956.436422] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27956.436458] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27956.436464] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27956.436469] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27956.436474] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27956.436485] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27956.437277] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27956.437412] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27956.439669] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27956.446494] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27956.482529] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27956.482537] iwlwifi 0000:04:00.0: CSR values:
> [27956.482542] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27956.482553] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27956.482564] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27956.482574] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27956.482584] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27956.482594] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27956.482605] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27956.482614] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27956.482625] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27956.482635] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27956.482645] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27956.482655] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27956.482665] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27956.482675] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27956.482686] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27956.482696] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27956.482706] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27956.482716] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27956.482726] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27956.482736] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27956.482746] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27956.482756] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27956.482766] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27956.482777] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27956.482781] iwlwifi 0000:04:00.0: FH register values:
> [27956.482817] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27956.482853] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27956.482887] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27956.482924] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27956.482959] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27956.482995] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27956.483031] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27956.483067] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27956.483103] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27956.483109] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27956.483114] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27956.483119] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27956.483129] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27956.483892] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27956.483991] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27956.484383] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27956.491161] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
> [27956.526340] iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x82000000.
> [27956.526344] iwlwifi 0000:04:00.0: CSR values:
> [27956.526346] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> [27956.526353] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X0048d704
> [27956.526360] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
> [27956.526367] iwlwifi 0000:04:00.0:                     CSR_INT: 0X80000000
> [27956.526374] iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
> [27956.526380] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X40010000
> [27956.526387] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X0000000f
> [27956.526394] iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
> [27956.526400] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
> [27956.526407] iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000074
> [27956.526414] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
> [27956.526421] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
> [27956.526427] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00020000
> [27956.526434] iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080046
> [27956.526441] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00000000
> [27956.526448] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000002
> [27956.526454] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> [27956.526461] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> [27956.526468] iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000018
> [27956.526474] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X00000000
> [27956.526481] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> [27956.526488] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00000000
> [27956.526495] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> [27956.526501] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> [27956.526503] iwlwifi 0000:04:00.0: FH register values:
> [27956.526535] iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X23082300
> [27956.526565] iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02318320
> [27956.526598] iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000f8
> [27956.526630] iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
> [27956.526662] iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> [27956.526694] iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> [27956.526727] iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [27956.526759] iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> [27956.526791] iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> [27956.526793] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1 build 25532
> [27956.526796] iwlwifi 0000:04:00.0: Not valid error log pointer 0x00000000 for Init uCode
> [27956.526798] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000 for Init uCode
> [27956.526802] iwlwifi 0000:04:00.0: BUG_ON, Stop restarting
> [27956.527658] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
> [27956.527756] iwlwifi 0000:04:00.0: Unable to initialize device.
> [27956.529172] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [27956.535907] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1


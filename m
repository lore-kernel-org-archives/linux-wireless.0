Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bob.fi ([81.209.35.21]:54242 "EHLO mail.bob.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600AbaBOVhH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Feb 2014 16:37:07 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.bob.fi (Postfix) with ESMTP id 5213DF2514C
	for <linux-wireless@vger.kernel.org>; Sat, 15 Feb 2014 23:28:50 +0200 (EET)
Received: from mail.bob.fi ([127.0.0.1])
	by localhost (mail.bob.fi [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ItFSHIJWJ8+X for <linux-wireless@vger.kernel.org>;
	Sat, 15 Feb 2014 23:28:49 +0200 (EET)
Received: from [172.16.24.137] (unknown [85.134.53.65])
	by mail.bob.fi (Postfix) with ESMTP id A6A43F24D06
	for <linux-wireless@vger.kernel.org>; Sat, 15 Feb 2014 23:28:48 +0200 (EET)
Message-ID: <52FFDC10.5020702@mageia.org> (sfid-20140215_223803_080757_931D15C8)
Date: Sat, 15 Feb 2014 23:28:48 +0200
From: Thomas Backlund <tmb@mageia.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Intel Wireless 7260 AC firnware SW error
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Is this known ?


This happend when rsyncing an 4GB iso file,
(but it does not happend every time I sync)


AP is a ASUS RT-AC68U.

Connection is 5GHz band, secured with WPA2-AES


Kernel is: 3.13.3

Hardware:
03:00.0 Network controller [0280]: Intel Corporation Wireless 7260 
[8086:08b1] (rev 73)


dmesg showing firmware revision:

[   13.290105] Intel(R) Wireless WiFi driver for Linux, in-tree:d
[   13.290108] Copyright(c) 2003-2013 Intel Corporation
[   13.290347] iwlwifi 0000:03:00.0: irq 49 for MSI/MSI-X
[   13.299469] iwlwifi 0000:03:00.0: loaded firmware version 22.15.8.0 
op_mode iwlmvm


SW error output:

[  226.928031] iwlwifi 0000:03:00.0: Microcode SW error detected. 
Restarting 0x2000000.
[  226.928039] iwlwifi 0000:03:00.0: CSR values:
[  226.928042] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is 
CSR_INT_PERIODIC_REG)
[  226.928058] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00489204
[  226.928071] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X8000ff40
[  226.928085] iwlwifi 0000:03:00.0:                     CSR_INT: 0X00000000
[  226.928099] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[  226.928113] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X00000000
[  226.928127] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[  226.928141] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
[  226.928155] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[  226.928170] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X00000144
[  226.928183] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0X00000000
[  226.928197] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X80000000
[  226.928212] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X803a0000
[  226.928225] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080042
[  226.928239] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
[  226.928253] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[  226.928267] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[  226.928281] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[  226.928295] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000060
[  226.928309] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X88253c13
[  226.928323] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[  226.928337] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
[  226.928351] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[  226.928365] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
[  226.928368] iwlwifi 0000:03:00.0: FH register values:
[  226.928392] iwlwifi 0000:03:00.0: 
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X25352000
[  226.928414] iwlwifi 0000:03:00.0: 
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X02535210
[  226.928430] iwlwifi 0000:03:00.0: 
FH_RSCSR_CHNL0_WPTR: 0X00000000
[  226.928445] iwlwifi 0000:03:00.0: 
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
[  226.928467] iwlwifi 0000:03:00.0: 
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[  226.928489] iwlwifi 0000:03:00.0: 
FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[  226.928503] iwlwifi 0000:03:00.0: 
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[  226.928540] iwlwifi 0000:03:00.0: 
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[  226.928567] iwlwifi 0000:03:00.0: 
FH_TSSR_TX_ERROR_REG: 0X00000000
[  226.928710] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
[  226.928716] iwlwifi 0000:03:00.0: Status: 0x00000000, count: 6
[  226.928722] iwlwifi 0000:03:00.0: 0x00002B03 | ADVANCED_SYSASSERT 

[  226.928726] iwlwifi 0000:03:00.0: 0x002002A0 | uPc
[  226.928730] iwlwifi 0000:03:00.0: 0x00000000 | branchlink1
[  226.928734] iwlwifi 0000:03:00.0: 0x00000C2A | branchlink2
[  226.928738] iwlwifi 0000:03:00.0: 0x00015ADC | interruptlink1
[  226.928742] iwlwifi 0000:03:00.0: 0x0099FB23 | interruptlink2
[  226.928747] iwlwifi 0000:03:00.0: 0x00000000 | data1
[  226.928751] iwlwifi 0000:03:00.0: 0xDEADBEEF | data2
[  226.928755] iwlwifi 0000:03:00.0: 0xDEADBEEF | data3
[  226.928759] iwlwifi 0000:03:00.0: 0xAC40CA17 | beacon time
[  226.928763] iwlwifi 0000:03:00.0: 0xB42716FE | tsf low
[  226.928768] iwlwifi 0000:03:00.0: 0x0000000C | tsf hi
[  226.928772] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[  226.928776] iwlwifi 0000:03:00.0: 0x0C746956 | time gp2
[  226.928780] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
[  226.928783] iwlwifi 0000:03:00.0: 0x0004160F | uCode version
[  226.928788] iwlwifi 0000:03:00.0: 0x00000144 | hw version
[  226.928792] iwlwifi 0000:03:00.0: 0x00489204 | board version
[  226.928797] iwlwifi 0000:03:00.0: 0x09970051 | hcmd
[  226.928801] iwlwifi 0000:03:00.0: 0x00022000 | isr0
[  226.928805] iwlwifi 0000:03:00.0: 0x00000000 | isr1
[  226.928809] iwlwifi 0000:03:00.0: 0x0000000A | isr2
[  226.928813] iwlwifi 0000:03:00.0: 0x4041F8C0 | isr3
[  226.928817] iwlwifi 0000:03:00.0: 0x00000001 | isr4
[  226.928820] iwlwifi 0000:03:00.0: 0x00800110 | isr_pref
[  226.928824] iwlwifi 0000:03:00.0: 0x00000000 | wait_event
[  226.928828] iwlwifi 0000:03:00.0: 0x00000080 | l2p_control
[  226.928832] iwlwifi 0000:03:00.0: 0x00018000 | l2p_duration
[  226.928836] iwlwifi 0000:03:00.0: 0x0000003F | l2p_mhvalid
[  226.928839] iwlwifi 0000:03:00.0: 0x00000080 | l2p_addr_match
[  226.928843] iwlwifi 0000:03:00.0: 0x00000005 | lmpm_pmg_sel
[  226.928846] iwlwifi 0000:03:00.0: 0x22121614 | timestamp
[  226.928850] iwlwifi 0000:03:00.0: 0x00000008 | flow_handler
[  226.928857] ieee80211 phy0: Hardware restart was requested


--

Thomas

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:36357 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbbEaG3Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 02:29:24 -0400
Received: by lagv1 with SMTP id v1so81391489lag.3
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2015 23:29:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150529200405.GA27272@light.dominikbrodowski.net>
References: <20150525181043.GA10755@light.dominikbrodowski.net>
	<CANUX_P0+oGdKvY360xSekCmZjZFpe7PMS+shC9==-G-A-1O3sw@mail.gmail.com>
	<20150525184047.GA12142@light.dominikbrodowski.net>
	<20150529200405.GA27272@light.dominikbrodowski.net>
Date: Sun, 31 May 2015 09:29:22 +0300
Message-ID: <CANUX_P0M1shWOhjJLqN+2vj3iTYXvSY678QGa=203x+60raRAg@mail.gmail.com> (sfid-20150531_082928_235248_AA814183)
Subject: Re: iwlwifi: Queue 16 stuck for 10000 ms - Microcode SW error detected.
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> No joy. Firmware 25.27.13.0 also is not happy at times:

Are you using 40Mhz or 20Mhz?

>
> iwlwifi 0000:02:00.0: invalid BA notification: Q 16, tid 0, flow 65535
> iwlwifi 0000:02:00.0: invalid BA notification: Q 16, tid 0, flow 65535
> iwlwifi 0000:02:00.0: invalid BA notification: Q 16, tid 0, flow 65535
> iwlwifi 0000:02:00.0: Queue 2 stuck for 10000 ms.
> iwlwifi 0000:02:00.0: Current SW read_ptr 36 write_ptr 67
> iwl data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> iwlwifi 0000:02:00.0: FH TRBs(0) = 0x00000000
> iwlwifi 0000:02:00.0: FH TRBs(1) = 0xc01100b8
> iwlwifi 0000:02:00.0: FH TRBs(2) = 0x00000000
> iwlwifi 0000:02:00.0: FH TRBs(3) = 0x80300008
> iwlwifi 0000:02:00.0: FH TRBs(4) = 0x00000000
> iwlwifi 0000:02:00.0: FH TRBs(5) = 0x00000000
> iwlwifi 0000:02:00.0: FH TRBs(6) = 0x00000000
> iwlwifi 0000:02:00.0: FH TRBs(7) = 0x0070904c
> iwlwifi 0000:02:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [9,9]
> iwlwifi 0000:02:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [36,67]
> iwlwifi 0000:02:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 8 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [77,77]
> iwlwifi 0000:02:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 16 is active and mapped to fifo 1 ra_tid 0x0000 [169,230]
> iwlwifi 0000:02:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Microcode SW error detected.  Restarting 0x2000000.
> iwlwifi 0000:02:00.0: CSR values:
> iwlwifi 0000:02:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> iwlwifi 0000:02:00.0:        CSR_HW_IF_CONFIG_REG: 0X40489204
> iwlwifi 0000:02:00.0:          CSR_INT_COALESCING: 0X80000040
> iwlwifi 0000:02:00.0:                     CSR_INT: 0X00000000
> iwlwifi 0000:02:00.0:                CSR_INT_MASK: 0X00000000
> iwlwifi 0000:02:00.0:           CSR_FH_INT_STATUS: 0X00000000
> iwlwifi 0000:02:00.0:                 CSR_GPIO_IN: 0X00000000
> iwlwifi 0000:02:00.0:                   CSR_RESET: 0X00000000
> iwlwifi 0000:02:00.0:                CSR_GP_CNTRL: 0X080403c5
> iwlwifi 0000:02:00.0:                  CSR_HW_REV: 0X00000144
> iwlwifi 0000:02:00.0:              CSR_EEPROM_REG: 0X00000000
> iwlwifi 0000:02:00.0:               CSR_EEPROM_GP: 0X80000000
> iwlwifi 0000:02:00.0:              CSR_OTP_GP_REG: 0X803a0000
> iwlwifi 0000:02:00.0:                 CSR_GIO_REG: 0X00080040
> iwlwifi 0000:02:00.0:            CSR_GP_UCODE_REG: 0X00000000
> iwlwifi 0000:02:00.0:           CSR_GP_DRIVER_REG: 0X00000000
> iwlwifi 0000:02:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> iwlwifi 0000:02:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> iwlwifi 0000:02:00.0:                 CSR_LED_REG: 0X00000060
> iwlwifi 0000:02:00.0:        CSR_DRAM_INT_TBL_REG: 0X8821408c
> iwlwifi 0000:02:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> iwlwifi 0000:02:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
> iwlwifi 0000:02:00.0:      CSR_MONITOR_STATUS_REG: 0X3c08019d
> iwlwifi 0000:02:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> iwlwifi 0000:02:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
> iwlwifi 0000:02:00.0: FH register values:
> iwlwifi 0000:02:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X0d9f3000
> iwlwifi 0000:02:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00d9f2f0
> iwlwifi 0000:02:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000e0
> iwlwifi 0000:02:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
> iwlwifi 0000:02:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> iwlwifi 0000:02:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
> iwlwifi 0000:02:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> iwlwifi 0000:02:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> iwlwifi 0000:02:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> iwlwifi 0000:02:00.0: Start IWL Error Log Dump:
> iwlwifi 0000:02:00.0: Status: 0x00000000, count: 6
> iwlwifi 0000:02:00.0: Loaded firmware version: 25.27.13.0
> iwlwifi 0000:02:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN
> iwlwifi 0000:02:00.0: 0x00A002F0 | uPc
> iwlwifi 0000:02:00.0: 0x00000000 | branchlink1
> iwlwifi 0000:02:00.0: 0x00000B2E | branchlink2
> iwlwifi 0000:02:00.0: 0x00016218 | interruptlink1
> iwlwifi 0000:02:00.0: 0x00016218 | interruptlink2
> iwlwifi 0000:02:00.0: 0x00000000 | data1
> iwlwifi 0000:02:00.0: 0x00000080 | data2
> iwlwifi 0000:02:00.0: 0x07030000 | data3
> iwlwifi 0000:02:00.0: 0xC600F06D | beacon time
> iwlwifi 0000:02:00.0: 0x95A5CF83 | tsf low
> iwlwifi 0000:02:00.0: 0x00000003 | tsf hi
> iwlwifi 0000:02:00.0: 0x00000000 | time gp1
> iwlwifi 0000:02:00.0: 0x164C8D06 | time gp2
> iwlwifi 0000:02:00.0: 0x00000000 | time gp3
> iwlwifi 0000:02:00.0: 0x0004191B | uCode version
> iwlwifi 0000:02:00.0: 0x00000144 | hw version
> iwlwifi 0000:02:00.0: 0x40489204 | board version
> iwlwifi 0000:02:00.0: 0x10A9001C | hcmd
> iwlwifi 0000:02:00.0: 0x00022002 | isr0
> iwlwifi 0000:02:00.0: 0x01800000 | isr1
> iwlwifi 0000:02:00.0: 0x0000000A | isr2
> iwlwifi 0000:02:00.0: 0x004174C0 | isr3
> iwlwifi 0000:02:00.0: 0x00000000 | isr4
> iwlwifi 0000:02:00.0: 0x00000110 | isr_pref
> iwlwifi 0000:02:00.0: 0x00000000 | wait_event
> iwlwifi 0000:02:00.0: 0x0000024D | l2p_control
> iwlwifi 0000:02:00.0: 0x00000020 | l2p_duration
> iwlwifi 0000:02:00.0: 0x00000003 | l2p_mhvalid
> iwlwifi 0000:02:00.0: 0x000000EE | l2p_addr_match
> iwlwifi 0000:02:00.0: 0x00000005 | lmpm_pmg_sel
> iwlwifi 0000:02:00.0: 0x21051936 | timestamp
> iwlwifi 0000:02:00.0: 0x0034E0E8 | flow_handler
> ieee80211 phy0: Hardware restart was requested
> iwlwifi 0000:02:00.0: L1 Enabled - LTR Disabled
> iwlwifi 0000:02:00.0: L1 Enabled - LTR Disabled
> iwlwifi 0000:02:00.0: L1 Enabled - LTR Disabled
> iwlwifi 0000:02:00.0: L1 Enabled - LTR Disabled
>
> Best,
>         Dominik

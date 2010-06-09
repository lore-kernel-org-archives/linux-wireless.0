Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:33482 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757107Ab0FIQ6N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 12:58:13 -0400
Subject: Re: iwlagn fails to assoc with nexus one in ad-hoc mode
From: reinette chatre <reinette.chatre@intel.com>
To: David Miller <davem@davemloft.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100607.214612.26938385.davem@davemloft.net>
References: <20100607.214612.26938385.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 09:58:12 -0700
Message-ID: <1276102692.1835.14610.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

On Mon, 2010-06-07 at 21:46 -0700, David Miller wrote:
> When I try to associate the wireless activity light blinks like
> crazy and I get kernel log dumps like the one at the end of
> this email.

Which hardware are you using? This information is needed to decode the
firmware assert you are posting.

> 
> The nexus one uses a Broadcom BCM4328 for wireless.
> 
> Windows 7 users report the same problem with Intel wireless, and that
> upgrading to the Intel wireless windows driver, version 13.1.1.1,
> fixes the problem.

Any idea what they upgraded _from_ ?


> For example, see here:
> 
> http://code.google.com/p/android-wifi-tether/issues/detail?id=244
> 
> Can we make sure whatever got fixed in the windows driver propagates
> into our Linux drivers too? :-)
> 
> Thanks!
> 
> --------------------
> iwlagn 0000:03:00.0: Microcode SW error detected.  Restarting 0x2000000.
> iwlagn 0000:03:00.0: Start IWL Error Log Dump:
> iwlagn 0000:03:00.0: Status: 0x000212E4, count: 5
> iwlagn 0000:03:00.0: Desc                               Time       data1      data2      line
> iwlagn 0000:03:00.0: SYSASSERT                    (#05) 0010614736 0x00000080 0x00000010 854
> iwlagn 0000:03:00.0: blink1  blink2  ilink1  ilink2
> iwlagn 0000:03:00.0: 0x03870 0x03870 0x008B2 0x00000
> iwlagn 0000:03:00.0: CSR values:
> iwlagn 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> iwlagn 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00480302
> iwlagn 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
> iwlagn 0000:03:00.0:                     CSR_INT: 0X00000000
> iwlagn 0000:03:00.0:                CSR_INT_MASK: 0X00000000
> iwlagn 0000:03:00.0:           CSR_FH_INT_STATUS: 0X00000000
> iwlagn 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
> iwlagn 0000:03:00.0:                   CSR_RESET: 0X00000000
> iwlagn 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
> iwlagn 0000:03:00.0:                  CSR_HW_REV: 0X00000024
> iwlagn 0000:03:00.0:              CSR_EEPROM_REG: 0X00000000
> iwlagn 0000:03:00.0:               CSR_EEPROM_GP: 0X90000004
> iwlagn 0000:03:00.0:              CSR_OTP_GP_REG: 0X00060000
> iwlagn 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
> iwlagn 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000029
> iwlagn 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
> iwlagn 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> iwlagn 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> iwlagn 0000:03:00.0:                 CSR_LED_REG: 0X00000078
> iwlagn 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X88034db0
> iwlagn 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> iwlagn 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00880300
> iwlagn 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> iwlagn 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> iwlagn 0000:03:00.0: FH register values:
> iwlagn 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X034c7900
> iwlagn 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X0034ccc0
> iwlagn 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000040
> iwlagn 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
> iwlagn 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> iwlagn 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
> iwlagn 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> iwlagn 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> iwlagn 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> iwlagn 0000:03:00.0: Start IWL Event Log Dump: display last 20 entries
> iwlagn 0000:03:00.0: EVT_LOGT:0000054936:0x00000001:0353
> iwlagn 0000:03:00.0: EVT_LOGT:0000054953:0x0000010f:0106
> iwlagn 0000:03:00.0: EVT_LOGT:0000054955:0x00000000:0301
> iwlagn 0000:03:00.0: EVT_LOGT:0000055026:0x0000000d:0353
> iwlagn 0000:03:00.0: EVT_LOGT:0000055037:0x00000000:0302
> iwlagn 0000:03:00.0: EVT_LOGT:0000055057:0x00000c1d:0352
> iwlagn 0000:03:00.0: EVT_LOGT:0000055058:0x00000002:0353
> iwlagn 0000:03:00.0: EVT_LOGT:0000055070:0x00000000:0302
> iwlagn 0000:03:00.0: EVT_LOGT:0000055094:0x00000d48:0352
> iwlagn 0000:03:00.0: EVT_LOGT:0000055095:0x00000003:0353
> iwlagn 0000:03:00.0: EVT_LOGT:0000055157:0x0000010f:0106
> iwlagn 0000:03:00.0: EVT_LOGT:0000055159:0x00000000:0302
> iwlagn 0000:03:00.0: EVT_LOGT:0000055171:0x00002000:0350
> iwlagn 0000:03:00.0: EVT_LOGT:0000079297:0x0000010f:0106
> iwlagn 0000:03:00.0: EVT_LOGT:0000079299:0x00000000:0301
> iwlagn 0000:03:00.0: EVT_LOGT:0000079679:0x00000080:0313
> iwlagn 0000:03:00.0: EVT_LOGT:0000079681:0x000005b4:0501
> iwlagn 0000:03:00.0: EVT_LOGT:0000081109:0x00000000:0356
> iwlagn 0000:03:00.0: EVT_LOGT:0000081141:0x000002ef:0501
> iwlagn 0000:03:00.0: EVT_LOGT:0000081150:0x00000000:0125
> iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> iwlagn 0000:03:00.0: index 0 already used in uCode key table.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



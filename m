Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64065 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758513Ab2EUU5w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 May 2012 16:57:52 -0400
Received: by pbbrp8 with SMTP id rp8so7424328pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2012 13:57:51 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 21 May 2012 16:57:51 -0400
Message-ID: <CALGY4ftQK3-T=jWq4xW+0PYMJe9j8fwwgHVr4wd9orUrK322Og@mail.gmail.com> (sfid-20120521_225756_258794_171238BC)
Subject: iwlwifi ucode error
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

  Intel 5300 fails with microcode error after ~1min of heavy
downloading (9-10MBit/s, downloading two files in parallel via samba).
  I have 3.4.0 from ubuntu kernel ppa. I also saw this error on
3.4rc6, but I didn't see it before, although I have to admit I didn't
try to download two files in parallel before.
  Error log follows. Please let me know if I can provide any more
information or help with debug in any way. Thanks.

[ 1158.254500] iwlwifi 0000:0b:00.0: Microcode SW error detected.
Restarting 0x82000000.
[ 1158.254511] iwlwifi 0000:0b:00.0: Loaded firmware version: 8.83.5.1
build 33692
[ 1158.257501] iwlwifi 0000:0b:00.0: Start IWL Error Log Dump:
[ 1158.257508] iwlwifi 0000:0b:00.0: Status: 0x00000000, count: 5
[ 1158.257515] iwlwifi 0000:0b:00.0: 0x0000000C | FH_ERROR
[ 1158.257521] iwlwifi 0000:0b:00.0: 0x000006E4 | uPc
[ 1158.257526] iwlwifi 0000:0b:00.0: 0x000005AA | branchlink1
[ 1158.257531] iwlwifi 0000:0b:00.0: 0x00000820 | branchlink2
[ 1158.257537] iwlwifi 0000:0b:00.0: 0x00000916 | interruptlink1
[ 1158.257542] iwlwifi 0000:0b:00.0: 0x000027A2 | interruptlink2
[ 1158.257548] iwlwifi 0000:0b:00.0: 0x00000020 | data1
[ 1158.257553] iwlwifi 0000:0b:00.0: 0x03530000 | data2
[ 1158.257558] iwlwifi 0000:0b:00.0: 0x0000B820 | line
[ 1158.257563] iwlwifi 0000:0b:00.0: 0x8500DF2E | beacon time
[ 1158.257569] iwlwifi 0000:0b:00.0: 0x81DF40D2 | tsf low
[ 1158.257574] iwlwifi 0000:0b:00.0: 0x00000005 | tsf hi
[ 1158.257579] iwlwifi 0000:0b:00.0: 0x0000DECC | time gp1
[ 1158.257584] iwlwifi 0000:0b:00.0: 0x1CDB6A2A | time gp2
[ 1158.257589] iwlwifi 0000:0b:00.0: 0x00000000 | time gp3
[ 1158.257594] iwlwifi 0000:0b:00.0: 0x00010853 | uCode version
[ 1158.257600] iwlwifi 0000:0b:00.0: 0x00000024 | hw version
[ 1158.257605] iwlwifi 0000:0b:00.0: 0x00480302 | board version
[ 1158.257610] iwlwifi 0000:0b:00.0: 0x0B29001C | hcmd
[ 1158.257615] iwlwifi 0000:0b:00.0: 0xAF873802 | isr0
[ 1158.257620] iwlwifi 0000:0b:00.0: 0x0141E000 | isr1
[ 1158.257626] iwlwifi 0000:0b:00.0: 0x0000011A | isr2
[ 1158.257631] iwlwifi 0000:0b:00.0: 0x004338C0 | isr3
[ 1158.257636] iwlwifi 0000:0b:00.0: 0x00000110 | isr4
[ 1158.257641] iwlwifi 0000:0b:00.0: 0x0000B820 | isr_pref
[ 1158.257646] iwlwifi 0000:0b:00.0: 0x00004A88 | wait_event
[ 1158.257651] iwlwifi 0000:0b:00.0: 0x0000002C | l2p_control
[ 1158.257656] iwlwifi 0000:0b:00.0: 0x000003BF | l2p_duration
[ 1158.257661] iwlwifi 0000:0b:00.0: 0x001054F7 | l2p_mhvalid
[ 1158.257666] iwlwifi 0000:0b:00.0: 0x00000015 | l2p_addr_match
[ 1158.257672] iwlwifi 0000:0b:00.0: 0x02121704 | lmpm_pmg_sel
[ 1158.257677] iwlwifi 0000:0b:00.0: 0x0034C0D8 | timestamp
[ 1158.257682] iwlwifi 0000:0b:00.0: 0x00000100 | flow_handler
[ 1158.257687] iwlwifi 0000:0b:00.0: CSR values:
[ 1158.257692] iwlwifi 0000:0b:00.0: (2nd byte of CSR_INT_COALESCING
is CSR_INT_PERIODIC_REG)
[ 1158.257723] iwlwifi 0000:0b:00.0:        CSR_HW_IF_CONFIG_REG: 0X00480302
[ 1158.257751] iwlwifi 0000:0b:00.0:          CSR_INT_COALESCING: 0X0000ff40
[ 1158.257780] iwlwifi 0000:0b:00.0:                     CSR_INT: 0X00000000
[ 1158.257808] iwlwifi 0000:0b:00.0:                CSR_INT_MASK: 0X00000000
[ 1158.257835] iwlwifi 0000:0b:00.0:           CSR_FH_INT_STATUS: 0X00000000
[ 1158.257863] iwlwifi 0000:0b:00.0:                 CSR_GPIO_IN: 0X00000000
[ 1158.257891] iwlwifi 0000:0b:00.0:                   CSR_RESET: 0X00000000
[ 1158.257919] iwlwifi 0000:0b:00.0:                CSR_GP_CNTRL: 0X080403c5
[ 1158.257948] iwlwifi 0000:0b:00.0:                  CSR_HW_REV: 0X00000024
[ 1158.258218] iwlwifi 0000:0b:00.0:              CSR_EEPROM_REG: 0X00000000
[ 1158.258443] iwlwifi 0000:0b:00.0:               CSR_EEPROM_GP: 0X90000004
[ 1158.258501] iwlwifi 0000:0b:00.0:              CSR_OTP_GP_REG: 0X00060000
[ 1158.258569] iwlwifi 0000:0b:00.0:                 CSR_GIO_REG: 0X00080042
[ 1158.258598] iwlwifi 0000:0b:00.0:            CSR_GP_UCODE_REG: 0X00009259
[ 1158.258626] iwlwifi 0000:0b:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[ 1158.258654] iwlwifi 0000:0b:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[ 1158.258682] iwlwifi 0000:0b:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[ 1158.258711] iwlwifi 0000:0b:00.0:                 CSR_LED_REG: 0X00000078
[ 1158.258740] iwlwifi 0000:0b:00.0:        CSR_DRAM_INT_TBL_REG: 0X88033bc3
[ 1158.258768] iwlwifi 0000:0b:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[ 1158.258796] iwlwifi 0000:0b:00.0:             CSR_ANA_PLL_CFG: 0X00000000
[ 1158.258825] iwlwifi 0000:0b:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[ 1158.258853] iwlwifi 0000:0b:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[ 1158.258859] iwlwifi 0000:0b:00.0: FH register values:
[ 1158.258920] iwlwifi 0000:0b:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X036d2700
[ 1158.258980] iwlwifi 0000:0b:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X0036e980
[ 1158.259026] iwlwifi 0000:0b:00.0:
FH_RSCSR_CHNL0_WPTR: 0X000000c0
[ 1158.259122] iwlwifi 0000:0b:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00819104
[ 1158.259391] iwlwifi 0000:0b:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[ 1158.259513] iwlwifi 0000:0b:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X03530000
[ 1158.259728] iwlwifi 0000:0b:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[ 1158.259987] iwlwifi 0000:0b:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[ 1158.260044] iwlwifi 0000:0b:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[ 1158.260157] iwlwifi 0000:0b:00.0: Start IWL Event Log Dump: display
last 20 entries
[ 1158.260220] iwlwifi 0000:0b:00.0: EVT_LOGT:0484139149:0x00000000:1352
[ 1158.260255] iwlwifi 0000:0b:00.0: EVT_LOGT:0484139150:0x00000002:1353
[ 1158.260291] iwlwifi 0000:0b:00.0: EVT_LOGT:0484139390:0x00000044:0355
[ 1158.260326] iwlwifi 0000:0b:00.0: EVT_LOGT:0484140591:0x00000113:0106
[ 1158.260361] iwlwifi 0000:0b:00.0: EVT_LOGT:0484140592:0x00000000:0302
[ 1158.260396] iwlwifi 0000:0b:00.0: EVT_LOGT:0484140619:0x00000440:0323
[ 1158.260431] iwlwifi 0000:0b:00.0: EVT_LOGT:0484140623:0x00000000:0355
[ 1158.260466] iwlwifi 0000:0b:00.0: EVT_LOGT:0484140624:0x00000480:0367
[ 1158.260501] iwlwifi 0000:0b:00.0: EVT_LOGT:0484141508:0x0b28001c:0206
[ 1158.260550] iwlwifi 0000:0b:00.0: EVT_LOGT:0484141510:0x00000001:0204
[ 1158.260585] iwlwifi 0000:0b:00.0: EVT_LOGT:0484141512:0x01102100:0209
[ 1158.260633] iwlwifi 0000:0b:00.0: EVT_LOGT:0484141537:0x00000000:0210
[ 1158.260682] iwlwifi 0000:0b:00.0: EVT_LOGT:0484141553:0x00000000:0207
[ 1158.260717] iwlwifi 0000:0b:00.0: EVT_LOGT:0484141555:0x2b110000:0227
[ 1158.260766] iwlwifi 0000:0b:00.0: EVT_LOGT:0484141556:0xc0200218:0228
[ 1158.260801] iwlwifi 0000:0b:00.0: EVT_LOGT:0484141560:0x1cdb69f8:1586
[ 1158.260842] iwlwifi 0000:0b:00.0: EVT_LOGT:0484141566:0x1cdb69fe:1587
[ 1158.260882] iwlwifi 0000:0b:00.0: EVT_LOGT:0484141583:0x00000000:0264
[ 1158.260922] iwlwifi 0000:0b:00.0: EVT_LOGT:0484141594:0x000000d7:0123
[ 1158.260962] iwlwifi 0000:0b:00.0: EVT_LOGT:0484141633:0x00000000:0125
[ 1158.262498] ieee80211 phy0: Hardware restart was requested
[ 1158.262597] iwlwifi 0000:0b:00.0: L1 Enabled; Disabling L0S
[ 1158.265664] iwlwifi 0000:0b:00.0: Radio type=0x0-0x2-0x0


-- 
Truthfully yours,
Martynov Nikolay.
Email: mar.kolya@gmail.com

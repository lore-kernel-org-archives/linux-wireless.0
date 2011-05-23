Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:43185 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab1EWLpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 07:45:13 -0400
Subject: [iwl4965] Microcode SW error detected
From: Paul Bolle <pebolle@tiscali.nl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 13:45:06 +0200
Message-ID: <1306151106.2066.60.camel@x61.thuisdomein> (sfid-20110523_134520_626273_900F7E84)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

0) Since I started running (release candidates of) kernel v2.6.39 errors
like these show up in my log, every now and then:

iwl4965 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
iwl4965 0000:03:00.0: Loaded firmware version: 228.61.2.24
iwl4965 0000:03:00.0: Start IWL Error Log Dump:
iwl4965 0000:03:00.0: Status: 0x000213E4, count: 5
iwl4965 0000:03:00.0: Desc                                  Time       data1      data2      line
iwl4965 0000:03:00.0: FH_ERROR                     (0x000C) 1821446380 0x00000008 0x03130000 208 
iwl4965 0000:03:00.0: pc      blink1  blink2  ilink1  ilink2  hcmd
iwl4965 0000:03:00.0: 0x0046C 0x04A46 0x004C2 0x006DA 0x04A46 0x4C700A8
iwl4965 0000:03:00.0: FH register values:
iwl4965 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X132a9b00
iwl4965 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01329ed0
iwl4965 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X000000d8
iwl4965 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00819000
iwl4965 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X0000003c
iwl4965 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03130000
iwl4965 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
iwl4965 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0002
iwl4965 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
iwl4965 0000:03:00.0: Start IWL Event Log Dump: display last 20 entries
iwl4965 0000:03:00.0: EVT_LOGT:1821445332:0x00000000:1352
iwl4965 0000:03:00.0: EVT_LOGT:1821445332:0x00000001:1353
iwl4965 0000:03:00.0: EVT_LOGT:1821445336:0x0000000c:0357
iwl4965 0000:03:00.0: EVT_LOGT:1821445533:0x00000107:0106
iwl4965 0000:03:00.0: EVT_LOGT:1821445534:0x00000000:0302
iwl4965 0000:03:00.0: EVT_LOGT:1821445574:0x000000d4:0321
iwl4965 0000:03:00.0: EVT_LOGT:1821445575:0x00000000:1350
iwl4965 0000:03:00.0: EVT_LOGT:1821445576:0x00000000:1351
iwl4965 0000:03:00.0: EVT_LOGT:1821445576:0x00000000:1352
iwl4965 0000:03:00.0: EVT_LOGT:1821445577:0x00000001:1353
iwl4965 0000:03:00.0: EVT_LOGT:1821445581:0x0000000d:0357
iwl4965 0000:03:00.0: EVT_LOGT:1821446327:0x00000107:0106
iwl4965 0000:03:00.0: EVT_LOGT:1821446328:0x00000000:0302
iwl4965 0000:03:00.0: EVT_LOGT:1821446368:0x000000d4:0321
iwl4965 0000:03:00.0: EVT_LOGT:1821446369:0x00000000:1350
iwl4965 0000:03:00.0: EVT_LOGT:1821446370:0x00000000:1351
iwl4965 0000:03:00.0: EVT_LOGT:1821446370:0x00000000:1352
iwl4965 0000:03:00.0: EVT_LOGT:1821446371:0x00000001:1353
iwl4965 0000:03:00.0: EVT_LOGT:1821446375:0x0000000e:0357
iwl4965 0000:03:00.0: EVT_LOGT:1821446383:0x00000000:0125
ieee80211 phy0: Hardware restart was requested

1) Is there anything I'm supposed to do to (help) make these errors go
away?


Paul Bolle


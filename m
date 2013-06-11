Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eazy.amigager.de ([213.239.192.238]:60660 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab3FKSzG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 14:55:06 -0400
Received: from x61.home (mnch-5d872e8d.pool.mediaWays.net [93.135.46.141])
	by eazy.amigager.de (Postfix) with ESMTPA id B314BC8C0C9
	for <linux-wireless@vger.kernel.org>; Tue, 11 Jun 2013 20:55:05 +0200 (CEST)
Date: Tue, 11 Jun 2013 20:55:03 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Pedro Francisco <pedrogfrancisco@gmail.com>,
	ML linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Power saving features for iwl4965
Message-ID: <20130611185503.GB8751@x61.home> (sfid-20130611_205511_290207_159D2C81)
References: <20120418203543.GA16000@x61.home>
 <20120425122554.GD2466@redhat.com>
 <20120503182853.GA12461@mac.home>
 <20121226185425.GA12627@x61.home>
 <20130107110759.GC6931@redhat.com>
 <20130603085239.GA26920@mac.home>
 <20130603141804.GA2146@redhat.com>
 <CAJZjf_xoCOTFsLAB29uLKeW7+O+k255Amspn6GKFMysc7CTsBg@mail.gmail.com>
 <CAJZjf_xGdvStOG0=FR2+2WsVcjyizQukH+RxysZf8f9-Tk9L9w@mail.gmail.com>
 <20130611161924.GB1696@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130611161924.GB1696@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

in my kernel log, I also see a SYSASSERT, but only once after resume
from suspend to RAM.

2013-06-11_18:40:58.80553 kern.notice: sd 0:0:0:0: [sda] Starting disk
2013-06-11_18:40:58.80554 kern.err: iwl4965 0000:03:00.0: Microcode SW
error detected.  Restarting 0x82000000.
2013-06-11_18:40:58.80555 kern.err: iwl4965 0000:03:00.0: Loaded
firmware version: 228.61.2.24
2013-06-11_18:40:58.80556 kern.err: iwl4965 0000:03:00.0: Start IWL
Error Log Dump:
2013-06-11_18:40:58.80557 kern.err: iwl4965 0000:03:00.0: Status:
0x000313E4, count: 5
2013-06-11_18:40:58.80558 kern.err: iwl4965 0000:03:00.0: Desc
Time       data1      data2      line
2013-06-11_18:40:58.80559 kern.err: iwl4965 0000:03:00.0: SYSASSERT
(0x0005) 0000000095 0x00000000 0x00000000 262
2013-06-11_18:40:58.80560 kern.err: iwl4965 0000:03:00.0: pc
blink1  blink2  ilink1  ilink2  hcmd
2013-06-11_18:40:58.80561 kern.err: iwl4965 0000:03:00.0: 0x0C924
0x0C90E 0x0C93A 0x006DA 0x00000 0x4090010
2013-06-11_18:40:58.80562 kern.err: iwl4965 0000:03:00.0: FH register
values:
2013-06-11_18:40:58.80563 kern.err: iwl4965 0000:03:00.0:
FH49_RSCSR_CHNL0_STTS_WPTR_REG: 0X0b101300
2013-06-11_18:40:58.80564 kern.err: iwl4965 0000:03:00.0:
FH49_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00b10120
2013-06-11_18:40:58.80565 kern.err: iwl4965 0000:03:00.0:
FH49_RSCSR_CHNL0_WPTR: 0X00000008
2013-06-11_18:40:58.80565 kern.err: iwl4965 0000:03:00.0:
FH49_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819000
2013-06-11_18:40:58.80566 kern.err: iwl4965 0000:03:00.0:
FH49_MEM_RSSR_SHARED_CTRL_REG: 0X0000003c
2013-06-11_18:40:58.80567 kern.err: iwl4965 0000:03:00.0:
FH49_MEM_RSSR_RX_STATUS_REG: 0X07030000
2013-06-11_18:40:58.80569 kern.err: iwl4965 0000:03:00.0:
FH49_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
2013-06-11_18:40:58.80570 kern.err: iwl4965 0000:03:00.0:
FH49_TSSR_TX_STATUS_REG: 0X07ff0002
2013-06-11_18:40:58.80571 kern.err: iwl4965 0000:03:00.0:
FH49_TSSR_TX_ERROR_REG: 0X00000000
2013-06-11_18:40:58.80572 kern.err: iwl4965 0000:03:00.0: Command
C_RXON failed: FW Error
2013-06-11_18:40:58.80575 kern.err: iwl4965 0000:03:00.0: Error setting
new RXON (-5)
2013-06-11_18:40:58.80576 kern.warn: iwl4965 0000:03:00.0: Try to add
interface when device not ready

Regards,
Tino

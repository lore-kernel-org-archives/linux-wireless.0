Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from soma.isr.ist.utl.pt ([193.136.138.8]:33476 "EHLO
	soma.isr.ist.utl.pt" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbaIVAOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2014 20:14:51 -0400
Message-ID: <541F672E.70708@isr.tecnico.ulisboa.pt> (sfid-20140922_021454_980122_338D14C0)
Date: Mon, 22 Sep 2014 01:02:54 +0100
From: Plinio Moreno <plinio@isr.tecnico.ulisboa.pt>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: ilw@linux.intel.com
Subject: Re: dmesg output for iwlegacy
References: <541F66DA.103@isr.tecnico.ulisboa.pt>
In-Reply-To: <541F66DA.103@isr.tecnico.ulisboa.pt>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a Debian Wheezy (Kernel 3.2), pae


On 09/22/2014 01:01 AM, Plinio Moreno wrote:
> Hi,
>
> I need to restart the wireless connection continously, because of the 
> following error:
>
> iwl4965 0000:02:00.0: Microcode SW error detected.  Restarting 
> 0x82000000.
> [ 3170.528035] iwl4965 0000:02:00.0: Loaded firmware version: 228.61.2.24
> [ 3170.528057] iwl4965 0000:02:00.0: Start IWL Error Log Dump:
> [ 3170.528065] iwl4965 0000:02:00.0: Status: 0x000213E4, count: 5
> [ 3170.528234] iwl4965 0000:02:00.0: 
> Desc                                  Time       data1 data2 line
> [ 3170.528245] iwl4965 0000:02:00.0: FH_ERROR (0x000C) 1524712790 
> 0x00000008 0x03530000 208
> [ 3170.528252] iwl4965 0000:02:00.0: pc      blink1  blink2 ilink1 
> ilink2  hcmd
> [ 3170.528261] iwl4965 0000:02:00.0: 0x0046C 0x0A332 0x004C2 0x006DE 
> 0x0A34C 0x2EB001C
> [ 3170.528268] iwl4965 0000:02:00.0: FH register values:
> [ 3170.528288] iwl4965 0000:02:00.0: FH_RSCSR_CHNL0_STTS_WPTR_REG: 
> 0X03413100
> [ 3170.528309] iwl4965 0000:02:00.0: FH_RSCSR_CHNL0_RBDCB_BASE_REG: 
> 0X00374c20
> [ 3170.528329] iwl4965 0000:02:00.0: FH_RSCSR_CHNL0_WPTR: 0X00000080
> [ 3170.528349] iwl4965 0000:02:00.0: FH_MEM_RCSR_CHNL0_CONFIG_REG: 
> 0X00819000
> [ 3170.528369] iwl4965 0000:02:00.0: FH_MEM_RSSR_SHARED_CTRL_REG: 
> 0X0000003c
> [ 3170.528390] iwl4965 0000:02:00.0: FH_MEM_RSSR_RX_STATUS_REG: 
> 0X03530000
> [ 3170.528410] iwl4965 0000:02:00.0: 
> FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> [ 3170.528430] iwl4965 0000:02:00.0: FH_TSSR_TX_STATUS_REG: 0X07ff0002
> [ 3170.528450] iwl4965 0000:02:00.0: FH_TSSR_TX_ERROR_REG: 0X00000000
>
>
>

-- 
___________________

Plinio Moreno López
http://www.isr.ist.utl.pt/~plinio
plinio@isr.tecnico.ulisboa.pt
___________________


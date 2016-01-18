Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:40223 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbcARQVH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2016 11:21:07 -0500
Date: Mon, 18 Jan 2016 11:21:02 -0500 (EST)
Message-Id: <20160118.112102.1906921152446641103.davem@davemloft.net> (sfid-20160118_172111_248556_563DE9D7)
To: kvalo@codeaurora.org
Cc: aspriel@gmail.com, linux-wireless@vger.kernel.org,
	geert@linux-m68k.org
Subject: Re: [PATCH] brcmfmac: fix BRCMF_FW_NVRAM_DEF macro for older gcc
 compilers
From: David Miller <davem@davemloft.net>
In-Reply-To: <8737tv7198.fsf@kamboji.qca.qualcomm.com>
References: <1452958753-12307-1-git-send-email-aspriel@gmail.com>
	<8737tv7198.fsf@kamboji.qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kvalo@codeaurora.org>
Date: Mon, 18 Jan 2016 10:14:27 +0200

> Arend van Spriel <aspriel@gmail.com> writes:
> 
>> With gcc < 4.3 __UNIQUE_ID does not create unique ids with the macro
>> BRCMF_FW_NVRAM_DEF. Fix this by removing the MODULE_FIRMWARE instance
>> for the nvram file. This file is not in linux-firmware repo so it may
>> not be needed anyway. Otherwise consider this as a temporary fix.
>>
>> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Signed-off-by: Arend van Spriel <aspriel@gmail.com>
> 
> Thanks. Geert, it would be great if you could test this.
> 
> Dave, if Geert says the patch is ok do you mind taking this directly? I
> would like to fix this build breakage quickly.
> 
> https://patchwork.kernel.org/patch/8049181/
> 
> Acked-by: Kalle Valo <kvalo@codeaurora.org>

Ok, applied, thanks.

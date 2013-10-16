Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:57004 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab3JPVZS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 17:25:18 -0400
Received: by mail-wg0-f52.google.com with SMTP id f12so1363194wgh.7
        for <linux-wireless@vger.kernel.org>; Wed, 16 Oct 2013 14:25:17 -0700 (PDT)
Message-ID: <525F0437.4080207@gmail.com> (sfid-20131016_232524_122993_8CA92A06)
Date: Wed, 16 Oct 2013 22:25:11 +0100
From: Malcolm <tvboxspy@gmail.com>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: vt6656: rxtx change u32 [4] aWTxKey to u8[16]
 tx_key
References: <1381870009.5100.45.camel@canaries32-MCP7A> <20131016194638.GA25749@kroah.com>
In-Reply-To: <20131016194638.GA25749@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 16/10/13 20:46, Greg KH wrote:
> On Tue, Oct 15, 2013 at 09:46:49PM +0100, Malcolm Priestley wrote:
>> Replace 4 x u32 aWTxKey with u8 array of 16 bytes tx_key.
>>
>> Replaces pbyBuf in s_vFillTxKey and connects pbyTxBufferAddr
>> directly to tx_key without a cast elsewhere in structure.
>>
>> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> This patch causes a bunch of compiler warnings to get spit out by the
> compiler, so I can't take it.
>
> Please fix them up and resend.
hmm for some reason I am not getting them on gcc 4.8.1

Anyway, I will drop this patch for now. It requires changes elsewhere.

Malcolm

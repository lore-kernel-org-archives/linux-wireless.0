Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:42496 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751586AbdHSVlq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Aug 2017 17:41:46 -0400
Subject: Re: [PATCH 11/34] brcmfmac: Split brcmf_sdiod_buffrw function up.
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-12-ian@mnementh.co.uk> <59884E6B.5050801@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <28e96521-b214-1193-6c3e-d021db47e771@mnementh.co.uk> (sfid-20170819_234150_190660_CE2A1C3A)
Date: Sat, 19 Aug 2017 22:41:42 +0100
MIME-Version: 1.0
In-Reply-To: <59884E6B.5050801@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/08/17 12:26, Arend van Spriel wrote:

>> +        err = brcmf_sdiod_buff_write(sdiodev, SDIO_FUNC_2, addr, mypkt);
>>
>>       brcmu_pkt_buf_free_skb(mypkt);
>> +
> 
> You are keen on sprinkling whitespace here and there. Could you please
> use separate patches for that as much as possible. Not sure why you
> added this one...
> 
>>       return err;
>>
> 
> ...and kept this one.
> 
>>   }
> 

Good catch. There's a couple of others - I'll break them out. That
latter one is clearly an error on my part.

-Ian

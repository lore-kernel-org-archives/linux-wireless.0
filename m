Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36040 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752030AbdHHMdo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 08:33:44 -0400
Received: by mail-wm0-f51.google.com with SMTP id t201so5991351wmt.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Aug 2017 05:33:43 -0700 (PDT)
Subject: Re: [PATCH 31/34] brcmfmac: Remove func0 from function array
To: Ian Molton <ian@mnementh.co.uk>, linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-32-ian@mnementh.co.uk>
 <21ea2a49-c797-b427-1ee7-ff8164c8f95c@broadcom.com>
 <388c6040-1359-ef7d-7a0f-a4b0ac9a9825@mnementh.co.uk>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c9b7db07-7222-e7bf-0cb3-96e8ac0812d6@broadcom.com> (sfid-20170808_143347_833115_1CABFF07)
Date: Tue, 8 Aug 2017 14:33:41 +0200
MIME-Version: 1.0
In-Reply-To: <388c6040-1359-ef7d-7a0f-a4b0ac9a9825@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 08-08-17 13:27, Ian Molton wrote:
> On 08/08/17 12:19, Arend van Spriel wrote:
> 
>>>  #define brcmf_sdiod_func0_rb(sdiodev, addr, r) \
>>> -	sdio_f0_readb((sdiodev)->func[0], (addr), (r))
>>> +	sdio_f0_readb((sdiodev)->func[1], (addr), (r))
>>
>> There is no reason to keep these any longer as these do not provide any
>> functionality over the core sdio function unless you consider the
>> sdiodev dereference.
>>
> 
> I tend to agree, although they're fairly readable anyway. I was trying
> to keep the changes small and incremental.
> 
> I'll knock up a patch and see how it looks with them converted to the
> actual functions when I get back from hoiliday.

Enjoy the holiday. Glad to see I am not the only one checking email when
he is not supposed to work ;-)

Regards,
Arend

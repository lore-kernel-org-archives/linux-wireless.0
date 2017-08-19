Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:48356 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751626AbdHSVuR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 19 Aug 2017 17:50:17 -0400
Subject: Re: [PATCH 12/34] brcmfmac: Replace old IO functions with simpler
 ones.
From: Ian Molton <ian@mnementh.co.uk>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170726202557.15632-1-ian@mnementh.co.uk>
 <20170726202557.15632-13-ian@mnementh.co.uk> <59884E7F.3080607@broadcom.com>
 <4cbe4de3-a342-2cb7-d3d0-c40413381045@mnementh.co.uk>
Message-ID: <e721ed8e-5cc7-61f2-d845-11d8d90ac96c@mnementh.co.uk> (sfid-20170819_235020_040786_ADF411A5)
Date: Sat, 19 Aug 2017 22:50:14 +0100
MIME-Version: 1.0
In-Reply-To: <4cbe4de3-a342-2cb7-d3d0-c40413381045@mnementh.co.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/08/17 18:55, Ian Molton wrote:
> On 07/08/17 12:26, Arend van Spriel wrote:
>> On 7/26/2017 10:25 PM, Ian Molton wrote:
>>> Primarily this patch removes:
>>>
>>> brcmf_sdiod_f0_writeb()
>>> brcmf_sdiod_reg_write()
>>> brcmf_sdiod_reg_read()
>>
>> Having [patch 30/34] "brcmfmac: Correctly handle accesses to SDIO func0"
>> before this patch could make this look cleaner.
> 
> This is an artifact of how I came to the realisation the code was using
> the obsoleted functions - it could be reordered, but it'd probably get
> messy...

I gave it a try, and it got messy - I'd prefer to leave these patches in
their current ordering if thats OK.

-Ian

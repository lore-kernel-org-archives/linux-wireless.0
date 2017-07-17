Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:37198 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751324AbdGQT4q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 15:56:46 -0400
Subject: Re: BUG: brcmfmac: rework headroom check in .start_xmit() causes
 43430a1 to fail.
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        davem@davemloft.net
References: <86761c42-c91d-d4a7-3ba4-314612dd7fd1@mnementh.co.uk>
 <9ad41664-804f-eaf4-de59-ad3308178362@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <9fcdf5ac-fae5-fe28-b624-9c121b8e5876@mnementh.co.uk> (sfid-20170717_215649_776752_91371703)
Date: Mon, 17 Jul 2017 20:56:43 +0100
MIME-Version: 1.0
In-Reply-To: <9ad41664-804f-eaf4-de59-ad3308178362@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17/07/17 20:14, Arend van Spriel wrote:
> 
> On 17-07-17 21:03, Ian Molton wrote:
>> Hi folks,
>>
>> I've found that:
>>
>> 270a6c1f65fe brcmfmac: rework headroom check in .start_xmit()
>>
>> Causes the 43430a1 to become non-responsive. The log starts emitting
>> these messages:
> 
> A fix is already pending in patchwork:
> 
> https://patchwork.kernel.org/patch/9836383/

Confirmed, this fix does fix the breakage.

-Ian

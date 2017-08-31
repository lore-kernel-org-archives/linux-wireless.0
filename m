Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:43814 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751276AbdHaPRX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 11:17:23 -0400
Subject: Re: [PATCH 01/30] brcmfmac: Fix parameter order in
 brcmf_sdiod_f0_writeb()
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-2-ian@mnementh.co.uk>
 <4a840cca-d07a-15a7-7d31-b8269bb9feb3@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <8cfefbe3-6654-5752-4dcd-c6ab7666a151@mnementh.co.uk> (sfid-20170831_171726_854433_07BF5E0B)
Date: Thu, 31 Aug 2017 16:17:20 +0100
MIME-Version: 1.0
In-Reply-To: <4a840cca-d07a-15a7-7d31-b8269bb9feb3@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30/08/17 19:51, Arend van Spriel wrote:
> On 22-08-17 13:25, Ian Molton wrote:
>>     All the other IO functions are the other way round in this
>> driver. Make this one match.
> 
> Sorry for being a nit, but not sure why the commit message starts with a
> tab.

Not a problem - I don't mind nits being pointed out. Not at all.

> Other than that...

Will update it in the next (hopefully last!) rev.

> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Ta :)

>> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
>> ---
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)

-Ian

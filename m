Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:48020 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751175AbdGZKYC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 06:24:02 -0400
Subject: Re: PATCH v3 brcmfmac driver cleanup
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
References: <20170719190822.10857-1-ian@mnementh.co.uk>
 <df934726-851d-68a5-eb29-a6c6b1780be2@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <61239b54-0564-6e54-5af6-f2544be06c47@mnementh.co.uk> (sfid-20170726_122406_607333_EEC5F4A0)
Date: Wed, 26 Jul 2017 11:23:59 +0100
MIME-Version: 1.0
In-Reply-To: <df934726-851d-68a5-eb29-a6c6b1780be2@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24/07/17 20:47, Arend van Spriel wrote:
> On 19-07-17 21:07, Ian Molton wrote:
>> Hi all,
>>
>> Please find the 3rd revision of my cleanup patchset for brcmfmac.
>>
>> I've done some further cleanup and it now handles SDIO the ay the MMC subsystem
>> was designed to.
>>
>> I've also taken the liberty of greatly reducing the amount of indirection
>> used thoughout the SDIO code, which I think has improved readability quite a
>> lot.
>>
>> Hope this finds you all well.
> After only one week of vacation there was quite some catching up to do.
> So I decided to get an easy start and run 'checkpatch.pl --strict' over
> the series. Attached the output of that. Might be stuff that was already
> wrong before.

Some of it will be. I can see a couple of lines have crept over 80 chars.

Some lines are ~81-83 chars - I tend to leave those as its usually quite
apparent what is missing off the end. Longer ones I agree should be split.

The original source has some inconsistent whitespace too, which
complicates matters.

> I did only a quick check on patch 1/34 and it is really
> introduced by that patch. So can you please check the output.

Will have a run through and resubmit.

> FWIW, I tend to ignore the warning about block comments, ie.:

Yeah, I tend to agree. /* Blah as the first line of a multiline comment
just looks unbalanced to me.

-Ian

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:51934 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752641AbdHWABf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 20:01:35 -0400
Subject: Re: [PATCH v5] brcmfmac cleanup
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <0e3ce8c6-6a4c-b6dc-be20-47be1566aa50@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <d71b6b81-a808-3bdc-bb21-6421f23a1634@mnementh.co.uk> (sfid-20170823_020140_021403_51454FC4)
Date: Wed, 23 Aug 2017 01:01:32 +0100
MIME-Version: 1.0
In-Reply-To: <0e3ce8c6-6a4c-b6dc-be20-47be1566aa50@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22/08/17 20:41, Arend van Spriel wrote:
> On 22-08-17 13:25, Ian Molton wrote:
>> Hi folks,
>>
>> Arend, as requested - a respin to take account of your comments.
>>
>> Unfortunately, although I've only included the patches you requested
>> from v4,
>> breaking out some of the simpler changes (whitespace, macos, etc.) has
>> grown
>> the set back up to 30 patches. I hope this is OK.
> 
> :-( Grumbl, you also introduced some new ideas, eg. patch 26/30.

Oh, yeah. Forgot about that one, but its so uncontroversial I didn't see
the harm.

The same lines were touched in 25/30 and I didn't want to sneak the
change in there, as it felt dishonest to do so.

> I reviewed 15 patches that mostly involved in cleaning up bcmsdh.c. My
> hopes were that you addressed those 15 patches with a respin to get that
> part at least in for 4.14 as we are steadily moving towards the merge
> window. Maybe you did, but going from 15 to 30 feels like things are
> moving in the wrong direction. I will dig through it again.

I may have misunderstood, but you wrote:

"From this series I reviewed patches 1 upto and including patch 15, and
patches 29 through 34. Please rework those as requested and resubmit
them. Please also resubmit the remaining patch after that"

I took that to mean you wanted a respin that included 1-15 and 29-34.

- That would have been 21 patches on its own, but a couple of the later
ones drew in dependencies, and you asked me to break up a couple of
others, eg. whitespace.

Thats how we arrived at 30 patches again. I'm not attempting to take the
piss, I swear :)

I do appreciate the review. I've replied to your emails on the v4
series, so if you have a question as to why I've done something, you may
well find the answer there.

-Ian

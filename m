Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0055.outbound.protection.outlook.com ([104.47.32.55]:18642
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933352AbcKNKC1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 05:02:27 -0500
Subject: Re: [RFC] qtn: add FullMAC firmware for Quantenna QSR10G wifi device
To: Johannes Berg <johannes@sipsolutions.net>
References: <1478700000-11624-1-git-send-email-igor.mitsyanko.os@quantenna.com>
 <1478706966.18306.1.camel@sipsolutions.net>
 <2fcb5f28-808e-f296-7e91-e5185e7577c9@quantenna.com>
 <1478725543.21403.4.camel@sipsolutions.net>
 <d1cfaf8a-55a6-3a7c-9e9d-ec810fe5b80d@quantenna.com>
 <1478864146.4129.4.camel@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <btherthala@quantenna.com>,
        <hwang@quantenna.com>, <smaksimenko@quantenna.com>,
        <dlebed@quantenna.com>, Igor Mitsyanko <imitsyanko@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Kyle McMartin <kyle@kernel.org>
From: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <a5075f50-25c6-18a1-bd5b-309927dacdab@quantenna.com> (sfid-20161114_110236_539327_F5EE9C38)
Date: Mon, 14 Nov 2016 11:26:04 +0300
MIME-Version: 1.0
In-Reply-To: <1478864146.4129.4.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks, Johannes.

To clarify with you and Kalle, as persons involved with linux-wireless: 
is my understanding correct that submitting firmware into linux-fimware 
repository is a prerequisite to accepting new driver into linux-wireless?

There is an option to start Quantenna device from internal flash memory, 
no external binary files involved. If we will introduce this 
functionality and remove code handling external firmware for now (until 
firmware problem resolved), would that allow driver to be reviewed/accepted?

On 11/11/2016 02:35 PM, Johannes Berg wrote:
> Adding linux-firmware people to Cc, since presumably they don't
> necessarily read linux-wireless...
>
>> Johannes, from that perspective, who are the "redistributors"?
>> Specifically, is linux-firmware git repository considered a
>> redistributor or its just hosting files? I mean, at what moment
>> someone else other then Quantenna will start to be legally obliged to
>> make GPL code used in firmware available for others?
> Look, I don't know. I'd assume people who ship it, like any regular
> distro, would be (re)distributors thereof. "Normal" (non-GPL) firmware
> images come with a redistribution license, but that obviously can't
> work here.
>
> There's some info from Ben here regarding the carl9170 case:
> http://lkml.iu.edu/hypermail/linux/kernel/1605.3/01176.html
>
>> Personally I still hope that linux-firmware itself is not legally
>> concerned with what is the content of firmware its hosting, but looks
>> like there already was a precedent case  with carl9170 driver and
>> we have to somehow deal with it.
> That's really all I wanted to bring up. I'm not involved with the
> linux-firmware git tree.
>
>> There still may be a difference though: Quantenna is semiconductor
>> company only, software
>> used on actual products based on Quantenna chipsets is released by
>> other
>> companies.
>> I just want to present our legal team with a clear case (and position
>> of
>> Linux maintainers) so that they can
>> work with it and make decision on how to proceed.
>>
>>   From technical perspective, as I mentioned, SDK is quite huge and
>> include a lot of opensource
>> components including full Linux, I don't think its reasonable to have
>> it
>> inside linux-firmware tree.
>> What are the options to share it other then providing it on request
>> basis:
>> - git repository
>> - store tarball somewhere on official website
> Clearly that wasn't deemed appropriate for carl9170, so I don't see why
> it'd be different here.
>
> johannes

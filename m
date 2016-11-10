Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0071.outbound.protection.outlook.com ([104.47.34.71]:63939
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932845AbcKJOSp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Nov 2016 09:18:45 -0500
Subject: Re: [RFC] qtn: add FullMAC firmware for Quantenna QSR10G wifi device
To: Johannes Berg <johannes@sipsolutions.net>
References: <1478700000-11624-1-git-send-email-igor.mitsyanko.os@quantenna.com>
 <1478706966.18306.1.camel@sipsolutions.net>
 <2fcb5f28-808e-f296-7e91-e5185e7577c9@quantenna.com>
 <1478725543.21403.4.camel@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <btherthala@quantenna.com>,
        <hwang@quantenna.com>, <smaksimenko@quantenna.com>,
        <dlebed@quantenna.com>, Igor Mitsyanko <imitsyanko@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
From: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <d1cfaf8a-55a6-3a7c-9e9d-ec810fe5b80d@quantenna.com> (sfid-20161110_151849_698849_4C146F1B)
Date: Thu, 10 Nov 2016 17:02:30 +0300
MIME-Version: 1.0
In-Reply-To: <1478725543.21403.4.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/10/2016 12:05 AM, Johannes Berg wrote:
> I understand, and I understand that you/they are actually providing it
> when asked.
>
> However, the carl9170 project has its (entirely GPL) source tree out in
> the open, making it much *easier* and that was *still* thought to not
> be sufficient; I don't recall the discussions but I'm guessing that's
> because of something like redistributors having to make sure source is
> available, and guaranteeing that for a long time, etc.
>
> johannes

Johannes, from that perspective, who are the "redistributors"? 
Specifically, is linux-firmware git
repository considered a redistributor or its just hosting files? I mean, 
at what moment
someone else other then Quantenna will start to be legally obliged to 
make GPL code
used in firmware available for others?

Personally I still hope that linux-firmware itself is not legally 
concerned with what is the content of
firmware its hosting, but looks like there already was a precedent case 
with carl9170 driver and
we have to somehow deal with it.
There still may be a difference though: Quantenna is semiconductor 
company only, software
used on actual products based on Quantenna chipsets is released by other 
companies.
I just want to present our legal team with a clear case (and position of 
Linux maintainers) so that they can
work with it and make decision on how to proceed.

 From technical perspective, as I mentioned, SDK is quite huge and 
include a lot of opensource
components including full Linux, I don't think its reasonable to have it 
inside linux-firmware tree.
What are the options to share it other then providing it on request basis:
- git repository
- store tarball somewhere on official website

Thanks!

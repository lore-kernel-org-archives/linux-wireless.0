Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46833 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750937AbdEUOTm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 May 2017 10:19:42 -0400
Subject: Re: [PATCH 1/1] dt-binding: net: wireless: fix node name in the
 BCM43xx example
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: robh+dt@kernel.org, kvalo@codeaurora.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <20170515201356.26384-1-martin.blumenstingl@googlemail.com>
 <20170515201356.26384-2-martin.blumenstingl@googlemail.com>
 <8155d0f1-aed3-fc47-4524-635067f9ee7b@broadcom.com>
 <CAFBinCBeijYMJ+hTajCA-2D7S1aH6E2mc_gm-2cAqKt87XVNkg@mail.gmail.com>
From: =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>
Message-ID: <11675313-d92f-e562-0fd5-21339b5aa599@suse.de> (sfid-20170521_161953_199065_9CD106EC)
Date: Sun, 21 May 2017 16:19:39 +0200
MIME-Version: 1.0
In-Reply-To: <CAFBinCBeijYMJ+hTajCA-2D7S1aH6E2mc_gm-2cAqKt87XVNkg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Am 16.05.2017 um 21:56 schrieb Martin Blumenstingl:
> On Tue, May 16, 2017 at 12:05 AM, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 15-5-2017 22:13, Martin Blumenstingl wrote:
>>> The example in the BCM43xx documentation uses "brcmf" as node name.
>>> However, wireless devices should be named "wifi" instead. Fix this to
>>
>> Since when is that a rule. I never got the memo and the DTC did not ever
>> complain to me about the naming.

How do you expect it to? Maintain a blacklist of every device model
someone might use, including all typo variations?

> That being said I do not really care
>> and I suppose it is for the sake of consistency only.
> I'm not sure if it's actually a rule or (as you already noted) just
> for consistency. back when I added devicetree support to ath9k Rob
> pointed out that the node should be named "wifi" (instead of "ath9k"),
> see [0]

The general rule is that the node name should be the type of the device,
not duplicate its compatible string.

For consistency Rob was asking we use "wifi" as node name.

Regards,
Andreas

-- 
SUSE Linux GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)

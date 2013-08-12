Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:45106 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab3HLKXA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 06:23:00 -0400
Received: by mail-ie0-f177.google.com with SMTP id a11so7475435iee.8
        for <linux-wireless@vger.kernel.org>; Mon, 12 Aug 2013 03:22:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5208B47B.6090903@broadcom.com>
References: <1376130450-29746-1-git-send-email-arend@broadcom.com>
	<1376130450-29746-13-git-send-email-arend@broadcom.com>
	<CAOiHx==iBf19ym=Q3HFOdKv_u-6tvz0uq_U61ziVfKS7LuWG5w@mail.gmail.com>
	<5208B47B.6090903@broadcom.com>
Date: Mon, 12 Aug 2013 12:22:59 +0200
Message-ID: <CANq1E4Rv3gpome_oJpWxKzZ+oU4==HFaNnr3a3cmkAWVW6fx6A@mail.gmail.com> (sfid-20130812_122311_352904_96B149FC)
Subject: Re: [PATCH 12/12] brcmsmac: support 4313iPA
From: David Herrmann <dh.herrmann@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Jonas Gorski <jogo@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Piotr Haber <phaber@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Mon, Aug 12, 2013 at 12:10 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 08/11/2013 02:48 PM, Jonas Gorski wrote:
>>
>> Hi,
>>
>> On Sat, Aug 10, 2013 at 12:27 PM, Arend van Spriel <arend@broadcom.com>
>> wrote:
>>>
>>> From: Piotr Haber <phaber@broadcom.com>
>>>
>>> Add support for 4313 iPA variant.
>>> It is a variant of already supported 4313 ePA,
>>> so this patch adds the required PHY changes to
>>> support it properly including an updated switch
>>> control table for BT-combo card variants.
>>
>>
>> Okay, I'll bite. Since this patch was already reverted once, it
>> warrants some additional scrutiny.
>
>
> That's the right attitude ;-) The revert made us cautious as well before
> sending out this patch, but thanks for making the effort.
>
>
>> First of all, the patch is quite large, and I wonder if it couldn't be
>> split into smaller patches, especially as it looks like there are
>> additional fixes/changes merged in it.
>
>
> It indeed seems rather large. The original work from Piotr were two patches
> that I squashed. I will break up this patch in more individual patches.
>
> John,
>
> Can you drop this patch from the series?
>
>
>> Detailed comments below ...
>>
>>> Tested-by: Maximilian Engelhardt <maxi@daemonizer.de>
>>> Tested-by: David Costa <david@zarel.net>
>>> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
>>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>>> Signed-off-by: Piotr Haber <phaber@broadcom.com>
>>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>>> ---
>>
>>
>> This is obviously a V2 (or V(n+1) where n was the reverted version),
>> so there should be something describing the changes to the reverted
>> version. Why should we trust it now to not break things again? (Yes, I
>> see those Tested-bys ;-)
>
>
> This is a gray area. The original patch was taken into the tree so I
> considered this to be a new patch.
>
> We tested with a number of 4313 variants having some extra shipped that we
> did not have at the time of the original patch. I looked up the revert patch
> and noticed it is tagged with Reported-by. So I will ask David Herrmann to
> test V(n+2) before sending it (if you don't mind n will be 0).

If you add me to CC for the patch I will happily test it. But for now
I have no idea which patches I should try so I will wait for the next
revision, I guess?

Thanks for letting me know!
David

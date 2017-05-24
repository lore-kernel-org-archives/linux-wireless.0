Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:35249 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934636AbdEXIQA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 04:16:00 -0400
Received: by mail-ua0-f175.google.com with SMTP id y4so86185097uay.2
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 01:16:00 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1495612648.24885.62.camel@coelho.fi>
References: <CA+icZUU3TwPOnABirE+0kT1tjr=fWLXPJFeCprsCSvXmqiiC+A@mail.gmail.com>
 <1495612648.24885.62.camel@coelho.fi>
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Wed, 24 May 2017 10:15:54 +0200
Message-ID: <CA+icZUUO72+epsLDFmXWpRWQV7_vkR0LVyqitoZ1XLEbxr+ATw@mail.gmail.com> (sfid-20170524_101631_438740_A7CE26BB)
Subject: Re: [Linux-4.9.28] iwlwifi 6230 AGN: Microcode SW error detected
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 24, 2017 at 9:57 AM, Luca Coelho <luca@coelho.fi> wrote:
> On Wed, 2017-05-24 at 09:41 +0200, Sedat Dilek wrote:
>> Hi,
>
> Hi Sedat,
>
>
>> I am seeing the below/following in my logs today.
>> My AP is a Lenovo Moto-Z with LTE support.
>>
>> Can you comment on this?
>> Is this a "buggy" firmware and a new firmware around?
>
> Looks like a buggy firmware, but unfortunately we don't have a newer
> firmware with a fix for this.
>
>
>> My kernel-config and full dmesg are attached.
>>
>> If you need further informations, please let me know.
>>
>> Hope this helps.
>>
>> Regards,
>> - Sedat -
>>
>> P.S.: Excerpts from my dmesg-log.
>>
>> [   16.708016] iwlwifi 0000:01:00.0: Detected Intel(R) Centrino(R)
>> Advanced-N 6230 AGN, REV=0xB0
>
> This is a really old NIC (6+ years old) and unfortunately we can't
> provide firmware fixes for it anymore.
>
> Hopefully the recovery flow in the driver recovers the connectivity and
> everything continues working fine.
>

Thanks for the fast reply.

Intel was(?) a good choice is my conclusion after getting no more
replies/fixes for my SandyBridge-GPU from intel-gfx guys.
This Samsung Ultrabook is 5 years young.
I can understand that fixing a 6 years old NIC is not your prio #1.

As an example, there is no vulkan support for my GPU, so it's time for a change?

No glue if other hardware vendors have better support.

- sed@ -

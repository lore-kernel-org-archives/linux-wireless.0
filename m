Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:51611 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaF2E5h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2014 00:57:37 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so6730291wgg.8
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2014 21:57:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P1=hWuxoicxcFx4O_v9veNMQr1pA5rf06LgAasO+rXPsg@mail.gmail.com>
References: <CAH5Ym4iX=7TvPAajyb_PzrfsD7UmbsOYOvU9YqZk78zaDaQNGA@mail.gmail.com>
	<CANUX_P1=hWuxoicxcFx4O_v9veNMQr1pA5rf06LgAasO+rXPsg@mail.gmail.com>
Date: Sat, 28 Jun 2014 21:57:36 -0700
Message-ID: <CAH5Ym4iQVD6aTztB1knfkFt4Y9f6pjqQY5aKM8ZdTwC3u-d3Dg@mail.gmail.com> (sfid-20140629_065741_440704_6DC6B63D)
Subject: Re: BUG: iwlwifi microcode errors on Intel 7260HMW
From: Sam Edwards <cfsworks@gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Will do so immediately, thanks!

On Sat, Jun 28, 2014 at 9:55 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>> Hello!
>>
>> I've been working for a week to track down the cause of this bug.
>> Sadly, I have no background in wireless development and no knowledge
>> of the Intel microcode format, so I've gotten stuck.
>>
>> I'm trying to use an Intel 7260HMW with OpenWrt to act as an AP. I'm
>> using a recent snapshot ("Barrier Breaker") build of OpenWrt, on the
>> Linux 3.10.36 kernel. The iwlwifi driver is built from the Linux
>> driver backports package; a diff reveals that it is fully up-to-date
>> with the latest source in the upstream kernel repository.
>>
>> When trying to run hostapd, my kernel log repeats output similar to
>> this: http://pastebin.com/1UuUuMMg
>> The problems are not limited to trying to use the device as an AP.
>> When trying to associate to an existing network, I am given similar
>> output: http://pastebin.com/qxwbdHyu
>>
>> The wireless device is, however, capable of scanning for nearby APs,
>> but so far I have not been able to get it to do anything else.
>>
>> I've been unable to get the non-backported (i.e. 3.10.36) version of
>> the driver to load correctly, and I cannot easily test this on the
>> latest kernel either. However, if I should try a different version,
>> please let me know.
>>
>
> Please open a bug on bugzilla.kernel.org and copy ilw@linux.intel.com
> to the bug.
> This is most likely a firmware bug.
>
> Thank you.

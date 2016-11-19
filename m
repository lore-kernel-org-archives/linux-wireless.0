Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40534 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752183AbcKSCAM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 21:00:12 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Barry Day <briselec@gmail.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH 0/7] rtl8xxxu: Pending patches
References: <1479505468-29383-1-git-send-email-Jes.Sorensen@redhat.com>
        <20161119014648.GA7140@testbox>
Date: Fri, 18 Nov 2016 21:00:10 -0500
In-Reply-To: <20161119014648.GA7140@testbox> (Barry Day's message of "Sat, 19
        Nov 2016 11:46:49 +1000")
Message-ID: <wrfjbmxcb55h.fsf@redhat.com> (sfid-20161119_030015_853088_FE4284FB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Barry Day <briselec@gmail.com> writes:
> On Fri, Nov 18, 2016 at 04:44:21PM -0500, Jes.Sorensen@redhat.com wrote:
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>> 
>> Kalle,
>> 
>> Please find attached a number of patches for the rtl8xxxu
>> driver.
>> 
>> The issues reported with wpa_supplicant on 8723bu still needs further
>> investigation.
>> 
>
> The patch I posted that you want tested more will also fix the
> wpa_supplicant issue.  Currently I'm looking at why the tx rate is not
> what it should be. I feel fixing that first will be beneficial for
> fixing any other issues.

Interesting, I was thinking that might be the case. I do want to dig
into this further to understand it better. If we use your solution I
will want to make sure we cover both gen1 and gen2 parts.

> The recent merge has made my local branch of rtl8xxxu-devel 14 commits ahead.
> Do I need to do a reset and submit a new patch for the DWA-131 dongle?

In general you need to use 'git pull --rebase' on my tree. I rebase it
to stay in sync with Kalle's tree.

The DWA-131 is the 8192eu? Sorry a bit behind and my mind is losing
bits. If it's the patch you posted earlier I can dig it out and play
with it - I am still catching up though, so please be patient.

Cheers,
Jes

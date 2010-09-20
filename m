Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:48465 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090Ab0ITT2v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 15:28:51 -0400
Message-ID: <4C97B5E6.20505@hauke-m.de>
Date: Mon, 20 Sep 2010 21:28:38 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Subject: Re: [PATCH 2/2 v2] compat-wireless: "backport" pcmcia api changes.
References: <1284918553-32365-1-git-send-email-hauke@hauke-m.de> <1284918969-19315-1-git-send-email-hauke@hauke-m.de> <AANLkTikAszZ3tLf90d0AnBe-42c87GFpRfbh2EbMZhTT@mail.gmail.com>
In-Reply-To: <AANLkTikAszZ3tLf90d0AnBe-42c87GFpRfbh2EbMZhTT@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20.09.2010 17:26, Luis R. Rodriguez wrote:
> On Sun, Sep 19, 2010 at 10:56 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> The PCMCIA API changed again.
>> This patch was only compile tested, beacuse I do not have devices to
>> test this.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> 
> mcgrof@tux ~/devel/compat-wireless-2.6 (git::master)$ patch -p1 <
> /home/mcgrof/patches/2010/09/20/02-cw.patch
> patching file patches/24-pcmcia.patch
> Hunk #1 succeeded at 1 with fuzz 1.
> Hunk #2 FAILED at 13.
.....
> 49 out of 50 hunks FAILED -- saving rejects to file patches/24-pcmcia.patch.rej
> 
> We should just remove PCMCIA, at the summit no Linux distribution
> present indicated their desire to keep it alive and maintained within
> compat-wireless. This should save us some work.
> 
>   Luis
Hi Luis

That is strange. Something must have went wrong when applying this
patch. I just checked out a fresh compat-wireless tree and tried to
apply the mail with git am ... and it worked with some warnings.

When the next big API change in the pcmcia subsystem arrives we should
really drop it, but for now it should at least compile and probably
work. I will resend the a patch rebased on todays compat-wireless.

Hauke

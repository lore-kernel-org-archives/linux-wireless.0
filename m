Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33126 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab0ITPdU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 11:33:20 -0400
Received: by iwn5 with SMTP id 5so4337400iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Sep 2010 08:33:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikAszZ3tLf90d0AnBe-42c87GFpRfbh2EbMZhTT@mail.gmail.com>
References: <1284918553-32365-1-git-send-email-hauke@hauke-m.de>
 <1284918969-19315-1-git-send-email-hauke@hauke-m.de> <AANLkTikAszZ3tLf90d0AnBe-42c87GFpRfbh2EbMZhTT@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 20 Sep 2010 08:33:00 -0700
Message-ID: <AANLkTikjfUuytFxRaBaFfU9jVuvDTeXnYuthCVB_8yf0@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] compat-wireless: "backport" pcmcia api changes.
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 20, 2010 at 8:26 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
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
> Hunk #3 FAILED at 25.
> Hunk #4 FAILED at 37.
> Hunk #5 FAILED at 49.
> Hunk #6 FAILED at 61.
> Hunk #7 FAILED at 73.
> Hunk #8 FAILED at 85.
> Hunk #9 FAILED at 97.
> Hunk #10 FAILED at 109.
> Hunk #11 FAILED at 119.
> Hunk #12 FAILED at 147.
> Hunk #13 FAILED at 161.
> Hunk #14 FAILED at 177.
> Hunk #15 FAILED at 189.
> Hunk #16 FAILED at 201.
> Hunk #17 FAILED at 213.
> Hunk #18 FAILED at 230.
> Hunk #19 FAILED at 287.
> Hunk #20 FAILED at 303.
> Hunk #21 FAILED at 315.
> Hunk #22 FAILED at 327.
> Hunk #23 FAILED at 339.
> Hunk #24 FAILED at 351.
> Hunk #25 FAILED at 363.
> Hunk #26 FAILED at 380.
> Hunk #27 FAILED at 437.
> Hunk #28 FAILED at 453.
> Hunk #29 FAILED at 465.
> Hunk #30 FAILED at 477.
> Hunk #31 FAILED at 489.
> Hunk #32 FAILED at 503.
> Hunk #33 FAILED at 515.
> Hunk #34 FAILED at 530.
> Hunk #35 FAILED at 573.
> Hunk #36 FAILED at 591.
> Hunk #37 FAILED at 606.
> Hunk #38 FAILED at 634.
> Hunk #39 FAILED at 673.
> Hunk #40 FAILED at 691.
> Hunk #41 FAILED at 703.
> Hunk #42 FAILED at 717.
> Hunk #43 FAILED at 726.
> Hunk #44 FAILED at 758.
> Hunk #45 FAILED at 803.
> Hunk #46 FAILED at 820.
> Hunk #47 FAILED at 831.
> Hunk #48 FAILED at 863.
> Hunk #49 FAILED at 908.
> Hunk #50 FAILED at 925.
> 49 out of 50 hunks FAILED -- saving rejects to file patches/24-pcmcia.patch.rej
>
> We should just remove PCMCIA, at the summit no Linux distribution
> present indicated their desire to keep it alive and maintained within
> compat-wireless. This should save us some work.

Applied the other 3/4 patches though, thanks!

  Luis

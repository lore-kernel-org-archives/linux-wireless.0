Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:39089 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbZHEFGB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 01:06:01 -0400
Received: by bwz19 with SMTP id 19so3466679bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 22:06:01 -0700 (PDT)
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl12xx: make irq handling interface specific
References: <20090804033908.GA1903@hash.localnet>
	<87hbwoniog.fsf@litku.valot.fi> <20090804122229.GA3337@hash.localnet>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 05 Aug 2009 08:05:58 +0300
In-Reply-To: <20090804122229.GA3337@hash.localnet> (Bob Copeland's message of "Tue\, 4 Aug 2009 08\:22\:29 -0400")
Message-ID: <877hxionnt.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> On Tue, Aug 04, 2009 at 10:26:39AM +0300, Kalle Valo wrote:
>> So this patch is only needed on top of the rebased sdio patchset I sent
>> few weeks ago to get sdio working? Or did I miss any patches? I'm just
>> being careful here because I want to get sdio support to 2.6.32 (if it's
>> ok for John) and there isn't that much time for that.
>
> Hi Kalle,
>
> Yes, the only other patch I have is for the platform gpios for the MSM
> kernel (msm_wifi.ko module for HTC Dream) which doesn't touch this at all
> and is platform specific.

Yes, that's a separate issue.

> The plan was to turn that into a platform rfkill driver, though it can
> probably go to staging in its present form with the other Dream stuff.

I'm planning to add rfkill support to wl1251, it's just that my todo
list is currently a mile long :)

But thanks, good to know that I now have everything for sdio support.
Outstanding work, Bob!

-- 
Kalle Valo

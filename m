Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:36967 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727753AbeIFOxc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 10:53:32 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Grant Grundler <grundler@google.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, wgong@qti.qualcomm.com,
        wgong@codeaurora.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi chips
In-Reply-To: <CANEJEGsm_BKM6g2x0+a7_5dBy5jkROs+jEjHmrcneGrMdDK41g@mail.gmail.com>
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org> <1533724802-30944-3-git-send-email-wgong@codeaurora.org> <87sh3pdtpg.fsf@toke.dk> <f185ab8722e84c959b375e606d25a29b@aptaiexm02f.ap.qualcomm.com> <87mutue4y8.fsf@toke.dk> <ef7b317006964c0fa72763bbfc5149e5@aptaiexm02f.ap.qualcomm.com> <CANEJEGvcj9gPT8yy++qvi3hz3t9pAXyeUves06gr+ADfn9Ouhg@mail.gmail.com> <1535967508.3437.31.camel@sipsolutions.net> <87in3m25uu.fsf@toke.dk> <1535975240.3437.61.camel@sipsolutions.net> <878t4i1z74.fsf@toke.dk> <CANEJEGsm_BKM6g2x0+a7_5dBy5jkROs+jEjHmrcneGrMdDK41g@mail.gmail.com>
Date: Thu, 06 Sep 2018 12:18:45 +0200
Message-ID: <871sa7ylmi.fsf@toke.dk> (sfid-20180906_121849_988437_6CCD2552)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grant Grundler <grundler@google.com> writes:

>> And, well, Grant's data is from a single test in a noisy
>> environment where the time series graph shows that throughput is all over
>> the place for the duration of the test; so it's hard to draw solid
>> conclusions from (for instance, for the 5-stream test, the average
>> throughput for 6 is 331 and 379 Mbps for the two repetitions, and for 7
>> it's 326 and 371 Mbps) . Unfortunately I don't have the same hardware
>> used in this test, so I can't go verify it myself; so the only thing I
>> can do is grumble about it here... :)
>
> It's a fair complaint and I agree with it. My counter argument is the
> opposite is true too: most ideal benchmarks don't measure what most
> users see. While the data wgong provided are way more noisy than I
> like, my overall "confidence" in the "conclusion" I offered is still
> positive.

Right. I guess I would just prefer a slightly more comprehensive
evaluation to base a 4x increase in buffer size on...

-Toke

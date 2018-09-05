Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49008 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbeIELwA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 07:52:00 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 05 Sep 2018 15:23:09 +0800
From: Wen Gong <wgong@codeaurora.org>
To: Grant Grundler <grundler@google.com>
Cc: toke@toke.dk, Johannes Berg <johannes@sipsolutions.net>,
        wgong@qti.qualcomm.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi
 chips
In-Reply-To: <CANEJEGsm_BKM6g2x0+a7_5dBy5jkROs+jEjHmrcneGrMdDK41g@mail.gmail.com>
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org>
 <1533724802-30944-3-git-send-email-wgong@codeaurora.org>
 <87sh3pdtpg.fsf@toke.dk>
 <f185ab8722e84c959b375e606d25a29b@aptaiexm02f.ap.qualcomm.com>
 <87mutue4y8.fsf@toke.dk>
 <ef7b317006964c0fa72763bbfc5149e5@aptaiexm02f.ap.qualcomm.com>
 <CANEJEGvcj9gPT8yy++qvi3hz3t9pAXyeUves06gr+ADfn9Ouhg@mail.gmail.com>
 <1535967508.3437.31.camel@sipsolutions.net> <87in3m25uu.fsf@toke.dk>
 <1535975240.3437.61.camel@sipsolutions.net> <878t4i1z74.fsf@toke.dk>
 <CANEJEGsm_BKM6g2x0+a7_5dBy5jkROs+jEjHmrcneGrMdDK41g@mail.gmail.com>
Message-ID: <d107bcfcff90bac041596dc61fd6a666@codeaurora.org> (sfid-20180905_092315_132166_A10285FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-05 07:43, Grant Grundler wrote:
> On Mon, Sep 3, 2018 at 6:35 AM Toke Høiland-Jørgensen <toke@toke.dk> 
> wrote:
>> 
>> Johannes Berg <johannes@sipsolutions.net> writes:
> ....
>> > Grant's data shows a significant difference between 6 and 7 for both
>> > latency and throughput:
> 
> Minor nit: this is wgong's data more thoughtfully processed.

> 
> wgong: can you confirm (a) I've entered the data correctly in the
> spreadsheet and (b) you've labeled the data sets correctly when you
> generated the data?
> If either of us made a mistake, it would be good to know. :)
> 
yes, the data is the test result from flent tool.

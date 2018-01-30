Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:40175 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751475AbeA3Sz2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 13:55:28 -0500
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k will not tx packets sometimes.
In-Reply-To: <712ee959-4e41-f4fd-e765-523d024fa7fc@candelatech.com>
References: <c383b64d-d028-3d83-f1c1-b4e32ca04c26@candelatech.com> <87a7wzv43j.fsf@toke.dk> <f021a32c-6f12-1cfe-970f-eae7dd334416@candelatech.com> <87d11stk0i.fsf@toke.dk> <11a30dfe-842a-8b1e-0d7e-d4159bf4b2bb@candelatech.com> <871si81eev.fsf@toke.dk> <5A6FA79B.1080206@candelatech.com> <87h8r335yz.fsf@toke.dk> <712ee959-4e41-f4fd-e765-523d024fa7fc@candelatech.com>
Date: Tue, 30 Jan 2018 19:55:25 +0100
Message-ID: <87wozzyy5e.fsf@toke.dk> (sfid-20180130_195551_732996_E10D889A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

>> I'm actually working on reworking that whole scheduler logic, and move
>> some of it into mac80211. Could you test this (WiP) patch and see if
>> that has the same problem?
>
> It had some serious conflicts in ath10k, due to my local changes, so
> I did not actually test this.

Can send you a version without the ath10k changes tomorrow if you'd like
to test - but will try to reproduce myself as well...

> But, a revert of the atf patches (a6e56d749 and 63fefa050) appear to
> have resolved the issue. I'll test more with these reverted, and maybe
> will have time to work more on actually fixing upstream code next time
> I move to a newer kernel (and/or after your pending changes get in).

Ah, that narrows it down some. Well, that is the code I'm hacking on
currently anyway, so let's see if we can't get it fixed as part of that
series :)

-Toke

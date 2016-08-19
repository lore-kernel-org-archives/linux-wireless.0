Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60162 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752848AbcHSJJz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 05:09:55 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dinan.gunawardena@netronome.com
Subject: Re: [RFC (v7)] add basic register-field manipulation macros
References: <CA+55aFz_MUXQjWjbQzb7f=+cQLtxQsba1azmbEVZOgy5Y7wfdQ@mail.gmail.com>
        <1471540317-14823-1-git-send-email-jakub.kicinski@netronome.com>
        <CA+55aFytOu02ZvRf+gxCCeP98qbv8wXzOds8Ocu-Ps4mKbGCkQ@mail.gmail.com>
Date: Fri, 19 Aug 2016 12:09:47 +0300
In-Reply-To: <CA+55aFytOu02ZvRf+gxCCeP98qbv8wXzOds8Ocu-Ps4mKbGCkQ@mail.gmail.com>
        (Linus Torvalds's message of "Thu, 18 Aug 2016 10:28:01 -0700")
Message-ID: <87r39lyvj8.fsf@kamboji.qca.qualcomm.com> (sfid-20160819_111012_993779_F9862A90)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Aug 18, 2016 at 10:11 AM, Jakub Kicinski
> <jakub.kicinski@netronome.com> wrote:
>> Hi!
>>
>> This is what I came up with.  Changes:
>
> I can live with this, certainly. I'm not really sure how many drivers
> (or perhaps core code, for that matter) will actually start using it,
> but it at least _looks_ like a usable interface that seems to be quite
> resistant to people doing stupid things with it that would result in
> surprising results (either performance or semantics).

I'm guessing that at least in ath9k and ath10k there would be use of
these macros.

> So I'm ok with something like this coming through (for example) the
> wireless tree if the drivers there are the first ones to start using
> this.
>
> Let's see if anybody else objects.

Great, thanks for the help. Let's wait for other comments and Jakub can
then resend this without RFC. I can then take it through my tree.

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:34613 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753718AbcHSCev (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Aug 2016 22:34:51 -0400
MIME-Version: 1.0
In-Reply-To: <1471540317-14823-1-git-send-email-jakub.kicinski@netronome.com>
References: <CA+55aFz_MUXQjWjbQzb7f=+cQLtxQsba1azmbEVZOgy5Y7wfdQ@mail.gmail.com>
 <1471540317-14823-1-git-send-email-jakub.kicinski@netronome.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Aug 2016 10:28:01 -0700
Message-ID: <CA+55aFytOu02ZvRf+gxCCeP98qbv8wXzOds8Ocu-Ps4mKbGCkQ@mail.gmail.com> (sfid-20160819_043510_073092_943D320C)
Subject: Re: [RFC (v7)] add basic register-field manipulation macros
To: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dinan.gunawardena@netronome.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 18, 2016 at 10:11 AM, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
> Hi!
>
> This is what I came up with.  Changes:

I can live with this, certainly. I'm not really sure how many drivers
(or perhaps core code, for that matter) will actually start using it,
but it at least _looks_ like a usable interface that seems to be quite
resistant to people doing stupid things with it that would result in
surprising results (either performance or semantics).

So I'm ok with something like this coming through (for example) the
wireless tree if the drivers there are the first ones to start using
this.

Let's see if anybody else objects.

               Linus

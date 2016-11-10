Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34640 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756077AbcKJWxj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Nov 2016 17:53:39 -0500
Date: Fri, 11 Nov 2016 08:45:37 +1000
From: Barry Day <briselec@gmail.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Dave Jones <s.dave.jones@gmail.com>, Joe Perches <joe@perches.com>,
        John Heenan <john@zgus.com>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] rtl8xxxu: Fix for bogus data used to determine
 macpower
Message-ID: <20161110224535.GA31931@testbox> (sfid-20161110_235346_526128_5968065A)
References: <CANf5e8aQ+HZz47M3-4+qjsG=ZCaXhBFU_jVupLqT4rEYT2LQFQ@mail.gmail.com>
 <wrfjh97i11vw.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <wrfjh97i11vw.fsf@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 08, 2016 at 09:29:07AM -0500, Jes Sorensen wrote:
> Dave Jones <s.dave.jones@gmail.com> writes:
> > On Fri, Nov 04, 2016 at 09:56:00AM -0400, Jes Sorensen wrote:
> >>
> >> Joe Perches <joe@perches.com> writes:
> >> > On Sun, 2016-10-30 at 19:02 -0400, Jes Sorensen wrote:
> >> >> Code is 80 characters wide, and comments are /* */ never the ugly C++
> >> >> crap.
> >> >
> >> > You might look at the recent Linus Torvalds authored commit
> >> > 5e467652ffef (?printk: re-organize log_output() to be more legible")
> >> > which does both of those: c99 // comments and > 80 columns.
> >> >
> >> > Absolutes are for zealots.
> >>
> >> What Linus does in his code, is totally up to him. What I pull into the
> >> driver that *I* maintain, is up to me. It is perfectly normal to expect
> >> submitters to respect the coding style of the piece of code they are
> >> trying to edit.
> >
> > Bullshit.  It's perfectly normal to respect Linux coding style described in
> > Documentation/CodingStyle.  Now let's back to the topic, could you
> > apply John's patch or you just wanna improve your driver is 100% bug free?
> 
> First of all, I call for proper CodingStyle to be applied to my driver,
> and I expect someone posting a patch to respect the codingstyle of the
> driver in question. It is simple respect for the code. If you consider
> that BS - that is on you!
> 
> Second I am NOT applying that patch as I have stated repeatedly because
> I am not convinced it is safe to do so and it changes the code flow for
> one type of chip and not the rest. In addition it uses a broken approach
> to doing chip specific changes.
> 
> In short, the patch is broken!
> 
> Jes


Jes is correct not to accept the patch. It is just a hack that in one
particular situation gets around a problem with the driver. It doesn't do
anything towards fixing the issue.

Barry

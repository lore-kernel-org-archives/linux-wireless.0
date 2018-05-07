Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:60208 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751135AbeEGJxR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 05:53:17 -0400
Message-ID: <1525686793.6049.5.camel@sipsolutions.net> (sfid-20180507_115331_668368_86721E3B)
Subject: Re: WARNING in kernfs_add_one
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzbot+df47f81c226b31d89fb1@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Tejun Heo <tj@kernel.org>
Date: Mon, 07 May 2018 11:53:13 +0200
In-Reply-To: <CACT4Y+bWW8w7RJ1roUQ8dDk5Fv0syDsKtMH1wRnkkN4nWOootQ@mail.gmail.com> (sfid-20180507_113356_594681_C2241104)
References: <0000000000000390eb056b77596d@google.com>
         <20180505164041.GD7746@kroah.com>
         <095bc684-0029-0b2e-5e28-23376174ca02@gmail.com>
         <20180505220721.GA10829@kroah.com>
         <1525682589.6049.4.camel@sipsolutions.net>
         <CACT4Y+bWW8w7RJ1roUQ8dDk5Fv0syDsKtMH1wRnkkN4nWOootQ@mail.gmail.com>
         (sfid-20180507_113356_594681_C2241104)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-05-07 at 11:33 +0200, Dmitry Vyukov wrote:
> On Mon, May 7, 2018 at 10:43 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Sat, 2018-05-05 at 15:07 -0700, Greg KH wrote:
> > 
> > > > > > syzbot found the following crash on:
> > 
> > Maybe it should learn to differentiate warnings, if it's going to set
> > panic_on_warn :-)
> 
> How?
> Note that this is not specific to syzbot. If you see WARNINGs in a
> subsystem that you have no idea about (or you just a normal user),
> what do you do? Right, you report it to maintainers.

Yeah, no problem with that. Just some people seem to get so much more
upset about crashes ... but then again I get bug reports about WARN_ON
all the time anyway that say "my kernel crashed" so I guess it doesn't
really matter :-)

> > I get why, but still, at least differentiating in the emails wouldn't be
> > bad.
> 
> Well, the subject says "WARNING".
> But note there are _very_ bad WARNINGs too. Generally, a WARNING means
> a kernel bug just that kernel can tolerate without bringing the system
> down (as opposed to BUG).

Yeah, fair point. I sort of missed the subject I guess.

johannes

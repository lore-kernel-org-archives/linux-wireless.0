Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18292 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751577AbdF3Hre (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Jun 2017 03:47:34 -0400
Date: Fri, 30 Jun 2017 09:47:29 +0200
From: Karel Zak <kzak@redhat.com>
To: kerolasa@gmail.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless@vger.kernel.org,
        util-linux <util-linux@vger.kernel.org>
Subject: Re: rfkill(8) move and improvements
Message-ID: <20170630074729.s3gknfobabgepk4h@ws.net.home> (sfid-20170630_094738_020040_A2ABA24E)
References: <alpine.LNX.2.20.1706251339500.25762@imuri>
 <1498745040.3141.6.camel@sipsolutions.net>
 <CAG27Bk0tKzqxkm6qqjGO6GJE7vxReRAQbvYGexjp+PBLo+RK_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAG27Bk0tKzqxkm6qqjGO6GJE7vxReRAQbvYGexjp+PBLo+RK_A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 29, 2017 at 10:23:12PM +0100, Sami Kerola wrote:
> On 29 June 2017 at 15:04, Johannes Berg <johannes@sipsolutions.net> wrote:
> >> The otherday I ran powertop and it did rfkill to save battery, which
> >> was particularly annoying because I had not installed rfkill(8)
> >> package.
> >> Fixing the immediate issue was relatively easy, but the ordeal made
> >> me wonder if this tool could be moved to a package that is installed
> >> by default to all systems, such as util-linux.
> >
> > [...]
> >
> >> What do you think, would the move and proposed updates be ok?
> >
> > I can't say I mind, and most of your proposed changes seem sensible,
> > though I haven't reviewed them in enough detail to comment on them.
> > Something that caught my eye here was comparing a string to _("all")
> > which seems wrong, since that'd mean you'd have to type the translated
> > version even on the command line? That seems really awkward (to put it
> > charitably).
> >
> > However, at the same time, I have very little desire to get involved
> > with util-linux as yet another project, so frankly I'd probably
> > continue to "maintain" the current rfkill tool - which really hasn't
> > changed in a very long time, and hope somebody else picks up
> > maintenance of rfkill included in util-linux.
> 
> Hello Johannes,
> 
> Thank you for feedback. I removed the rfkill command strings from
> translations, and gave hint to translators how to deal with them in
> usage() output. Also in same go updates are rebased on top of
> most recent upstream to get usage() --help and --version handling
> done correctly.
> 
> What comes  to maintenance I am fairly optimistic util-linux is a
> good home for the rfkill. Karel, what do you think?

I have no problem with it, if Johannes agree with this step. We have
definitely manpower to maintain it.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com

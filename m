Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:35967 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751776AbdF2VXN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 17:23:13 -0400
MIME-Version: 1.0
Reply-To: kerolasa@gmail.com
In-Reply-To: <1498745040.3141.6.camel@sipsolutions.net>
References: <alpine.LNX.2.20.1706251339500.25762@imuri> <1498745040.3141.6.camel@sipsolutions.net>
From: Sami Kerola <kerolasa@iki.fi>
Date: Thu, 29 Jun 2017 22:23:12 +0100
Message-ID: <CAG27Bk0tKzqxkm6qqjGO6GJE7vxReRAQbvYGexjp+PBLo+RK_A@mail.gmail.com> (sfid-20170629_232335_924485_436B2EF3)
Subject: Re: rfkill(8) move and improvements
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>, Karel Zak <kzak@redhat.com>,
        linux-wireless@vger.kernel.org,
        util-linux <util-linux@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 June 2017 at 15:04, Johannes Berg <johannes@sipsolutions.net> wrote:
>> The otherday I ran powertop and it did rfkill to save battery, which
>> was particularly annoying because I had not installed rfkill(8)
>> package.
>> Fixing the immediate issue was relatively easy, but the ordeal made
>> me wonder if this tool could be moved to a package that is installed
>> by default to all systems, such as util-linux.
>
> [...]
>
>> What do you think, would the move and proposed updates be ok?
>
> I can't say I mind, and most of your proposed changes seem sensible,
> though I haven't reviewed them in enough detail to comment on them.
> Something that caught my eye here was comparing a string to _("all")
> which seems wrong, since that'd mean you'd have to type the translated
> version even on the command line? That seems really awkward (to put it
> charitably).
>
> However, at the same time, I have very little desire to get involved
> with util-linux as yet another project, so frankly I'd probably
> continue to "maintain" the current rfkill tool - which really hasn't
> changed in a very long time, and hope somebody else picks up
> maintenance of rfkill included in util-linux.

Hello Johannes,

Thank you for feedback. I removed the rfkill command strings from
translations, and gave hint to translators how to deal with them in
usage() output. Also in same go updates are rebased on top of
most recent upstream to get usage() --help and --version handling
done correctly.

What comes  to maintenance I am fairly optimistic util-linux is a
good home for the rfkill. Karel, what do you think?

-- 
Sami Kerola
http://www.iki.fi/kerolasa/

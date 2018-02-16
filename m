Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:58992 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1032862AbeBPOE0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 09:04:26 -0500
Message-ID: <1518789861.7832.54.camel@coelho.fi> (sfid-20180216_150432_783400_E2E019C5)
From: Luca Coelho <luca@coelho.fi>
To: Steve deRosier <derosier@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 16 Feb 2018 16:04:21 +0200
In-Reply-To: <CALupW3BbupwudkZw2=C8RvU0PYkk8=+TtV4SxcYH+uxh6WmZew@mail.gmail.com>
References: <CALupW3BbupwudkZw2=C8RvU0PYkk8=+TtV4SxcYH+uxh6WmZew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: Presentation at ELC on debugging wifi modules
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-02-12 at 22:09 -0800, Steve deRosier wrote:
> Hi Linux Wireless driver maintainers,

Hi Steve,


> I'm giving a talk at ELC NA next month in Portland and I'd like a
> little help from our other driver maintainers. The talk is titled:
> "Reliable Linux Wireless - Techniques for Debugging Wireless Module
> Integrations". While I'm familiar with a fairly wide variety of WiFi
> chips and adapters and drivers, I don't know them all. I will speak
> from my experience and I'm sure I won't have time to get into the
> detailed ins-and-outs of every driver, but I'd love to include value
> for everyone no matter which wifi chip vendor the audience member is
> using.

That's a very nice initiative!

> 
> So, if you have any specific tips or tricks you'd like to share with
> me so I can include them in the materials for my talk I would
> appreciate it.  I'm looking for those harder to find things: the
> little known debugfs knobs, module parameters, device tree bindings,
> and so on. Or, those things that are are common tripping up points.
> Anything you find useful or think others might.
> 
> Also, part of my talk will be about how to reach out to those of us
> on
> the list for help. We all know the calls for help come to us in
> varying quality and I'd like to explain all the stuff to do first and
> all the information to gather and send to us as they reach out. So
> please send me any thoughts on what you'd like to see in the emails
> when people ask for help.

We have this wiki:

https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/debugging

I don't think this qualifies as "hard to find", but it's where we point
people to whenever they come asking for help with iwlwifi.  If those
instructions are followed, we can get pretty much all the information
we need to start debugging, though in some cases we may need to provide
a modified firmware that enables a bit more data in the logs.  But this
usually is only needed after a few rounds of debugging and must be done
on a case-by-case basis.


> You're welcome to do it on-list if you desire to elicit discussion,
> but in order to keep the noise down feel free to reply to me directly
> off-list.

I reckoned that replying to the list is better because people who are
not able to attend your talk may also benefit. :)

If you have any suggestions on how to improve our wiki or if you find
out that something is missing, please let us know. ;)


--
Cheers,
Luca.

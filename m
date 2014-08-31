Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:60907 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbaHaU4X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Aug 2014 16:56:23 -0400
Date: Sun, 31 Aug 2014 22:55:52 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Nate Carlson <linux-wireless@natecarlson.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Borislav Boev <borislavboev@hotmail.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: Poor wifi performance on Intel 7260 Dual-Band AC Wifi card
Message-ID: <20140831205552.GA14054@sig21.net> (sfid-20140831_225637_930947_715AEC42)
References: <BAY178-W38CA42DFDD4031D453FB48CFF80@phx.gbl>
 <53D7AEF5.5040907@lwfinger.net>
 <alpine.DEB.2.02.1407290946100.1431@admin.chi.technicality.org>
 <20140730110829.GA3563@sig21.net>
 <20140829145002.GA28486@sig21.net>
 <CANUX_P0aUiv+1_bitXTNPpODU55fA74oZ2X_MWOf0dXRUSOvTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CANUX_P0aUiv+1_bitXTNPpODU55fA74oZ2X_MWOf0dXRUSOvTA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 31, 2014 at 08:26:34PM +0300, Emmanuel Grumbach wrote:
> On Fri, Aug 29, 2014 at 5:50 PM, Johannes Stezenbach <js@sig21.net> wrote:
> >
> >> Otherwise I'm hoping Intel guys could provide some guidance for
> >> testing so we could find the root cause.
> >
> > So far Intel did not show much interest in the issue, but
> > a laptop user often has no control on the AP (travelling,
> > hotels, conferences, etc.).  IMHO Intel would their users
> > a big favor if they spent some time optimizing for bad
> > network conditions.  The broken AP on my side will be
> > replaced soon, but that's not the point of my complaint.
> >
> >
> 
> So far - I was busy with other stuff - and will still be.
> After all, debugging issues we have with a completely broken AP isn't
> my top priority.
> And just for the record - can you share the progress you are having
> with the AP manufacturer? After all - this is the real bug - but you
> seem to complain about Intel more than the AP manufacturer... Strange
> isn't it?

I can't be bothered to talk to the AP manufacturer, this AP will
soon be history and current hardware revisions of it have a
different chipset.  You see its beacon bug went unnoticed for
~2 years because every other device worked without issues with it.
But the AP isn't the issue, and I only mentioned bug 78101 in this
thread because I thought it would be unfair to talk about performance
comparisons and not mention it.

Wrt $subject, I heard so many people complain about Wifi performance
and connection issues (not limited to Intel hardware), and I had my
share of it, too.  But usually a user doesn't have a clue
what is causing the problem, it could be the AP or "the internet"
or the microwave oven.  And since the own laptop is working well at
home they don't suspect it is the laptop's Wifi adapter.  I certainly
didn't, and only found out by accident because I have a bunch of USB
Wifi dongles for testing with some embedded systems and noticed
the embedded boards get much better performance than my two Thinkpads
(one AC 7260 and one Ultimate-N 6300 AGN).

Bottom line is that I would like to encourage others to do similar
comparisons against USB dongles in the 10€ price range.

Because apparently you seem to think there is no problem, because
people are not complaining, while I think there is the possibility
that people are not complaining because they are not aware who
to complain to.  (I do recognize the posibility that noone
else has the same performance issues that I have, but how to find out?)


Regarding the Windows comparison, I did it mainly because I wanted to
see if I remembered correctly that it worked without any issues
(I went through the Windows update procedure that one is more or less
forced to do on first-time use, which means a few 100 MB download,
before saving and image and wiping the disk).
And I was somewhat suprised to see that even the Windows driver
has substandard performance compared to the cheap USB dongle.


Thanks,
Johannes

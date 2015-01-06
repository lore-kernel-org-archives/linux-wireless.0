Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60877 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbbAFTDA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 14:03:00 -0500
Message-ID: <1420570976.1966.34.camel@sipsolutions.net> (sfid-20150106_200304_519943_B9662663)
Subject: Re: [PATCH 1/3] mac80211: consider only relevant vifs for
 radar_required calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 06 Jan 2015 20:02:56 +0100
In-Reply-To: <CAB3XZEctcBuPG6f4ZrZFV5O3Z7+hi+ShFdwvFXdJovG2KeAufQ@mail.gmail.com> (sfid-20150106_195729_910977_930DB9CB)
References: <1420366399-31535-1-git-send-email-eliad@wizery.com>
	 <1420542274.1966.21.camel@sipsolutions.net>
	 <1420553111.1966.32.camel@sipsolutions.net>
	 <1420553688.1966.33.camel@sipsolutions.net>
	 <CAB3XZEctcBuPG6f4ZrZFV5O3Z7+hi+ShFdwvFXdJovG2KeAufQ@mail.gmail.com>
	 (sfid-20150106_195729_910977_930DB9CB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-06 at 20:57 +0200, Eliad Peller wrote:
> On Tue, Jan 6, 2015 at 4:14 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Tue, 2015-01-06 at 15:05 +0100, Johannes Berg wrote:
> >> On Tue, 2015-01-06 at 12:04 +0100, Johannes Berg wrote:
> >> > all three applied.
> >>
> >> Nope, dropped patch 2 again
> >
> > And dropped the other two also - with them the sequence of two tests I
> > was looking at never completes.
> >
> err... sorry about that.
> i'll look into it.

I think there's probably two bugs - the test suite should wait for all
the DFS stuff to finish.

But the fact that it never completes now is strange, maybe somehow radar
detection doesn't get turned off properly after your patches?

johannes


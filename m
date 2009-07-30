Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:16236 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbZG3KGC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 06:06:02 -0400
MIME-Version: 1.0
In-Reply-To: <1248947740.8925.12.camel@johannes.local>
References: <1248945770.7910.24.camel@marge.simson.net>
	 <1248946195.8925.9.camel@johannes.local>
	 <1248947099.8396.6.camel@marge.simson.net>
	 <1248947740.8925.12.camel@johannes.local>
Date: Thu, 30 Jul 2009 11:06:00 +0100
Message-ID: <efe7343f0907300306o44d0e718p2880b7406a38fc6a@mail.gmail.com>
Subject: Re: [wireless] rt2870sta BUGs on shutdown, 2.6.30.2->git.today+git.wireless.today
From: Luis Correia <luis.f.correia@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-wireless@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mike,

On Thu, Jul 30, 2009 at 10:55, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Thu, 2009-07-30 at 11:44 +0200, Mike Galbraith wrote:
>> On Thu, 2009-07-30 at 11:29 +0200, Johannes Berg wrote:
>> > On Thu, 2009-07-30 at 11:22 +0200, Mike Galbraith wrote:
>> >
>> > > drivers/staging/rt2870/../rt2860/sta_ioctl.c
>> >
>> > Sorry, but that '/staging/' thing in there means we cannot support this.
>> > If you must, take your query to the staging list,
>> > devel@driverdev.osuosl.org (according to MAINTAINERS).
>>
>> Forwarded, thanks.
>>
>> ....hm.  Does "If you must" mean reports aren't welcome?
>
> To be honest, I don't know. I'd rather see people use the rt2x00 code
> instead of spending time cleaning up that mess (the code you've pasted
> was pretty bad!). But you may or may not find somebody who cares about
> that, just rather unlikely on this list.

What is appreciated is people with time to compare both code paths,
and report some inconsistancies, specially about card initialization
and general handling.

To be hones, we, the rt2x00 team, find Ralink's code to be very
difficult to follow, and combersome most of the times.

But any help is welcome!

>
> johannes
>

Luis Correia
rt2x00 project admin

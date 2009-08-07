Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51896 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625AbZHGPBI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 11:01:08 -0400
Date: Fri, 7 Aug 2009 10:55:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Jiri Slaby <jirislaby@gmail.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] [PATCH 4/4] ath5k: Use SWI to trigger calibration
Message-ID: <20090807145555.GD7545@tuxdriver.com>
References: <20090731181020.GE7963@makis> <20090801054649.GA8390@makis> <4A73FA8D.5030804@gmail.com> <1249114918.26584.18.camel@johannes.local> <4A73FBBD.3070507@gmail.com> <1249115316.2007.0.camel@johannes.local> <40f31dec0908031054m3b8231fdrf36f363702218116@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0908031054m3b8231fdrf36f363702218116@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 03, 2009 at 08:54:47PM +0300, Nick Kossifidis wrote:
> 2009/8/1 Johannes Berg <johannes@sipsolutions.net>:
> > On Sat, 2009-08-01 at 10:24 +0200, Jiri Slaby wrote:
> >> On 08/01/2009 10:21 AM, Johannes Berg wrote:
> >> > Actually, jiffies are unsigned long
> >>
> >> Yeah, this is what I meant. I agree I messed it up when I didn't write
> >> the unsigned explicitly. It might have been confusing, thanks for
> >> pointing out.
> >
> > And, in addition to what you said, the code shouldn't divide jiffies, it
> > should multiply the timeout, add it to the start time, and then use
> > time_is_after_jiffies() or so.
> >
> > johannes
> 
> ACK will resend asap ;-)

Last I saw in this thread...

Can we have a clean repost of the whole series (including proper
Signed-off-by and any Acked-by, Tested-by, etc)?  Also, in the future
I think it would be good for you to take some of the comments from
Luis to heart -- explain the 'why' not the 'what' in the changelogs,
do one thing per patch, etc.

I'm going to drop the original 1-4 now and wait for a clean repost.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

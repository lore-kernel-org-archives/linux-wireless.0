Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53237 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933994Ab0HJXFV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 19:05:21 -0400
Subject: Re: [WTF, maintainers] Re: *PING* iwlagn 2.6.35: "BA scd_flow 0
 does not 	match txq_id 10" regression
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
In-Reply-To: <AANLkTinuYOvwNZAFgq67f4XBL4YQ+b2z4EBMcmvbMYi3@mail.gmail.com>
References: <AANLkTim4_HoHwdhGqAZqcGf2oq7boktdZFW4-w5DpdDa@mail.gmail.com>
	 <AANLkTinuYOvwNZAFgq67f4XBL4YQ+b2z4EBMcmvbMYi3@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 10 Aug 2010 16:05:05 -0700
Message-Id: <1281481505.20038.10.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrew,

On Tue, 2010-08-10 at 14:39 -0700, Andrew Lutomirski wrote:
> On Mon, Jul 26, 2010 at 4:02 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> > There's a regression in 2.6.35 where the connection breaks and iwlagn
> > writes a bunch of:
> >
> > iwlagn 0000:03:00.0: BA scd_flow 0 does not match txq_id 10
> >
> > This is confirmed [1] and a patch supposedly exists.  Since this
> > breaks at least two people's wireless and 2.6.35 is about to be
> > released, can we see the patches?
> >
> > Thanks,
> > Andy
> >
> > [1] http://article.gmane.org/gmane.linux.kernel.wireless.general/53552
> >
> 
> This regression was reported on July 21 and confirmed, supposedly with
> a patch available, on July 24 (or maybe July 23).  On July 26 I pinged
> the list because I'm affected as well.
> 
> It's now August 10 and both 2.6.35 and 2.5.35.1 have been released and
> the bug is still there.  WTF happened?  (I admit I haven't actually
> tested 2.6.35.1 because it's still compiling, but I see nothing to
> suggest that it's been fixed.)
> 

Sorry for the delay, the problem you report is a real problem in our
uCode; unfortunately, we still not root cause the real problem yet. The
patch I provide previous just a hack and still waiting for our internal
validation team to make sure it did not break the overall behaviors.

I will submit the patch as soon as I got the report back from our test
team; at the meantime, we are very active work on root cause the real
problem. Once we have the possible solution, it will be great if you can
help us to verify it.

Best regards
Wey 
> 
> P.S.  iwlagn malfunctions for me *all the time*.  I'd love to help
> debug but it's hard when no one pays attention and when the bugs are
> all hard to trigger.  Any volunteers to help?


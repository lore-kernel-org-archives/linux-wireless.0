Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:58997 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753124Ab0KDVr2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 17:47:28 -0400
Subject: Re: [RFC 00/15] Implementation of periodic scan
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288885867.3659.8.camel@jlt3.sipsolutions.net>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
	 <1288885867.3659.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 23:46:08 +0200
Message-ID: <1288907168.17643.12.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for your review, Johannes!

On Thu, 2010-11-04 at 16:51 +0100, ext Johannes Berg wrote:
> On Mon, 2010-11-01 at 13:52 +0200, Luciano Coelho wrote:
> 
> >   This set doesn't support variable intervals, and the intervals
> > need to be configure in the hw driver.
> 
> which is wrong -- you really want that to be configurable.

Yes, for sure I will.  I'm already working on it.  It's a requirement
for us.


> > This is an initial implementation and I'd like to get some comments before
> > submitting the final version.
> > 
> > I've split the implementation in many small patches, just to keep it clear
> > and due to the zillions of times I've had to task switch while implementing
> > this.  I can merge some of them, if that makes things cleaner.
> 
> Absolutely, the patch splitting is total crap :-) Heck, you even write
> code only to remove/change it again!

Indeed! I would never have accepted patches split up like this
myself! :P My excuse is that I've been multitasking heavily lately and,
knowing how buggy the task-switching implementation is in my brain, I
reckoned it would be safer to commit often.

Tomorrow I'll fix these issues and send a new version.

-- 
Cheers,
Luca.


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:3566 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256AbYAJR3J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 12:29:09 -0500
Received: by fk-out-0910.google.com with SMTP id z23so542993fkz.5
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2008 09:29:07 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Rt2400-devel] Please pull 'upstream' branch of rt2x00
Date: Thu, 10 Jan 2008 18:29:02 +0100
Cc: Will Dyson <will.dyson@gmail.com>, linux-wireless@vger.kernel.org,
	rt2400-devel@lists.sourceforge.net
References: <200801062337.35904.IvDoorn@gmail.com> <8e6f94720801100352t615025b6j1c2cc0081626fee5@mail.gmail.com> <20080110154654.GC3109@tuxdriver.com>
In-Reply-To: <20080110154654.GC3109@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801101829.02438.IvDoorn@gmail.com> (sfid-20080110_172913_016501_24F05794)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 10 January 2008, John W. Linville wrote:
> On Thu, Jan 10, 2008 at 06:52:40AM -0500, Will Dyson wrote:
> 
> > Hmm. Looking at Linus's tree, I can see that rt61pci is missing at
> > least 1 critical fix from Mattias Nissler that has been in
> > wireless-2.6 for a long time now.
> > 
> > rt2x00: Allow rt61 to catch up after a missing tx report
> > 
> > I'd be pretty disappointed if we released 2.6.24 without this. It is a
> > simple fix for a really obnoxious problem (although one that triggers
> > rarely on my hardware).
> 
> This one can be cherry-picked fairly easily for 2.6.24.  Ivo, any
> reason not to do that?

Nope, if it can be merged into 2.6.24 easily it should indeed go upstream.

> > There are also a bunch of antenna selection fixes that never went
> > upstream. These are required for my card to operate well at rates
> > greater than 1Mbit, even when fairly close to the AP.
> 
> Can you identify specific patches?  If so I can evaluate whether they
> apply easily to 2.6.24 or if they need significant rework.

I'm afraid the antenna code concerns the antenna diversity which is quite
a lot of code. I'm not sure how easily it can be merged, but I expect it to
be somewhat troublesome.

Ivo


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44007 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab0DZSpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 14:45:12 -0400
Date: Mon, 26 Apr 2010 14:32:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] ssb: Avoid system hang when SPROM read fails
Message-ID: <20100426183233.GF2387@tuxdriver.com>
References: <4bd4c284.WBohOsmgdwRzw5JC%Larry.Finger@lwfinger.net>
 <20100426171505.GC2387@tuxdriver.com>
 <4BD5D5B1.6020906@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4BD5D5B1.6020906@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 26, 2010 at 01:04:33PM -0500, Larry Finger wrote:
> On 04/26/2010 12:15 PM, John W. Linville wrote:
> > 
> > Well, the "good" news is that I hit the "Unable to read SPROM" case.
> > The bad news is that the box still hangs after the -ENODEV.  I have
> > not yet tracked-down the exact location of the current hang.
> > 
> > John
> > 
> > P.S.  Sorry about the 'radio silence' -- I've been distracted with
> > some other things.  Also, the box in question originally belonged
> > to someone else who had configured it in a way that was less than
> > friendly to kernel development.  I finally reinstalled it...
> 
> That box is certainly resistant!
> 
> I certainly understand your distractions. That has to be a major
> understatement.
> 
> As the patch makes some improvement in both your system and the one in
> Bug #15825, I'll push it as a real patch.
> 
> Would your box be available to me as a loaner? I have considered buying
> a netbook for debugging purposes, but I cannot quite justify the cost.
> In addition, Murphy's law would make whatever one I bought work without
> any problems.

I think that can be arranged...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbXEJObq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 10:31:46 -0400
Subject: Re: Please pull 'master' branch of libertas (for 2.6.22)
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070510013523.GA4544@tuxdriver.com>
References: <1178745375.9590.5.camel@localhost.localdomain>
	 <20070510013523.GA4544@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 10 May 2007 10:35:13 -0400
Message-Id: <1178807713.23307.1.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-05-09 at 21:35 -0400, John W. Linville wrote:
> On Wed, May 09, 2007 at 05:16:14PM -0400, Dan Williams wrote:
> 
> > This is latest libertas git and should be pushed to 2.6.22.  It takes
> > care of a few of Christoph's objections, including ioctl removal,
> > version.h removal, and debug define cleanups.
> > 
> > git://git.infradead.org/libertas-2.6.git
> 
> Dan,
> 
> There is a problem...the libertas-2.6 tree doesn't have a "clean"
> history.  It appears to have the entire development history of the
> libertas project.  We need something more concise and "sanitized"
> for pushing upstream.

Yeah; that sucks.  I've pulled wireless-2.6 and I'm adding
cleanup/review patches now.  What I may not be able to do, depending on
time, is fix the warnings and sparse stuff Randy brought up.

Dan

> We do not really want the patches for new development, at least not
> for 2.6.22.  Could you help identify which patches in the history
> correspond to review fixes?
> 
> I can generate a single diff, but it is huge ("34 files changed, 3069
> insertions(+), 5643 deletions(-)") and it isn't clear to me that it
> is only cleanups.  Perhaps you could split this up into a few separate
> patches?  Especially those patches specific to review comments?
> 
> I'm sorry...I know this is a PITA.  I appreciate your effort and
> cooperation.
> 
> John


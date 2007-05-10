Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4519 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbXEJCCb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2007 22:02:31 -0400
Date: Wed, 9 May 2007 21:35:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Please pull 'master' branch of libertas (for 2.6.22)
Message-ID: <20070510013523.GA4544@tuxdriver.com>
References: <1178745375.9590.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1178745375.9590.5.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 09, 2007 at 05:16:14PM -0400, Dan Williams wrote:

> This is latest libertas git and should be pushed to 2.6.22.  It takes
> care of a few of Christoph's objections, including ioctl removal,
> version.h removal, and debug define cleanups.
> 
> git://git.infradead.org/libertas-2.6.git

Dan,

There is a problem...the libertas-2.6 tree doesn't have a "clean"
history.  It appears to have the entire development history of the
libertas project.  We need something more concise and "sanitized"
for pushing upstream.

We do not really want the patches for new development, at least not
for 2.6.22.  Could you help identify which patches in the history
correspond to review fixes?

I can generate a single diff, but it is huge ("34 files changed, 3069
insertions(+), 5643 deletions(-)") and it isn't clear to me that it
is only cleanups.  Perhaps you could split this up into a few separate
patches?  Especially those patches specific to review comments?

I'm sorry...I know this is a PITA.  I appreciate your effort and
cooperation.

John
-- 
John W. Linville
linville@tuxdriver.com

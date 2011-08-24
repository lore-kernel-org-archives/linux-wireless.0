Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr20.hinet.net ([168.95.4.120]:53514 "EHLO msr20.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898Ab1HXBmr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 21:42:47 -0400
Date: Wed, 24 Aug 2011 09:42:57 +0800
From: Ali Bahar <ali@internetdog.org>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] staging: r8712u: Most return-values changed from -1
 to proper errno macros.
Message-ID: <20110824014257.GB20603@internetdog.org> (sfid-20110824_034252_567221_DAF5CF78)
Reply-To: ali@internetdog.org
References: <1310799573-4407-1-git-send-email-ali@internetDog.org>
 <20110823195239.GA17945@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110823195239.GA17945@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 23, 2011 at 12:52:39PM -0700, Greg KH wrote:
> On Sat, Jul 16, 2011 at 02:59:33PM +0800, Ali Bahar wrote:
> > The ioctl handlers were frequently returning -1 upon failure. Most of
> > these have now been changed to proper errno macros.
> > The few remaining ones have been left untouched because either the
> > handler is not called (and so cannot be tested), or the function never
> > fails (and so cannot be system-tested), or requires new code to
> > distinguish its failures.
> > 
> > Signed-off-by: Ali Bahar <ali@internetDog.org>
> > Cc: Larry Finger <Larry.Finger@lwfinger.net>
> 
> This fails to apply cleanly anymore, can you refresh it, and your other
> outstanding patches and resend?

At this point, it is best to send this _on top of_ the Realtek-merge
patches, even though the latter are more prone to revisions.

So the new patch set will include the merge changes, and the above
("return-values") changes, with the latter to be applied _on top of_
the former. I'll put a reminder of this in the submission email.

regards,
ali
 
> thanks,
> 
> greg k-h

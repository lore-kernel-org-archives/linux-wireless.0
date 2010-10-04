Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48263 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab0JDSpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 14:45:07 -0400
Date: Mon, 4 Oct 2010 14:33:44 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Joe Perches <joe@perches.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: remove spurious __KERNEL__ ifdef
Message-ID: <20101004183344.GA2592@tuxdriver.com>
References: <1285874485.5137.16.camel@jlt3.sipsolutions.net>
 <1285875417.9599.40.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1285875417.9599.40.camel@Joe-Laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 30, 2010 at 12:36:57PM -0700, Joe Perches wrote:
> On Thu, 2010-09-30 at 21:21 +0200, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > The net/cfg80211.h header file isn't exported to
> > userspace, so there's no need for any kind of
> > __KERNEL__ protection in it. If it was exported,
> > everything else in it would need protection as
> > well, not just the logging stuff ...
> > 
> > Cc:Joe Perches <joe@perches.com>
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> > Might be something that slipped in elsewhere too?
> 
> I thought John was going to remove that guard.
> 
> http://lkml.org/lkml/2010/7/27/294
> 
> I believe John removed the other one.

Sorry, I must have forgotten... :-(

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

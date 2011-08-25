Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:44488 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752991Ab1HYCp5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 22:45:57 -0400
Subject: Re: [PATCH v2] Move brcm80211 to mainline
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>
Cc: Henry Ptasinski <henryp@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
In-Reply-To: <20110825022352.GA4876@suse.de>
References: <20110707002034.GA17885@broadcom.com>
	 <20110824222801.GA5280@broadcom.com> <20110824225357.GA2224@suse.de>
	 <20110824231746.GF5280@broadcom.com> <1314230068.15882.15.camel@Joe-Laptop>
	 <20110825004211.GC7577@broadcom.com>  <20110825022352.GA4876@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Aug 2011 19:45:55 -0700
Message-ID: <1314240355.15882.28.camel@Joe-Laptop> (sfid-20110825_044611_738996_0B087519)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-24 at 19:23 -0700, Greg KH wrote:
> On Wed, Aug 24, 2011 at 05:42:11PM -0700, Henry Ptasinski wrote:
> > On Wed, Aug 24, 2011 at 04:54:28PM -0700, Joe Perches wrote:
> > > On Wed, 2011-08-24 at 16:17 -0700, Henry Ptasinski wrote:
> > > > Augh.  I included the wrong link.  Correct link:
> > > > http://linuxwireless.org/en/users/Drivers/brcm80211?action=AttachFile&do=get&target=0001-wireless-testing-add-brcm80211-v2.patch
> > > 
> > > Can't you post the patch with git format-patch -M instead?
> > 
> > This patch drops in a new copy of all the files, as there's been significant
> > change since the last time staging-next and wireless-testing were in sync.
> > (Deleting the existing files from staging will be a separate step.)
> > 
> > I can generate a two-patch series instead: one to catch up wireless-testing
> > with all the changes that have been applied to the brcm80211 drivers in
> > staging, and then a second patch with a 'git mv' plus necessary
> > Kconfig/Makefile changes. The first patch would still be quite large, but I'm
> > ok with either approach.
> Don't worry about that now, the real thing is a review of the code.

A 2.8MB patch is _way_ too large to review.

The reviewing should take place of posted patches
to staging, not wireless-testing.

And I believe that's not an RFC patch, but the actual
patch to be applied.

If so, I think that the right way to do that is not
copy but a merge.


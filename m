Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4083 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab1HYBML (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 21:12:11 -0400
Date: Wed, 24 Aug 2011 18:11:52 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Joe Perches" <joe@perches.com>
cc: "Greg KH" <gregkh@suse.de>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Message-ID: <20110825011152.GC11501@broadcom.com> (sfid-20110825_031215_400046_AB78DE54)
References: <20110707002034.GA17885@broadcom.com>
 <20110824222801.GA5280@broadcom.com> <20110824225357.GA2224@suse.de>
 <20110824231746.GF5280@broadcom.com>
 <1314230068.15882.15.camel@Joe-Laptop>
 <20110825004211.GC7577@broadcom.com>
 <1314233552.15882.23.camel@Joe-Laptop>
MIME-Version: 1.0
In-Reply-To: <1314233552.15882.23.camel@Joe-Laptop>
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2011 at 05:52:32PM -0700, Joe Perches wrote:
> On Wed, 2011-08-24 at 17:42 -0700, Henry Ptasinski wrote:
> > On Wed, Aug 24, 2011 at 04:54:28PM -0700, Joe Perches wrote:
> > > On Wed, 2011-08-24 at 16:17 -0700, Henry Ptasinski wrote:
> > > > Augh.  I included the wrong link.  Correct link:
> > > > http://linuxwireless.org/en/users/Drivers/brcm80211?action=AttachFile&do=get&target=0001-wireless-testing-add-brcm80211-v2.patch
> > > Can't you post the patch with git format-patch -M instead?
> > This patch drops in a new copy of all the files, as there's been significant
> > change since the last time staging-next and wireless-testing were in sync.
> > (Deleting the existing files from staging will be a separate step.)
> > 
> > I can generate a two-patch series instead: one to catch up wireless-testing
> > with all the changes that have been applied to the brcm80211 drivers in
> > staging, and then a second patch with a 'git mv' plus necessary
> > Kconfig/Makefile changes. The first patch would still be quite large, but I'm
> > ok with either approach.
> 
> I think that's the better approach, though I wonder
> why you need to update wireless-testing at all.
> 
> Can't you do a delete from wireless-testing
> and then a move from staging?

How do you do a move across git repos?

If John could do a pull of just drivers/staging/brcm80211 from staging-next
into wireless-testing to get just those files in sync, then a 'git mv' from
drivers/staging to drivers/net/wireless within wireless-testing would be
trivial.  I don't know if such a pull is possible, but maybe somebody else
knows how and can enlighten me.

- Henry


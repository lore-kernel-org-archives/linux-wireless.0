Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1524 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab1HXXSC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 19:18:02 -0400
Date: Wed, 24 Aug 2011 16:17:46 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Greg KH" <gregkh@suse.de>
cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Message-ID: <20110824231746.GF5280@broadcom.com> (sfid-20110825_011806_291837_334885B7)
References: <20110707002034.GA17885@broadcom.com>
 <20110824222801.GA5280@broadcom.com> <20110824225357.GA2224@suse.de>
MIME-Version: 1.0
In-Reply-To: <20110824225357.GA2224@suse.de>
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2011 at 03:53:57PM -0700, Greg KH wrote:
> On Wed, Aug 24, 2011 at 03:28:01PM -0700, Henry Ptasinski wrote:
> > With the latest series of cleanup patches merged in by Greg KH, I'd like to
> > once again propose moving brcm80211 out of staging and into mainline.
> > 
> > I've put together a patch to add a copy of the current sources from
> > staging-next into wireless-testing:drivers/net/wireless/brcm80211.
> > 
> > The patch is somewhat large, so I've posted the patch at:
> > 
> > http://linuxwireless.org/en/users/Drivers/brcm80211?action=AttachFile&do=get&target=0001-wireless-testing-add-brcm80211.patch
> > 
> > Changes from the previous version:
> > 
> > V2:
> > - Resolve checkpatch issues
> 
> Really?  All of them?  What's with all of the use of 'volatile' in the
> driver still?  Those should all be resolved as they are all wrong from
> what I can see.
> 
> Wait, those usages are in your above mentioned patch, but are not in the
> current driver in the staging-next tree.  Did you mess up when creating
> that patch and take an older version of the driver?
> 
> confused,
> 
> greg k-h
> 

Augh.  I included the wrong link.  Correct link:

http://linuxwireless.org/en/users/Drivers/brcm80211?action=AttachFile&do=get&target=0001-wireless-testing-add-brcm80211-v2.patch

(Note the '-v2'.)

Very sorry about that.

- Henry



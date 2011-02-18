Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:45127 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab1BRDGB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 22:06:01 -0500
Date: Thu, 17 Feb 2011 19:05:39 -0800
From: Greg KH <gregkh@suse.de>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"kernel@fomichev.me" <kernel@fomichev.me>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>
Subject: Re: [PATCH v2 1/4] brcm80211: fix compile issue
Message-ID: <20110218030539.GE17143@suse.de>
References: <1297721111-20606-1-git-send-email-kernel@fomichev.me>
 <7A94256FD72B884D9E7C55586C3CBCEE13CDA25D88@SJEXCHCCR01.corp.ad.broadcom.com>
 <20110215221200.GA2087@sdf-MacBook>
 <4D5B0034.3090303@broadcom.com>
 <20110216015040.GA2349@tuxdriver.com>
 <4D5DDD7A.4080801@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D5DDD7A.4080801@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 17, 2011 at 06:46:18PM -0800, Henry Ptasinski wrote:
> On 02/15/2011 05:50 PM, John W. Linville wrote:
> >On Tue, Feb 15, 2011 at 02:37:40PM -0800, Henry Ptasinski wrote:
> >>On 02/15/2011 02:12 PM, Stanislav Fomichev wrote:
> >>>Commit 59eb21a65047 "cfg80211: Extend channel to frequency mapping for 802.11j"
> >>>changed the definition of the ieee80211_channel_to_frequency; so fix its
> >>>usage in brcmfmac.
> >>>
> >>
> >>Commit 59eb21a65047 went into wireless-next a few weeks ago, but
> >>hasn't made it over to staging-next yet.  Should John pick up this
> >>patch for wireless-next now, and it'll eventually migrate over to
> >>staging-next?
> >
> >If so, not only let me know but also resend a copy to me -- I haven't
> >been tracking these...
> 
> 
> Greg, any opinions?  See any issues with making minimally-required
> changes over in wireless-next to track mac80211 API changes that you
> haven't picked up yet?

No objection from me.

thanks,

greg k-h

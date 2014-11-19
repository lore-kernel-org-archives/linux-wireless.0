Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41076 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756784AbaKSUtC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 15:49:02 -0500
Message-ID: <1416430133.9374.29.camel@sipsolutions.net> (sfid-20141119_214909_002575_3B2B6FEF)
Subject: Re: [PATCH] brcmfmac: don't include linux/unaligned/access_ok.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	John Linville <linville@tuxdriver.com>
Date: Wed, 19 Nov 2014 21:48:53 +0100
In-Reply-To: <546D01EC.8070808@broadcom.com>
References: <1416428298-10000-1-git-send-email-johannes@sipsolutions.net>
		 <546CFF4D.7010306@broadcom.com>
	 <1416429744.9374.28.camel@sipsolutions.net> <546D01EC.8070808@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-11-19 at 21:47 +0100, Arend van Spriel wrote:
> On 11/19/14 21:42, Johannes Berg wrote:
> > On Wed, 2014-11-19 at 21:36 +0100, Arend van Spriel wrote:
> >> On 11/19/14 21:18, Johannes Berg wrote:
> >>> From: Johannes Berg<johannes.berg@intel.com>
> >>>
> >>> This is a specific implementation,<asm/unaligned.h>   is the
> >>> multiplexer that has the arch-specific knowledge of which
> >>> of the implementations needs to be used, so include that.
> >>
> >> Thanks, Johannes
> >>
> >> Maybe it would be good to mention this was found by kbuild test robot.
> >
> > Yeah, maybe. It was more or less by accident though :-)
> 
> accidents happen. The pcie stuff was added in 3.17 so my question to 
> John is whether this can go into 3.18 and stable.

Could be considered, I guess you can resend the patch with appropriate
tags? I just want wireless-next to not complain about my patch ;-)

johannes


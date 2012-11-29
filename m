Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47115 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab2K2JFb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 04:05:31 -0500
Message-ID: <1354179955.9557.1.camel@jlt4.sipsolutions.net> (sfid-20121129_100538_966311_BCCEF54F)
Subject: Re: [PATCH] cfg80211: Remove unused VHT chan code
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 29 Nov 2012 10:05:55 +0100
In-Reply-To: <50B723CF.20903@posedge.com>
References: <50B71FA3.7050304@posedge.com>
	 <1354179167.9557.0.camel@jlt4.sipsolutions.net>
	 <50B723CF.20903@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-29 at 14:28 +0530, Mahesh Palivela wrote:
> On 11/29/2012 02:22 PM, Johannes Berg wrote:
> > On Thu, 2012-11-29 at 14:11 +0530, Mahesh Palivela wrote:
> >> From: Mahesh Palivela <maheshp@posedge.com>
> >>
> >> Cleanup of unused VHT channel config related code.
> >
> > Huh, good catch, thanks. Applied.
> 
> Thanks. Even below also can be removed as cfg80211_chandef_usable() 
> checks this at the beginning.
> 
>         if (!cfg80211_chandef_valid(chandef))
>                 return -EINVAL;

Hmm good point I'll roll that in.

johannes


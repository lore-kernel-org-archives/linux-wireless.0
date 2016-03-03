Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56608 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbcCCPmj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 10:42:39 -0500
Message-ID: <1457019756.2044.27.camel@sipsolutions.net> (sfid-20160303_164243_187665_79678783)
Subject: Re: [PATCH 3/3] mac80211: recalc min_def chanctx even when chandef
 is identical
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Date: Thu, 03 Mar 2016 16:42:36 +0100
In-Reply-To: <CA+XVXfcYSJRcQZrY7qXok__+T-+AxBwQS8c9FqQH_Ata-OGXVA@mail.gmail.com> (sfid-20160303_164137_702878_0E168336)
References: <1456954113-4682-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1456954113-4682-3-git-send-email-emmanuel.grumbach@intel.com>
	 <1457019637.2044.26.camel@sipsolutions.net>
	 <CA+XVXfcYSJRcQZrY7qXok__+T-+AxBwQS8c9FqQH_Ata-OGXVA@mail.gmail.com>
	 (sfid-20160303_164137_702878_0E168336)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-03-03 at 17:41 +0200, Arik Nemtsov wrote:
> On Thu, Mar 3, 2016 at 5:40 PM, Johannes Berg <johannes@sipsolutions.
> net> wrote:
> > All three applied, but I had to fix your Fixes tag commit ID, no
> > idea
> > what that referred to :)
> 
> Yea I might have taken it from some internal tree :)
> 

Oh, actually what prompted me to look at all was that it was too short
- should be 12 hex digits.

johannes

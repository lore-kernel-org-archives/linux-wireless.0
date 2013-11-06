Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43373 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390Ab3KFMGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 07:06:38 -0500
Message-ID: <1383739595.14307.41.camel@jlt4.sipsolutions.net> (sfid-20131106_130641_045573_9300C29B)
Subject: Re: [RFC v2 2/2] mac80211: only set CSA beacon when at least one
 beacon must be transmitted
From: Johannes Berg <johannes@sipsolutions.net>
To: "Coelho, Luciano" <luciano.coelho@intel.com>
Cc: Simon Wunderlich <sw@simonwunderlich.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 06 Nov 2013 13:06:35 +0100
In-Reply-To: <1383739343.4256.58.camel@porter.coelho.fi>
References: <1383684854-21663-1-git-send-email-luciano.coelho@intel.com>
	 <1383684854-21663-2-git-send-email-luciano.coelho@intel.com>
	 <201311061247.48777.sw@simonwunderlich.de>
	 <1383739343.4256.58.camel@porter.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-06 at 12:03 +0000, Coelho, Luciano wrote:

> > Even if we don't allow count <=1 from userspace as Johannes suggested,
> 
> Ah, I had misunderstood Johannes.  I thought he meant to reject the
> patch. :P
> 
> Rejecting count <= 1 could be a temporary solution until we implement
> the action frames properly.  Unless we decide that the action frames
> should be handled in userspace as you proposed.

Well even then - the question is who would ever want to use and test
count<=1?

johannes


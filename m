Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:17888 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab0KETq4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 15:46:56 -0400
Subject: Re: [RFC 14/15] cfg80211: add ie support for periodic scans
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288885792.3659.6.camel@jlt3.sipsolutions.net>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
	 <1288612336-2830-15-git-send-email-luciano.coelho@nokia.com>
	 <1288885792.3659.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 22:01:25 +0200
Message-ID: <1288987285.25600.17.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-04 at 16:49 +0100, ext Johannes Berg wrote:
> On Mon, 2010-11-01 at 13:52 +0200, Luciano Coelho wrote:
> > Add an array of pointers to ie (one element for each band) and the respective
> > array of ie lengths.
> 
> Shouldn't this also be exposed to userspace?

Yes, it will be.  I already started working on it.  It should be
possible, like in normal scans, to pass extra IEs from userspace too.

-- 
Cheers,
Luca.


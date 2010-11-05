Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:24869 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab0KETaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 15:30:25 -0400
Subject: Re: [RFC 05/15] nl80211: call periodic_start and periodic_stop
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288885449.3659.2.camel@jlt3.sipsolutions.net>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
	 <1288612336-2830-6-git-send-email-luciano.coelho@nokia.com>
	 <1288885449.3659.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 21:44:46 +0200
Message-ID: <1288986286.25600.0.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-04 at 16:44 +0100, ext Johannes Berg wrote:
> On Mon, 2010-11-01 at 13:52 +0200, Luciano Coelho wrote:
> > Now that cfg80211 has support for periodic scan, we call those ops in the
> > nl80211 code.
> 
> Need to advertise these too in the wiphy cmd nl80211.

Yeps! Will do.

-- 
Cheers,
Luca.


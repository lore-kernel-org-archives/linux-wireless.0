Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:58547 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaKFPtA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 10:49:00 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21595.39090.446262.985148@gargle.gargle.HOWL> (sfid-20141106_164916_252920_6F97A29F)
Date: Thu, 6 Nov 2014 21:20:10 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: New WARNING from mac80211
In-Reply-To: <21595.38533.767426.846290@gargle.gargle.HOWL>
References: <545B8CD1.8020208@lwfinger.net>
	<1415286217.17015.12.camel@sipsolutions.net>
	<21595.38533.767426.846290@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
> I think this is the race described here: https://patchwork.kernel.org/patch/5095061/
> 
> I haven't tried any workaround or fix yet, but it looks like this
> race can be hit fairly often.
> 
> https://dev.openwrt.org/ticket/9654
> https://dev.openwrt.org/ticket/11862
> https://dev.openwrt.org/ticket/13542

I dug out an old trace: http://pastebin.com/raw.php?i=Qj8aXJhB

Sujith

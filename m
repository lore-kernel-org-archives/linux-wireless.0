Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46054 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab1F3Va7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 17:30:59 -0400
Subject: Re: Crash in mlme.c, wireless-testing 2.6.39-wl + hacks
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4E0CE929.7040300@candelatech.com> (sfid-20110630_232253_480125_B86CAA5E)
References: <4E0CE929.7040300@candelatech.com>
	 (sfid-20110630_232253_480125_B86CAA5E)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Jun 2011 23:30:54 +0200
Message-ID: <1309469454.3873.0.camel@jlt3.sipsolutions.net> (sfid-20110630_233102_042185_0FF4E211)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-06-30 at 14:22 -0700, Ben Greear wrote:
> We see occasional crashes in mlme.c when testing a certain
> configuration:  30 stations, configured for in-kernel authentication,
> re-configure them for supplicant, let them associate, delete one of
> them.
> 
> I added a BUG_ON in __cfg80211_mlme_deauth to check for null
> bssid and it hit.
> 
> Please note this is hacked code, so it's possible it's something
> I am doing.  I'm going to add some extra checks in this method to
> keep from crashing, but it may be a while until I can test against
> clean upstream kernels for this particular config.

It'd help if you at least said what you changed, since you say you
changed things in this area but don't say what I don't think I'll bother
looking at this.

johannes


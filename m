Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:59480 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710Ab1IVKah (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 06:30:37 -0400
Date: Thu, 22 Sep 2011 12:29:47 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Brett Rudley <brudley@broadcom.com>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Greg KH <greg@kroah.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline
 patch #2
Message-ID: <20110922122947.7aa4522b@milhouse> (sfid-20110922_123044_946087_4CFFE8A5)
In-Reply-To: <1316684675.3899.25.camel@jlt3.sipsolutions.net>
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
	<20110920130338.GA9885@kroah.com>
	<20110920132203.GB7800@tuxdriver.com>
	<20110920140020.GA11386@kroah.com>
	<7A94256FD72B884D9E7C55586C3CBCEE195814DD85@SJEXCHCCR01.corp.ad.broadcom.com>
	<CACna6rzSiH3g9y6F6t8JT4abCy0pO9v+ATCBeYmNdmNdo5BaDQ@mail.gmail.com>
	<7A94256FD72B884D9E7C55586C3CBCEE195814DE4F@SJEXCHCCR01.corp.ad.broadcom.com>
	<20110922003523.0bf6a460@milhouse>
	<1316684675.3899.25.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 22 Sep 2011 11:44:35 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> I agree that would be nice. However, I don't think that it should be
> required for brcmsmac to get into mainline, nor do I think that there
> should be a big rearchitecture for this. In fact, brcmsmac has a PHY
> abstraction layer that looks perfectly usable to me. b43 has one too,
> but it's nowhere near as fleshed out for all corner cases afaict.
> 
> Really the more important issue is support though. Rafal by himself
> cannot possibly provide the level of support we're hoping to see from
> Broadcom who I expect will eventually ship this driver to their
> customers and support it, just like they do now with the driver it is
> derived from.
> 
> Overall, the way I see it this really is a no-brainer. I really don't
> see why we're even discussing this so much.
> brcmsmac should be accepted into mainline as soon as possible (and I
> think all the recent patchsets go a long way). After that, the Broadcom
> team can easily port it to bcma, I expect that would happen within a few
> weeks. Adding features to it should be fairly simple too, and go much
> faster than adding any features to b43. (*)

I fully agree with all of that.

It is time to merge the stuff into mainline. There really is no other option.

> b43 is really my child too. I spent a very long time on the reverse
> engineering. But let's let it "die" peacefully.

We all put a lot of effort into b43, but that does not imply that we have
to beat the dead horse.

b43 has to become a second b43legacy. Which means it must go into maintenance-only mode.
Features should probably be removed, too. But that has to be done after
mainlining of brcmsmac.

Completely dropping either of b43 or brcmsmac is not an option. So, Rafal, you can still
continue to work on b43. There are _lots_ of bugs and issues to fix/improve.
If you need/want some older b43 devices, I can certainly donate some of mine to you. (I have
at least piece one of any flavor of supported 802.11g devices in stock).

-- 
Greetings, Michael.

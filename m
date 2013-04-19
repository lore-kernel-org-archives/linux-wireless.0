Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:41541 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030220Ab3DSNGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 09:06:20 -0400
Received: by mail-we0-f180.google.com with SMTP id r5so3393688wey.25
        for <linux-wireless@vger.kernel.org>; Fri, 19 Apr 2013 06:06:19 -0700 (PDT)
Date: Fri, 19 Apr 2013 15:02:04 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v2 5/5] mac80211/minstrel: use the new rate control API
Message-ID: <20130419130203.GA8341@magnum.frso.rivierawaves.com> (sfid-20130419_150624_458210_17AFC582)
References: <1366112326-92981-1-git-send-email-nbd@openwrt.org>
 <1366112326-92981-5-git-send-email-nbd@openwrt.org>
 <20130418161748.GH8638@magnum.frso.rivierawaves.com>
 <517039E4.4010707@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <517039E4.4010707@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 18, 2013 at 08:22:28PM +0200, Felix Fietkau wrote:
> On 2013-04-18 6:17 PM, Karl Beldan wrote:
> > 
> > I can post a change to mac80211_hwsim using it unless you already have
> > one ?
> Sure, I don't use mac80211_hwsim, I always test on real hardware :)
> 
I guess you must have some fine pieces of real hardware @ OpenWrt, and
apparently you even have vht in some stash .. I have never used OpenWrt, 
just picked something like swconfig (if I recall correctly) for an eth
switch.

I posted the changes required in mac80211_hwsim to handle
IEEE80211_HW_SUPPORTS_RC_TABLE .. I think it is nice to have hwsim
implements new features as soon as possible .. anyways know, FWIW, that
I had a go at your rate table changes with it.

 
Karl

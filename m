Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43124 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab1ITNpU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 09:45:20 -0400
Received: by wyg34 with SMTP id 34so514249wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 06:45:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110920133628.GC7800@tuxdriver.com>
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
	<20110920130338.GA9885@kroah.com>
	<1316524874.3953.41.camel@jlt3.sipsolutions.net>
	<20110920133628.GC7800@tuxdriver.com>
Date: Tue, 20 Sep 2011 15:45:19 +0200
Message-ID: <CACna6rxujsije__xcsy_w1pDCwttTDW9pT6YiUKDPhKyk22opA@mail.gmail.com> (sfid-20110920_154526_865496_48D67033)
Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline patch #2
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Greg KH <greg@kroah.com>, Franky Lin <frankyl@broadcom.com>,
	gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/9/20 John W. Linville <linville@tuxdriver.com>:
> On Tue, Sep 20, 2011 at 03:21:14PM +0200, Johannes Berg wrote:
>
>> Now, don't get me wrong -- I don't think the duplication is a good
>> thing. A lot of the PHY code could be shared. However, I think it will
>> probably not be possible for much longer to share the higher level MAC
>> code that programs the SHM etc.
>
> It would be nice to see some of this.  I don't think anything is
> stopping either Broadcom _or_ the b43 team from posting such patches.
>
>> So I don't claim to know what the solution is, but I think simply
>> rejecting the Broadcom effort like most people seem to imply is a good
>> solution at all. It will leave all of us in a bad spot by creating a
>> driver that has to support too many different devices.
>
> I'm inclined to agree.  Despite recent heroic efforts, b43 remains
> behind in it's support for current features of Broadcom hardware.
> As developers find other gainful interests, that gap is sure to widen
> -- it certainly was quite wide just a few months ago.

And brcmsmac stays behind b43 if you count feature different than
performance. Monitor, RFKILL, Ad-hoc, AP, hw crypt, supported PHYs,
etc.

And what if Broadcom decides to abound their brcm80211 project?

I vote for working together, I can not see a better solution.


> As Johannes implies, it seems likely that newer Broadcom hardware will
> need to be supported by a different/new driver anyway.  Is there
> some reason why that new driver needs to have a b43 pedigree?
> If we want/expect Broadcom to support that new driver, is it so
> unreasonable to allow them to start from the codebase they prefer?
> I don't think it is.

We still don't have any clue, when is that going to happen.


> Broadcom has come a long way in the wireless arena.  I think we would
> be better served by bringing them into the fold than by continuing
> to demand what they don't feel able to provide.

That's why I asked so many times already to discuss future with them.

-- 
Rafał

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58705 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab0INPxS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 11:53:18 -0400
Message-ID: <4C8F9A65.3040204@candelatech.com>
Date: Tue, 14 Sep 2010 08:53:09 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/10] ath9k / mac80211: power save fixes
References: <1284442237-24425-1-git-send-email-lrodriguez@atheros.com> <AANLkTikazs3A+=BXVm9+VZaOsRD2YFSkRSDJKQ4qGBfB@mail.gmail.com>
In-Reply-To: <AANLkTikazs3A+=BXVm9+VZaOsRD2YFSkRSDJKQ4qGBfB@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2010 08:07 AM, Luis R. Rodriguez wrote:
> On Mon, Sep 13, 2010 at 10:30 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com>  wrote:
>> Here are a bundle of joy of fixes for power save. Some of
>> these are regressions, which sucks ass to find out about them
>> so late. We *really* need a regression testbed for mac80211 and
>> ath9k. Some stable fixes trickle down to 2.6.32 even.

We're working on supporting ath9k for the virtual interfaces
in our system, and we do our own regression testing.

Aside from normal traffic passing, do you have any test
cases you'd like to see run?

> The all in one git am'able file can be downloaded here:
>
> http://bombadil.infradead.org/~mcgrof/patches/ath9k/2010/09/all-ps-fixes-09-14-v1.patch

Is there any way to get automated emails for commits going into wireless-testing?

If these go in soon, I'd rather not deal with merging them into my own repo,
but if it's going to take a while, it might be worth the effort.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:11062 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbbKWLib (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 06:38:31 -0500
Message-ID: <5652FAB5.8030708@broadcom.com> (sfid-20151123_123834_866248_0900FEA7)
Date: Mon, 23 Nov 2015 12:38:29 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: wireless-testing repo
References: <5652F62A.4000109@broadcom.com>	 (sfid-20151123_121912_784278_85DDFCC6) <1448278260.5792.1.camel@sipsolutions.net>
In-Reply-To: <1448278260.5792.1.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/23/2015 12:31 PM, Johannes Berg wrote:
> On Mon, 2015-11-23 at 12:19 +0100, Arend van Spriel wrote:
>> Hi John,
>>
>> We have been using the wireless-testing repo in our nightly testing
>> and as such appreciated the on-going support for it. I noticed your
>> announcement (and misplaced it) and as I prefer to keep the nightly
>> testing will have to do the work over here. Can you provide details
>> on what trees are merged into wireless-testing. Is it
>> wireless-drivers{,-next} and mac80211{,-next} or is there more to
>> consider.
>
> I believe it was also the latest rc from Linus.

Indeed.

> If you're testing with backports you could also use the latest linux-
> next with a restricted backport - I've added mac80211(-next) to that
> now.

We have some setups running on wl-testing kernel and some running distro 
kernel using backports.

Regards,
Arend

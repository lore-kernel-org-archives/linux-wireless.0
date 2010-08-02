Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:41263 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab0HBI7o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 04:59:44 -0400
Message-ID: <4C5688F7.1070200@openwrt.org>
Date: Mon, 02 Aug 2010 10:59:35 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Bruno Randolf <br1@einfach.org>, johannes@sipsolutions.net,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5] cfg80211: Add nl80211 antenna configuration
References: <20100729035820.5930.29864.stgit@tt-desk> <201007291812.28639.br1@einfach.org> 	<AANLkTi=ihY=pAmKaEp7Pga=DOxwASZqSxqmURbgnks-d@mail.gmail.com> 	<201008021313.54850.br1@einfach.org> <AANLkTimRnfa8HVpi0hcP7Eo9Nrns60ff3Hs+fq39WoJh@mail.gmail.com>
In-Reply-To: <AANLkTimRnfa8HVpi0hcP7Eo9Nrns60ff3Hs+fq39WoJh@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-08-02 7:37 AM, Luis R. Rodriguez wrote:
> I'm not, the point I was trying to make is that solving this for
> legacy and that for 802.11n this needs more thought and work.
I need this for 802.11n as well, and I believe the API is good enough
for that.

>> as long as the API is flexible
>> enough i think it can be added later as 802.11n devices are going to accept
>> antenna configuration.
> 
> If you want really flexible stuff without addressing serious
> considerations before introducing a new kernel API then use debugfs.
I'd like to see this in nl80211. Is there any specific concern left that
I haven't addressed already? If so, please point me at it...

- Felix

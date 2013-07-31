Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3984 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab3GaTTV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 15:19:21 -0400
Message-ID: <51F9632B.8090105@broadcom.com> (sfid-20130731_211924_367987_CAA7699F)
Date: Wed, 31 Jul 2013 21:19:07 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3.11] cfg80211: fix P2P GO interface teardown
References: <1375297347-1380-1-git-send-email-johannes@sipsolutions.net>
 (sfid-20130731_210237_569724_A4F81D1E)
 <1375298245.8289.19.camel@jlt4.sipsolutions.net>
In-Reply-To: <1375298245.8289.19.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/31/2013 09:17 PM, Johannes Berg wrote:
> On Wed, 2013-07-31 at 21:02 +0200, Johannes Berg wrote:
>> From: Johannes Berg <johannes.berg@intel.com>
>>
>> When a P2P GO interface goes down, cfg80211 doesn't properly
>> tear it down, leading to warnings later. Add the GO interface
>> type to the enumeration to tear it down like AP interfaces.
>> Otherwise, we leave it pending and mac80211's state can get
>> very confused, leading to warnings later.
>
> Applied
>
> (it's obvious and we've tested it for a while)

We'll see what happens when I test it with brcmfmac :-p

Gr. AvS


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37522 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab0I3Uu6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 16:50:58 -0400
Received: by gxk9 with SMTP id 9so931313gxk.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 13:50:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimY6uVud0VbkQXhozxWEOxq9enMfk0Nsz8kYe4e@mail.gmail.com>
References: <AANLkTimrRJavN0B+nYGJwFeNM9KYa1XuQ2VrSCREb5kN@mail.gmail.com> <AANLkTimY6uVud0VbkQXhozxWEOxq9enMfk0Nsz8kYe4e@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 30 Sep 2010 13:50:36 -0700
Message-ID: <AANLkTimVBRyo3z9XHQnS_X95-kgN_o6ZqHUeSLCwARhx@mail.gmail.com>
Subject: Re: [PATCH] fix for WDS in ath9k (and mac80211, and nl80211)
To: Bill Jordan <bjordan@rajant.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 30, 2010 at 1:47 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Thu, Sep 30, 2010 at 1:41 PM, Bill Jordan <bjordan@rajant.com> wrote:
>> I tried to submit this before, but I believe that version was lost to
>> the ether. Apologies
>> if this is a repeat.
>>
>> I'm trying to use WDS with ath9k, and I ran into some problems. In addition to
>> enabling WDS interfaces in ath9k, I also had to patch mac80211 to
>> allow xmits and
>> recvs to pass through on WDS interfaces. The rate table was also never being
>> initialized for WDS interfaces.
>>
>> I have also patched nl80211 so I have a mechanism to set the WDS peer bssid.
>>
>> With these patches, I'm able to interoperate over WDS between
>> linux-wireless and MadWifi.
>> I'm running wireless-testing plus OpenWRT patches on a Cambria board with
>> an AR9160 radio.
>>
>> Signed-off-by: Bill Jordan <bjordan@rajant.com>
>
> Nice can you please split these up into separate patches?

That is, one for cfg80211 first, then mac80212, and then one for ath9k.

  Luis

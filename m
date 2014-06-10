Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:42505 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbaFJVov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 17:44:51 -0400
Received: by mail-lb0-f175.google.com with SMTP id z11so18161lbi.6
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 14:44:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6W+BjyH3Ywb2Goigu6-=omtTQuLsmnXx+Mwz5Dc6bk_Uw@mail.gmail.com>
References: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com> <CAB=NE6W+BjyH3Ywb2Goigu6-=omtTQuLsmnXx+Mwz5Dc6bk_Uw@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 10 Jun 2014 14:44:29 -0700
Message-ID: <CAB=NE6UMDM3rSq1FLjO5yammhjX=6NgvntQvt9NGijOHBxq+wg@mail.gmail.com> (sfid-20140610_234454_243547_91B780CB)
Subject: Re: [PATCH 0/7] regulatory enhancements
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2014 at 1:48 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Sun, May 11, 2014 at 1:50 AM, Emmanuel Grumbach
> <emmanuel.grumbach@intel.com> wrote:
>> Hi Johannes,
>>
>> Newer Intel cards store regulatory settings in firmware.
>> This patch series adds support for a wiphy callback, allowing
>> the regulatory core to fetch driver/firmware defined redgomain
>> data whenever a country code change is requested.
>>
>> Along with that, there is also a small fix from Eliad.
>>
>> Arik Nemtsov (6):
>>   cfg80211: don't set reg timeout for user-handled hint
>>   cfg80211: introduce regulatory flags controlling bw
>>   cfg80211: allow drivers to provide regulatory settings
>>   cfg80211: treat the special "unknown" alpha2 as valid
>>   cfg80211: accept world/same regdom from driver/user hints
>>   cfg80211: leave invalid channels on regdomain change
>
> Please Cc me on regulatory patches. I've noted issues with the wiphy
> callback addition, but other than place if you can please resend
> patches that do not depend on that, that'd be appreciated, I'll take a
> look at those in the morning.

I haven't seen these patches, please split them up, I think a few
already were accepted, but separating them between the new
functionality being added is key to speedy review. I'll take a second
stab at review of the fw API now as I'm going comfortalbe with the
idea of letting folks shoot themselves on the foot.

  Luis

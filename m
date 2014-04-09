Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:58008 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaDIHFI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 03:05:08 -0400
Received: by mail-we0-f177.google.com with SMTP id u57so1936769wes.8
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 00:05:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1396963511.11971.1.camel@jlt4.sipsolutions.net>
References: <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
	<1396262371-6466-1-git-send-email-michal.kazior@tieto.com>
	<1396262371-6466-5-git-send-email-michal.kazior@tieto.com>
	<1396963511.11971.1.camel@jlt4.sipsolutions.net>
Date: Wed, 9 Apr 2014 09:05:07 +0200
Message-ID: <CA+BoTQnQBxhc5nHjqU95pB=Noc5KzdAhdnX14hz9tFLQpSivbA@mail.gmail.com> (sfid-20140409_090514_618569_812B8DD2)
Subject: Re: [PATCH v3 04/13] mac80211: add support for radar detection for reservations
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 April 2014 15:25, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2014-03-31 at 12:39 +0200, Michal Kazior wrote:
>> Initial chanctx reservation code wasn't aware of
>> radar detection requirements. This is necessary
>> for chanctx reservations to be used for channel
>> switching in the future.
>
>>  int ieee80211_vif_reserve_chanctx(struct ieee80211_sub_if_data *sdata,
>>                                 const struct cfg80211_chan_def *chandef,
>> -                               enum ieee80211_chanctx_mode mode)
>> +                               enum ieee80211_chanctx_mode mode,
>> +                               bool radar_required)
>
> Does this not have any callers?

Not yet.


Michał

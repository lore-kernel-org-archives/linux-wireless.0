Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:36046 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752801AbcLLUBF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Dec 2016 15:01:05 -0500
Received: by mail-qk0-f172.google.com with SMTP id n21so94776353qka.3
        for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2016 12:01:05 -0800 (PST)
Subject: Re: [RFC V3 03/11] nl80211: add support for gscan
To: Dan Williams <dcbw@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>
References: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
 <1481543997-24624-4-git-send-email-arend.vanspriel@broadcom.com>
 <1481564592.6887.2.camel@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <286ed7bd-c23a-03c0-175f-7784fb235f7b@broadcom.com> (sfid-20161212_210108_518347_572F67AF)
Date: Mon, 12 Dec 2016 21:01:01 +0100
MIME-Version: 1.0
In-Reply-To: <1481564592.6887.2.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12-12-2016 18:43, Dan Williams wrote:
>> +
>> +/**
>> + * enum nl80211_bucket_band - GScan bucket band selection.
> Quite possibly this was already covered and somebody requested you to
> change this to the current name.  If that's the case, ignore this.

Nope. You are the first ;-)

> But shouldn't this enum and bucket_event_report include "gscan" in
> their name, like the other gscan specific stuff does?  Are these going
> to get used for something else too, and will that thing make sense with
> the word "bucket"?  Just "nl80211_bucket_band" is pretty generic.

I figured the term bucket was making it gscan specific, but you are
right. Will change it.

Thanks,
Arend

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64510 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab1H3Shi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 14:37:38 -0400
Received: by yie30 with SMTP id 30so4622912yie.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 11:37:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110829191023.GC1406@tuxdriver.com>
References: <1314271494-8756-1-git-send-email-eliad@wizery.com>
	<1314624302.8959.3.camel@jlt3.sipsolutions.net>
	<20110829191023.GC1406@tuxdriver.com>
Date: Tue, 30 Aug 2011 21:37:37 +0300
Message-ID: <CAB3XZEf8+aoyD2YhP8U7RD076i4hoTLD-ec9r4K8wUzYs4qEAQ@mail.gmail.com> (sfid-20110830_203743_002649_A3D1559B)
Subject: Re: [PATCH v2 1/3] nl80211/cfg80211: add WIPHY_FLAG_AP_UAPSD flag
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 29, 2011 at 10:10 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Mon, Aug 29, 2011 at 03:25:02PM +0200, Johannes Berg wrote:
>> On Thu, 2011-08-25 at 14:24 +0300, Eliad Peller wrote:
>> > add WIPHY_FLAG_AP_UAPSD flag to indicate uapsd support on
>> > AP mode.
>> >
>> > Advertise it to userspace by including a new
>> > NL80211_ATTR_SUPPORT_AP_UAPSD attribute.
>>
>> I guess it'll help me support this for mac80211 (drivers that don't do
>> it all in firmware) -- I had a patch that was equivalent to the first
>> two :)
>
> Apparently I misinterpreted the discussion of the first version of
> this series.  Apparently as Eliad was posting the 2nd version, I was
> merging the first.
>
> Could you post a version that takes what is already in wireless-next
> and transforms it into this?
>
sure (probably tomorrow).

Eliad.

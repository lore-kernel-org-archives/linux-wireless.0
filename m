Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:43055 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab2LEJQs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 04:16:48 -0500
Received: by mail-ie0-f173.google.com with SMTP id e13so7471836iej.4
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2012 01:16:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354698356.9972.5.camel@jlt4.sipsolutions.net>
References: <CABPxzYKvtgdoxU-dFS2F0tz_1F6cz02uvVgy5qfMPCEbLOZZ=A@mail.gmail.com>
 <1354698297.9972.4.camel@jlt4.sipsolutions.net> <1354698356.9972.5.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 5 Dec 2012 14:40:17 +0530
Message-ID: <CABPxzYKEG5053YpLxbTf-ijn1-aLunmnrsvR8w+nCL86XCmOKQ@mail.gmail.com> (sfid-20121205_101652_614251_89964EE1)
Subject: Re: [PATCH] mac80211: Moving Zero Len subframe reporting under driver
 capability check.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Agree. this is just a check to avoid buggy drivers misusing the field :-)


On Wed, Dec 5, 2012 at 2:35 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2012-12-05 at 10:04 +0100, Johannes Berg wrote:
>> On Wed, 2012-12-05 at 11:08 +0530, Krishna Chaitanya wrote:
>> > Zero Len subframe makes sense only when driver supports the reporting
>> > of zero len subframes.
>>
>> Yes, but if the driver is stupid enough to set RX_FLAG_AMPDU_IS_ZEROLEN
>> without setting RX_FLAG_AMPDU_REPORT_ZEROLEN I'm not sure we care?
>
> Plus your patch doesn't apply anyway.
>
> johannes
>

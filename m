Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:52450 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaHML5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2014 07:57:10 -0400
Received: by mail-ig0-f172.google.com with SMTP id h15so9866222igd.11
        for <linux-wireless@vger.kernel.org>; Wed, 13 Aug 2014 04:57:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1407930393.21220.34.camel@jlt4.sipsolutions.net>
References: <1407870219-1720-1-git-send-email-johannes@sipsolutions.net>
	<CAB3XZEckyoDVShskF8rRe7DFuVMO-LBdhFDejiJ63SjhsEvmAA@mail.gmail.com>
	<1407928122.21220.31.camel@jlt4.sipsolutions.net>
	<CAB3XZEdOC1ERUm1HDK03qWQti35Z66EHL+0gD9=oBpcPfK2r4w@mail.gmail.com>
	<1407928809.21220.33.camel@jlt4.sipsolutions.net>
	<CAB3XZEd0h_aPQSHr900+VWxdRw014QUP01-qj5rjsKsd+dhBsQ@mail.gmail.com>
	<1407930393.21220.34.camel@jlt4.sipsolutions.net>
Date: Wed, 13 Aug 2014 14:57:09 +0300
Message-ID: <CAB3XZEfb=XoxVTSGM8qNnV2UEVUP5F5FpqanrYivOm_gz4pnZg@mail.gmail.com> (sfid-20140813_135719_860396_D9527C5A)
Subject: Re: [PATCH 1/2] cfg80211: clarify BSS probe response vs. beacon data
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@adurom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 13, 2014 at 2:46 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2014-08-13 at 14:39 +0300, Eliad Peller wrote:
>
>> > Maybe we should just get rid of the requirement to assign beacon_ies
>> > with the bss_width() call and make free() smarter?
>>
>> this will also require changing cfg80211_bss_update() to take care of
>> this case, etc.
>> not sure we really want to complicate it further more.
>
> Good point. So let's say we change this to "known_from_beacon", is that
> enough?
>
yes. sounds good.

Eliad.

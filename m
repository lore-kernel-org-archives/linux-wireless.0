Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:51698 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752613Ab2FLMPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 08:15:49 -0400
Received: by lahd3 with SMTP id d3so3447631lah.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 05:15:48 -0700 (PDT)
Message-ID: <4FD732F1.8070607@gmail.com> (sfid-20120612_141552_278516_30A796D2)
Date: Tue, 12 Jun 2012 14:15:45 +0200
From: Pontus Fuchs <pontus.fuchs@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Disallow changing chan type on monitor when
 CHAN_MODE_FIXED
References: <1339499167-26225-1-git-send-email-pontus.fuchs@gmail.com>   (sfid-20120612_130639_458885_983B325C) <1339499291.4531.1.camel@jlt3.sipsolutions.net>  <4FD725FF.1030108@gmail.com> (sfid-20120612_132035_802191_87C8E8E9) <1339500801.4531.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1339500801.4531.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-06-12 13:33, Johannes Berg wrote:
> Yeah, like we discussed, maybe it should or should not be allowed? With
> the new changes Michal is doing it'll probably be disallowed anyway?
>
> I'll apply it, but can you rediff and remove the "is_monitor" argument,
> since dev == NULL is equivalent? :)

Thanks, that's a lot smarter. I was confused by the old code. V2 sent.

Cheers,

Pontus

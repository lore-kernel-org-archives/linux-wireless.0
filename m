Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:58311 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932505AbZLPQB0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2009 11:01:26 -0500
Received: by iwn1 with SMTP id 1so763007iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2009 08:01:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1260978844.10356.86.camel@johannes.local>
References: <1260945398-301-1-git-send-email-lrodriguez@atheros.com>
	<1260978844.10356.86.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 16 Dec 2009 07:59:25 -0800
Message-ID: <43e72e890912160759h235c4d39j1b156bbd8f920da5@mail.gmail.com>
Subject: Re: [PATCH] iw: add country IE parsing support for scanning
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ic.felix@gmail.com,
	=?UTF-8?B?THVrw6HFoSBUdXJlaw==?= <8an@praha12.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 16, 2009 at 7:54 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-12-16 at 01:36 -0500, Luis R. Rodriguez wrote:
>
>>         Country: US     Environment: Indoor/Outdoor
>>         Country IE triplets:
>>                 Channels [36 - 48]
>>                 Channels [52 - 64]
>>                 Channels [149 - 165]
>
> Can we do this more like
>
> Country: * US (Indoor/Outdoor)
>         * Channels 36-48, 52-64, 149-165
>
> ?

I wanted this too but was too lazy yesterday. Will ya take a followup
patch when I get unlazy?

> Not sure what the "triplets" text buys us?

Well it'll at least print out the regulatory class stuff so its not
only channels. Granted I'd like for regulatory class to be properly
mapped to something more sensible but that's another exercise and once
complete that can also be sucked into cfg80211 and friends.

  Luis

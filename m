Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:33789 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932772AbcBXNcq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 08:32:46 -0500
Received: by mail-wm0-f43.google.com with SMTP id g62so4907320wme.0
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 05:32:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56CDAEF6.1080606@candelatech.com>
References: <1456180974-21062-1-git-send-email-greearb@candelatech.com>
 <CA+XVXffpNDf0-5a6cPz0aUrrRfHgKQeu09zDt5eSe1K87m__pw@mail.gmail.com>
 <56CC62BC.308@candelatech.com> <CA+XVXffxWtZgfZS=EZGYng6vWMxqnhTdhgxagYXRbKq1iYj0Sg@mail.gmail.com>
 <56CDAEF6.1080606@candelatech.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 24 Feb 2016 15:32:30 +0200
Message-ID: <CA+XVXfceVud0OfB5P=s45DCES1D2VGnbtotZvKX2s8FeFh8N0A@mail.gmail.com> (sfid-20160224_143607_038855_49C70861)
Subject: Re: [PATCH] mac80211: Let VHT work on 2.4Ghz
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 24, 2016 at 3:24 PM, Ben Greear <greearb@candelatech.com> wrote:
>> Also it's pretty easy to just leave the code there and condition the
>> check on the 5GHz band. There's no need to remove it.
>
>
> Ok, so I can enable VHT on any band as long as the 5Ghz band exists and
> allows 80Mhz?
>

No idea about that. I'm not sure how/if rate modulation is regulated
on 2GHz. The ISM band itself is supposed to be open (microwave heating
etc.) so it seems fine to me.
But don't take me up on that. This is lawyer domain.

Arik

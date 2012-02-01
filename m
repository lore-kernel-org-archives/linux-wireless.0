Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52482 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab2BAQck (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 11:32:40 -0500
Received: by iacb35 with SMTP id b35so1718829iac.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2012 08:32:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328111519.3297.0.camel@jlt3.sipsolutions.net>
References: <1328098003-28004-1-git-send-email-eliad@wizery.com>
	<1328111519.3297.0.camel@jlt3.sipsolutions.net>
Date: Wed, 1 Feb 2012 18:32:40 +0200
Message-ID: <CAB3XZEcNcALwUKjvxr=hJixkogyZH3rYVCyARfEX_5vu1nodBg@mail.gmail.com> (sfid-20120201_173243_802956_0FE4A041)
Subject: Re: [PATCH] mac80211: timeout a single frame in the rx reorder buffer
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 1, 2012 at 5:51 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2012-02-01 at 14:06 +0200, Eliad Peller wrote:
>> The current code checks for stored_mpdu_num > 1, causing
>> the reorder_timer to be triggered indefinitely, but the
>> frame is never timed-out (until the next packet is received)
>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
>
> Looks kinda obvious & trivial, want to CC stable?
>
Sure. i'll resend.

Eliad.

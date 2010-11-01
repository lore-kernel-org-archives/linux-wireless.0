Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55832 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab0KAVal (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 17:30:41 -0400
Received: by ywc21 with SMTP id 21so1193842ywc.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Nov 2010 14:30:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1288639403.21112.50.camel@powerslave>
References: <1288184310-6781-1-git-send-email-eliad@wizery.com>
	<1288184310-6781-2-git-send-email-eliad@wizery.com>
	<1288639403.21112.50.camel@powerslave>
Date: Mon, 1 Nov 2010 23:30:40 +0200
Message-ID: <AANLkTinCj0hQJaXkFPDMzBQ2fQbZa+Bd4H0C+i4c8Bv2@mail.gmail.com>
Subject: Re: [PATCH 2/2] wl1271: refactor debugfs function generation code
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 1, 2010 at 9:23 PM, Luciano Coelho <luciano.coelho@nokia.com> wrote:
> On Wed, 2010-10-27 at 14:58 +0200, ext Eliad Peller wrote:
>> refactor wl1271_debugfs by using a format&copy function, instead of
>> duplicating the code for each generated function.
>>
>> this change reduces about 3Kb from wl1271.ko
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> Looks good, thanks!
>
> Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
>
> I have applied this patch, but I won't apply the one for mac80211 [1/2],
> because patches for mac80211 go directly to linux-wireless.
>
thanks!

> PS: I have fixed a couple of whitespace checkpatch warnings.
sorry about it.
i'll check it next time.
John/Johannes - do you want me to fix this issue and resend (only the
mac80211 one)?

Eliad.

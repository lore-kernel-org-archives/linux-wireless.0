Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:6141 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbYKETxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 14:53:25 -0500
Received: by yx-out-2324.google.com with SMTP id 8so103548yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2008 11:53:24 -0800 (PST)
Message-ID: <43e72e890811051153x555cb21fib1f227fb616ad8a5@mail.gmail.com> (sfid-20081105_205328_994746_C59EE7CE)
Date: Wed, 5 Nov 2008 11:53:24 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 6/7] cfg80211: initialize last_request
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1225886536.3619.86.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-2-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-3-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-4-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-5-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-6-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-7-git-send-email-lrodriguez@atheros.com>
	 <1225886536.3619.86.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 5, 2008 at 4:02 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2008-11-04 at 18:50 -0800, Luis R. Rodriguez wrote:
>> last_request was not being initialized. By initializing it
>> we don't fix a bug as we are not checking for it before prior
>> to a regulatory hint however we may do so at a later time.
>
> It's a static variable, it always starts out as NULL, this isn't
> necessary.

You're right but this is not true in userspace, why is this different BTW?

  Luis

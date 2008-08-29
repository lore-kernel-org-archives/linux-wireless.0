Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.226]:43069 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbYH2ULf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 16:11:35 -0400
Received: by wr-out-0506.google.com with SMTP id 69so870392wri.5
        for <linux-wireless@vger.kernel.org>; Fri, 29 Aug 2008 13:11:34 -0700 (PDT)
Message-ID: <43e72e890808291311h6b2d0584t9cf643b98cc0814b@mail.gmail.com> (sfid-20080829_221138_589734_771AE990)
Date: Fri, 29 Aug 2008 13:11:33 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] iw: Add support to send a request to set the regulatory domain
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1220038740.25321.39.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1220032919-6821-1-git-send-email-lrodriguez@atheros.com>
	 <1220038740.25321.39.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 29, 2008 at 12:39 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> +     genlmsg_put(msg, 0, 0, genl_family_get_id(state->nl80211), 0,
>> +                 0, NL80211_CMD_ASK_SET_REG, 0);
>
> ASK_SET?

Have a better idea? I was going to use NEW for the current SET_REGDOM
but that just didn't seem right. ASK_SET seems more clear to me as its
asking to set it, not actually giving a specific regdomain to set.

  Luis

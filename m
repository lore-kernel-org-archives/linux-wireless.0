Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.227]:45830 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbYH2U7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 16:59:20 -0400
Received: by wr-out-0506.google.com with SMTP id 69so884271wri.5
        for <linux-wireless@vger.kernel.org>; Fri, 29 Aug 2008 13:59:19 -0700 (PDT)
Message-ID: <43e72e890808291359q6076224ehe0f57bb3e18617dd@mail.gmail.com> (sfid-20080829_225922_976063_E6A7AAE5)
Date: Fri, 29 Aug 2008 13:59:19 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] iw: Add support to send a request to set the regulatory domain
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080829202654.GA11718@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1220032919-6821-1-git-send-email-lrodriguez@atheros.com>
	 <1220038740.25321.39.camel@johannes.berg>
	 <43e72e890808291311h6b2d0584t9cf643b98cc0814b@mail.gmail.com>
	 <20080829202654.GA11718@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 29, 2008 at 1:26 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Fri, Aug 29, 2008 at 01:11:33PM -0700, Luis R. Rodriguez wrote:
>> On Fri, Aug 29, 2008 at 12:39 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> >
>> >> +     genlmsg_put(msg, 0, 0, genl_family_get_id(state->nl80211), 0,
>> >> +                 0, NL80211_CMD_ASK_SET_REG, 0);
>> >
>> > ASK_SET?
>>
>> Have a better idea? I was going to use NEW for the current SET_REGDOM
>> but that just didn't seem right. ASK_SET seems more clear to me as its
>> asking to set it, not actually giving a specific regdomain to set.
>
> REQ_SET?  Sounds a bit more "serious" anyway... :-)

OK, sounds good, I'll repost with this both the iw patch, and patch #4.

  Luis

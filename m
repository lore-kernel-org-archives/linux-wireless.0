Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48946 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbYH2Ua2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 16:30:28 -0400
Date: Fri, 29 Aug 2008 16:26:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iw: Add support to send a request to set the
	regulatory domain
Message-ID: <20080829202654.GA11718@tuxdriver.com> (sfid-20080829_223038_166504_D9263062)
References: <1220032919-6821-1-git-send-email-lrodriguez@atheros.com> <1220038740.25321.39.camel@johannes.berg> <43e72e890808291311h6b2d0584t9cf643b98cc0814b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890808291311h6b2d0584t9cf643b98cc0814b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 29, 2008 at 01:11:33PM -0700, Luis R. Rodriguez wrote:
> On Fri, Aug 29, 2008 at 12:39 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> >> +     genlmsg_put(msg, 0, 0, genl_family_get_id(state->nl80211), 0,
> >> +                 0, NL80211_CMD_ASK_SET_REG, 0);
> >
> > ASK_SET?
> 
> Have a better idea? I was going to use NEW for the current SET_REGDOM
> but that just didn't seem right. ASK_SET seems more clear to me as its
> asking to set it, not actually giving a specific regdomain to set.

REQ_SET?  Sounds a bit more "serious" anyway... :-)

-- 
John W. Linville
linville@tuxdriver.com

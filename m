Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.232]:44967 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbYH2UMO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 16:12:14 -0400
Received: by wr-out-0506.google.com with SMTP id 69so870583wri.5
        for <linux-wireless@vger.kernel.org>; Fri, 29 Aug 2008 13:12:14 -0700 (PDT)
Message-ID: <43e72e890808291312t38345db5tb9bb4115ac7d0f29@mail.gmail.com> (sfid-20080829_221218_325333_9C64FC80)
Date: Fri, 29 Aug 2008 13:12:13 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] rt2x00: Need to set wiphy->interface_modes
Cc: "Ivo van Doorn" <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org,
	rt2400-devel <rt2400-devel@lists.sourceforge.net>,
	"Stephen Blackheath" <tramp.enshrine.stephen@blacksapphire.com>
In-Reply-To: <1220038676.25321.37.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200808292025.16870.IvDoorn@gmail.com>
	 <1220038676.25321.37.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 29, 2008 at 12:37 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2008-08-29 at 20:25 +0200, Ivo van Doorn wrote:
>> Hi Johannes,
>>
>> Below patch was created by Stephen Blackheath.
>>
>> Could you merge this patch with your patch: 008-cfg80211-interface-types.patch
>> This is the required rt2x00 change for registering the supported interface types.
>
> Thanks, I'd hoped somebody else would pick it up, but if not I'll do it
> in a week.

I picked it up, and sent it all together as *one* patch.

  Luis

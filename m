Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45168 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab1DDT5o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 15:57:44 -0400
Received: by iyb14 with SMTP id 14so6225418iyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Apr 2011 12:57:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1301919566.3870.8.camel@jlt3.sipsolutions.net>
References: <1301686955-9402-1-git-send-email-lrodriguez@atheros.com>
 <1301687948.3842.0.camel@jlt3.sipsolutions.net> <AANLkTimJ8F-MFcK6raqcSFMsieGCx_gK_Ud1AF7BNPR2@mail.gmail.com>
 <1301689736.3842.4.camel@jlt3.sipsolutions.net> <AANLkTimHCgmoWvC_Ou7BsiDjwxF=YB0h4-g=_afYxsQF@mail.gmail.com>
 <1301694574.3842.6.camel@jlt3.sipsolutions.net> <AANLkTi=U0PYmvTmadQu+a5OzoyxKMu_rn0wi=Wq37Spi@mail.gmail.com>
 <1301919566.3870.8.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 4 Apr 2011 12:57:24 -0700
Message-ID: <BANLkTin1QSgUHbR5Qy=EL=TuAJXOkdGhxQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] cfg80211: fix regulatory restore upon user hints
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, gregoryx.alagnou@intel.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 4, 2011 at 5:19 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2011-04-01 at 15:22 -0700, Luis R. Rodriguez wrote:
>
>> >> I cannot see any other cases here where we'd block a request from userspace.
>> >
>> > No not block a request. I'm just thinking that this taking things off
>> > the list temporarily might erroneously discard a crda response.
>>
>> Ah, but the stuff in the queue is stuff which we have not yet sent out
>> to userspace. CRDA and the kernel process regulatory requests
>> atomically.
>
> Ah, ok, I misunderstood this then.

Oh OK, acked-by ?

  Luis

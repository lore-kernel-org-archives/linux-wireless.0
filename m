Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:40260 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594AbZHLR1z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 13:27:55 -0400
Received: by gxk9 with SMTP id 9so246310gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 10:27:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0908121021x3bc9fe26vb17532de6c464b7f@mail.gmail.com>
References: <1250096221-11000-1-git-send-email-lrodriguez@atheros.com>
	<b6c5339f0908121021x3bc9fe26vb17532de6c464b7f@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 12 Aug 2009 10:27:36 -0700
Message-ID: <43e72e890908121027x5211c7cja3185861bc9c02f1@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 0/3] ath: advance ath.ko with one more
	helper
To: Bob Copeland <me@bobcopeland.com>
Cc: ath5k-devel@lists.ath5k.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 12, 2009 at 10:21 AM, Bob Copeland<me@bobcopeland.com> wrote:
> On Wed, Aug 12, 2009 at 12:56 PM, Luis R.
> Rodriguez<lrodriguez@atheros.com> wrote:
>> This adds a common structure where we can start stuffing shared items
>> and introduces a helper for both ath5k and ath9k's use.
>>
>> Luis R. Rodriguez (3):
>>  ath: add common ath_rxbuf_alloc() and make ath9k use it
>>  ath5k: use common ath.ko ath_rxbuf_alloc()
>>  ath5k: use bit shift operators for cache line size
>
> Series looks OK to me but I think we can add a 4/4 that would:
>
> - include ath/reg.h [don't remember if that's the name right now]
>  in ath.h
> - move reg structs into ath_common (although, this could be a
>  bad call for ar9170, haven't really checked).
>
> Then we only have to deal with one header and one composite struct
> (for now) as the interface between the modules.

Sure, I was thinking of doing this after this. Is that acceptable?

  Luis

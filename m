Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:41926 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYJ3BWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 21:22:52 -0400
Received: by rv-out-0506.google.com with SMTP id k40so304388rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 18:22:51 -0700 (PDT)
Message-ID: <b6c5339f0810291822g33c0ce4cvc21a2449d8ee5458@mail.gmail.com> (sfid-20081030_022257_316532_E4BB2AEE)
Date: Wed, 29 Oct 2008 21:22:51 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [ath5k-devel] ath5k: badness at net/mac80211/rx.c:2200, status->rate_idx = 255
Cc: ath5k-devel@lists.ath5k.org,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1224882332.10804.0.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1224799927.22806.15.camel@dv>
	 <20081023213333.4t4427vw5ws8ccck-cebfxv@webmail.spamcop.net>
	 <b6c5339f0810241158t59b15861qc9eb05a3f3f032a2@mail.gmail.com>
	 <b6c5339f0810241201r7f8ba34ej6f39a96e371849eb@mail.gmail.com>
	 <1224882332.10804.0.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 24, 2008 at 5:05 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Fri, 2008-10-24 at 15:01 -0400, Bob Copeland wrote:
>> On Fri, Oct 24, 2008 at 2:58 PM, Bob Copeland <me@bobcopeland.com> wrote:
>> > http://article.gmane.org/gmane.linux.kernel.wireless.general/22711
>> >
>> > I guess like ath9k, rc stuff isn't setup properly, but I wouldn't know.
>>
>> Err, that's tx path not rx, so maybe not.
>
> Correct.  But
> http://article.gmane.org/gmane.linux.drivers.ath5k.devel/1311 is what
> I'm seeing.

So, any hints on how to reproduce this one?  Seems lots of people are
hitting it but I haven't seen it yet (though I was working on
2.6.27-rc2 up until yesterday).

-- 
Bob Copeland %% www.bobcopeland.com

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isis.lip6.fr ([132.227.60.2]:65190 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932673AbaFLJvj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2014 05:51:39 -0400
Message-ID: <20140612115134.205432hq8ztc6pt2@webmail.lip6.fr> (sfid-20140612_115142_805252_93E29080)
Date: Thu, 12 Jun 2014 11:51:34 +0200
From: Julia.Lawall@lip6.fr
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	John Stultz <john.stultz@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>, cocci@systeme.lip6.fr,
	Ingo Molnar <mingo@kernel.org>
Subject: Re: [Cocci] [patch 04/13] net: mac80211: Use ktime_get_ts()
References: <20140611234024.103571777@linutronix.de>
 <20140611234607.020125642@linutronix.de>
 <1402556024.4224.2.camel@jlt4.sipsolutions.net>
 <CAB=NE6UqxX=K2iZhHQBmMU4wTBmAmj7KbnJBktepB8+JJn0LDQ@mail.gmail.com>
In-Reply-To: <CAB=NE6UqxX=K2iZhHQBmMU4wTBmAmj7KbnJBktepB8+JJn0LDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-15;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@do-not-panic.com> a écrit :

> On Wed, Jun 11, 2014 at 11:53 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Wed, 2014-06-11 at 23:59 +0000, Thomas Gleixner wrote:
>>
>>> do_posix_clock_monotonic_gettime() is a leftover from the initial
>>> posix timer implementation which maps to ktime_get_ts().
>>
>> I didn't even know we *had* such code, heh.
>
> If we want want maintainers to police this stuff we can add an SmPL
> rule for this upstream and have maintainer use 'make coccicheck
> M=path/'. The way of the future. The way of the future...

If I could have a little more context, I can do something.

julia

>
>   Luis
> _______________________________________________
> Cocci mailing list
> Cocci@systeme.lip6.fr
> https://systeme.lip6.fr/mailman/listinfo/cocci
>





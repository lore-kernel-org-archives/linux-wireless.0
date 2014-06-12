Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33860 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458AbaFLGxw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2014 02:53:52 -0400
Message-ID: <1402556024.4224.2.camel@jlt4.sipsolutions.net> (sfid-20140612_085411_881162_F06C7C07)
Subject: Re: [patch 04/13] net: mac80211: Use ktime_get_ts()
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
	John Stultz <john.stultz@linaro.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 12 Jun 2014 08:53:44 +0200
In-Reply-To: <20140611234607.020125642@linutronix.de>
References: <20140611234024.103571777@linutronix.de>
	 <20140611234607.020125642@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-06-11 at 23:59 +0000, Thomas Gleixner wrote:

> do_posix_clock_monotonic_gettime() is a leftover from the initial
> posix timer implementation which maps to ktime_get_ts().

I didn't even know we *had* such code, heh.

I've applied it to my tree - note that some code moved into sta_info.c
recently there.

johannes


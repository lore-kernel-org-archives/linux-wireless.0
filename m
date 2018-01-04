Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:42660 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753247AbeADPTD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Jan 2018 10:19:03 -0500
Date: Thu, 4 Jan 2018 16:18:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Johannes Berg <johannes@sipsolutions.net>
cc: Anna-Maria Gleixner <anna-maria@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, keescook@chromium.org,
        Christoph Hellwig <hch@lst.de>,
        John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v4 31/36] mac80211_hwsim: Replace hrtimer tasklet with
 softirq hrtimer
In-Reply-To: <1515078757.10342.33.camel@sipsolutions.net>
Message-ID: <alpine.DEB.2.20.1801041617340.1771@nanos> (sfid-20180104_161949_698704_C4957562)
References: <20171221104205.7269-1-anna-maria@linutronix.de>  <20171221104205.7269-32-anna-maria@linutronix.de> <1515078757.10342.33.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 4 Jan 2018, Johannes Berg wrote:

> On Thu, 2017-12-21 at 11:42 +0100, Anna-Maria Gleixner wrote:
> > From: Thomas Gleixner <tglx@linutronix.de>
> > 
> > Switch the timer to HRTIMER_MODE_SOFT, which executed the timer
> 
> I've pointed out before that this should say HRTIMER_MODE_REL_SOFT.
> 
> Anyway, since it still doesn't apply on my tree, somebody else will
> have to pick it up.

Yes. I'm going to do that or decide to postpone the conversion
patches. Have not yet thought about it as I was distracted for the last 2
month by something unpleasant....

Thanks,

	tglx

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:52504 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753270AbeADPMs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Jan 2018 10:12:48 -0500
Message-ID: <1515078757.10342.33.camel@sipsolutions.net> (sfid-20180104_161324_706564_43F0B88E)
Subject: Re: [PATCH v4 31/36] mac80211_hwsim: Replace hrtimer tasklet with
 softirq hrtimer
From: Johannes Berg <johannes@sipsolutions.net>
To: Anna-Maria Gleixner <anna-maria@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, keescook@chromium.org,
        Christoph Hellwig <hch@lst.de>,
        John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Date: Thu, 04 Jan 2018 16:12:37 +0100
In-Reply-To: <20171221104205.7269-32-anna-maria@linutronix.de>
References: <20171221104205.7269-1-anna-maria@linutronix.de>
         <20171221104205.7269-32-anna-maria@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-12-21 at 11:42 +0100, Anna-Maria Gleixner wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> Switch the timer to HRTIMER_MODE_SOFT, which executed the timer

I've pointed out before that this should say HRTIMER_MODE_REL_SOFT.

Anyway, since it still doesn't apply on my tree, somebody else will
have to pick it up.

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:42851 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab3H0IBr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 04:01:47 -0400
Date: Tue, 27 Aug 2013 01:01:44 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	<ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 0/4] ath10k: fixes
Message-ID: <20130827080144.GB29102@pogo> (sfid-20130827_100150_039885_36836405)
References: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com>
 <1377507205-5386-1-git-send-email-michal.kazior@tieto.com>
 <CAB=NE6X=P2hTnOC8xqFwb=-32-hBgx=ndq3KHoUG83KptKv0vA@mail.gmail.com>
 <87mwo3mxil.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <87mwo3mxil.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 27, 2013 at 09:57:22AM +0300, Kalle Valo wrote:
> "Luis R. Rodriguez" <mcgrof@do-not-panic.com> writes:
> 
> > On Mon, Aug 26, 2013 at 1:53 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
> >>   ath10k: fix issues on non-preemptible systems
> >
> > This patch looks like a stable candidate fix. Please annotate as such
> > if you confirm. Also, I reviewed other ath10k "fixes" and I see no
> > practice of propagating any patches to stable yet. Can you please
> > start doing that? If there were patches which are already merged
> > upstream that should be propagated to stable then they can be
> > submitted as stable candidate patches.
> 
> I disagree. The point of linux-stable is _not_ that we send all possible
> fixes to stable. Instead we should send fixes only which really matter
> to users and for which we have received bug reports. I haven't yet seen
> any fix for ath10k which should be a candidate for stable releases.

You don't need to wait for an issue to happen to consider it serious,
the description of the symptoms seem pretty bad to me, but its your
call in the end.

> If we start sending all ath10k fixes to stable it's just extra churn for
> both Greg and people working on ath10k.

I'm not asking for anything that has the word "fix" to be sent, I'm
asking them to be reviewed for stable consideration.

  Luis

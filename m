Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:54198 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab3H0H77 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 03:59:59 -0400
Date: Tue, 27 Aug 2013 00:59:56 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	<ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 0/4] ath10k: fixes
Message-ID: <20130827075438.GA29102@pogo> (sfid-20130827_100003_054935_027A4128)
References: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com>
 <1377507205-5386-1-git-send-email-michal.kazior@tieto.com>
 <CAB=NE6X=P2hTnOC8xqFwb=-32-hBgx=ndq3KHoUG83KptKv0vA@mail.gmail.com>
 <CA+BoTQ=zVAab8KV2TwYJ=+wG0N7M4-oo-TgaE2qpxJO33d3oZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CA+BoTQ=zVAab8KV2TwYJ=+wG0N7M4-oo-TgaE2qpxJO33d3oZQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 27, 2013 at 07:42:39AM +0200, Michal Kazior wrote:
> On 26 August 2013 22:20, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
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
> Good point.
> 
> If this patch is to be propagated to stable the patch(set) needs some
> adjustments to avoid conflicts. Right now the patch touches a place
> that was introduced with "ath10k: move htt rx processing to worker" so
> the offending patch hunk should be moved to that patch.
> 
> Actually the "ath10k: make the workqueue multithreaded" could also be
> a candidate for stable as it fixes AP beaconing during heavy TX
> traffic. I should've mentioned that in the commit log.
> 
> I'll resend an updated patchset later today.

That one doesn't seem like a stable fix, it does quite a big change.

  Luis

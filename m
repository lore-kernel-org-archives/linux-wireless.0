Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:8391 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab3H0G52 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 02:57:28 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	<ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 0/4] ath10k: fixes
References: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com>
	<1377507205-5386-1-git-send-email-michal.kazior@tieto.com>
	<CAB=NE6X=P2hTnOC8xqFwb=-32-hBgx=ndq3KHoUG83KptKv0vA@mail.gmail.com>
Date: Tue, 27 Aug 2013 09:57:22 +0300
Message-ID: <87mwo3mxil.fsf@kamboji.qca.qualcomm.com> (sfid-20130827_085730_778087_05A539E6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@do-not-panic.com> writes:

> On Mon, Aug 26, 2013 at 1:53 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
>>   ath10k: fix issues on non-preemptible systems
>
> This patch looks like a stable candidate fix. Please annotate as such
> if you confirm. Also, I reviewed other ath10k "fixes" and I see no
> practice of propagating any patches to stable yet. Can you please
> start doing that? If there were patches which are already merged
> upstream that should be propagated to stable then they can be
> submitted as stable candidate patches.

I disagree. The point of linux-stable is _not_ that we send all possible
fixes to stable. Instead we should send fixes only which really matter
to users and for which we have received bug reports. I haven't yet seen
any fix for ath10k which should be a candidate for stable releases.

If we start sending all ath10k fixes to stable it's just extra churn for
both Greg and people working on ath10k.

-- 
Kalle Valo

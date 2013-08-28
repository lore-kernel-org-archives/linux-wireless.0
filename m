Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:56169 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab3H1Dx7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 23:53:59 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	<ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 0/4] ath10k: fixes
References: <1377066854-13981-1-git-send-email-michal.kazior@tieto.com>
	<1377507205-5386-1-git-send-email-michal.kazior@tieto.com>
	<CAB=NE6X=P2hTnOC8xqFwb=-32-hBgx=ndq3KHoUG83KptKv0vA@mail.gmail.com>
	<87mwo3mxil.fsf@kamboji.qca.qualcomm.com>
	<20130827080144.GB29102@pogo>
Date: Wed, 28 Aug 2013 06:53:53 +0300
In-Reply-To: <20130827080144.GB29102@pogo> (Luis R. Rodriguez's message of
	"Tue, 27 Aug 2013 01:01:44 -0700")
Message-ID: <87bo4ilbce.fsf@kamboji.qca.qualcomm.com> (sfid-20130828_055408_396499_8AEF3737)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com> writes:

>> I disagree. The point of linux-stable is _not_ that we send all possible
>> fixes to stable. Instead we should send fixes only which really matter
>> to users and for which we have received bug reports. I haven't yet seen
>> any fix for ath10k which should be a candidate for stable releases.
>
> You don't need to wait for an issue to happen to consider it serious,
> the description of the symptoms seem pretty bad to me, but its your
> call in the end.
>
>> If we start sending all ath10k fixes to stable it's just extra churn for
>> both Greg and people working on ath10k.
>
> I'm not asking for anything that has the word "fix" to be sent, I'm
> asking them to be reviewed for stable consideration.

I think a good rule is that we should send fixes to stable only if a
user (!= developer) has reported the problem.

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57794 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbbHSLNw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 07:13:52 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2015-08-19
References: <87pp2ja6ar.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 19 Aug 2015 14:13:46 +0300
In-Reply-To: <87pp2ja6ar.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Wed, 19 Aug 2015 14:03:56 +0300")
Message-ID: <87bne3a5ud.fsf@kamboji.qca.qualcomm.com> (sfid-20150819_131400_272415_40A5F6EB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> here's one more pull request for 4.3. More info in the signed tag below.
>
> This time I had to merge mac80211-next.git due to some iwlwifi
> dependencies and apparently that broke git-request-pull's diffstat
> again, it was showing changes which were not really coming from my tree.
> I think that's just a bug in my old git and really should update the
> tool. This time I just fixed the diffstat manually.
>
> But please be extra careful with this pull request and please let me
> know if you have any problems.

Oh, I forgot to mention that I saw this build error when I did a test
merge:

net/ipv4/fib_semantics.c:553:3: error: implicit declaration of function lwtstate_free [-Werror=implicit-function-declaration]

But I see that also with unmodified net-next so I'm assuming I didn't
cause that :)

-- 
Kalle Valo

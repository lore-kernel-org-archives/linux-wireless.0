Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vserver.eikelenboom.it ([84.200.39.61]:54738 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaBZHlo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 02:41:44 -0500
Date: Wed, 26 Feb 2014 08:41:39 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Message-ID: <681715589.20140226084139@eikelenboom.it> (sfid-20140226_084153_845945_539593D6)
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 0/3] cfg80211: respin reprocessing pending requests
In-Reply-To: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com>
References: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Wednesday, February 26, 2014, 2:09:39 AM, you wrote:

> Here's a respin. There are no code changes, I just adjusted the
> commit logs as that's all the feedback I got from them, and on
> the last patch I just don't think a timer is best. If a timer
> is desired let me know how much time you want to set it for,
> I just don't see how that's any better.

> The commit log on the other ones should help let people make
> decisions if the implications of not merging this, I'll let
> folks make the call about whether or not some of these belong
> to stable, I personally don't think so -- but some others may
> disagree.

I tested the original series and these fixed my problem and i did not
notice any regressions. Since there are no code changes:

Tested-By: Sander Eikelenboom <linux@eikelenboom.it>

Thanks Luis !
Hopefully it is going somewhere now after so many months.

-
Sander

> Luis R. Rodriguez (3):
>   cfg80211: allow reprocessing of pending requests
>   cfg80211: fix processing world regdomain when non modular
>   cfg80211: processing regulatory requests on netdev notifier

>  net/wireless/reg.c | 16 +++++++++-------
>  net/wireless/reg.h |  1 +
>  2 files changed, 10 insertions(+), 7 deletions(-)



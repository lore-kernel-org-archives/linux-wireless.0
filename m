Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37920 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751137AbcIQN7N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 09:59:13 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>,
        Avinash Patil <avinashp@quantenna.com>,
        Dmitrii Lebed <dlebed@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>
Subject: Re: [PATCH v2 RESEND] qtnfmac: announcement of new FullMAC driver for Quantenna chipsets
References: <1466460688-28160-1-git-send-email-igor.mitsyanko.os@quantenna.com>
        <1466511726.3170.33.camel@sipsolutions.net>
        <fd6ee9cd-71fd-352a-e1cd-61d36b296057@quantenna.com>
Date: Sat, 17 Sep 2016 16:59:06 +0300
In-Reply-To: <fd6ee9cd-71fd-352a-e1cd-61d36b296057@quantenna.com> (Igor
        Mitsyanko's message of "Mon, 11 Jul 2016 21:57:15 +0300")
Message-ID: <8760pu8w5x.fsf@kamboji.qca.qualcomm.com> (sfid-20160917_155916_960126_554D4E1F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Igor Mitsyanko <igor.mitsyanko.os@quantenna.com> writes:

> thank for review and sorry for long delays in replies. A parallel
> thread with Dave a discussion was initiated regarding HW platform
> samples availability. Current driver implementation supports a newer
> QSR10G platform, which availability is limited due to the platform
> still being in development stage. We're working on supporting
> Quantenna's current QSR1000 platform too, what would be the best
> approach to this:
> - have QSR1000 platform support ready, amend it to current patch and
> post it as a new patch revision (there should be a certain amount of
> new code);
> - have current patch accepted by community first, and then post a new
> patch (adding new platform support) one on top of it.

I prefer the latter option. Let's first try to get the driver applied
and then you can submit more features as followup patches.

-- 
Kalle Valo

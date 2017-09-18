Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55998 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752743AbdIRMwB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 08:52:01 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 2/2] qtnfmac: abort scans on wireless interface changes
References: <20170918080446.21763-1-sergey.matyukevich.os@quantenna.com>
        <20170918080446.21763-3-sergey.matyukevich.os@quantenna.com>
        <1505724068.13691.0.camel@sipsolutions.net>
        <20170918095713.mfn76hkdbo73k4fu@bars>
Date: Mon, 18 Sep 2017 15:51:57 +0300
In-Reply-To: <20170918095713.mfn76hkdbo73k4fu@bars> (Sergey Matyukevich's
        message of "Mon, 18 Sep 2017 12:57:13 +0300")
Message-ID: <87shfkkw42.fsf@purkki.adurom.net> (sfid-20170918_145205_358775_21A0330A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> By the way, is it ok to send corrected single patch in reply to this
> discussion ? Or the appropriate way is to resend the whole patch set ?

This has been a common question so I documented it:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#resubmit_the_whole_patchset

I leave it as an exercise to the reader to find the answer, even though
the URL even spoils it ;)

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53378 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752938AbcISTlm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 15:41:42 -0400
Message-ID: <1474314095.6544.4.camel@sipsolutions.net> (sfid-20160919_214153_201106_215F4558)
Subject: Re: nl80211 fine timing measurement support
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Lior David <liord@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, Luca Coelho <luca@coelho.fi>
Date: Mon, 19 Sep 2016 21:41:35 +0200
In-Reply-To: <45d2980c-aeb4-4faa-e73f-75747124e9eb@broadcom.com> (sfid-20160919_204318_559846_A75E8F00)
References: <e7096bbb-ba66-e639-b86e-a483dc198b85@codeaurora.org>
         <45d2980c-aeb4-4faa-e73f-75747124e9eb@broadcom.com>
         (sfid-20160919_204318_559846_A75E8F00)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > However I did not see any comments or response on this
> > patch. Can you please update if you plan on eventually submitting
> > this patch?
> 
> You can find several FTM related patches in backport-iwlwifi repo on
> kernel.org. See link to git log of nl80211.h there [1].
> 

You can find things there, but they might not be the most organized
always :)

Anyway, I think after Luca is handling the current round of NaN
submission he'll have the cycles to deal with FTM - I'll let him
comment. For all I care, they can also run in parallel, but that might
be more difficult for him.

johannes

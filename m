Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:52760 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbeH1Pq5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 11:46:57 -0400
Message-ID: <1535457328.5895.35.camel@sipsolutions.net> (sfid-20180828_135541_141178_FA897412)
Subject: Re: [PATCH] mac80211: WFA Multi-AP backhaul STA Rx requirement
From: Johannes Berg <johannes@sipsolutions.net>
To: murugana@codeaurora.org, linux-wireless@vger.kernel.org
Cc: 'Felix Fietkau' <nbd@nbd.name>
Date: Tue, 28 Aug 2018 13:55:28 +0200
In-Reply-To: <003d01d43ec5$ab42fb00$01c8f100$@codeaurora.org>
References: <1534423635-28222-1-git-send-email-murugana@codeaurora.org>
                 (sfid-20180816_144745_205490_C47B9321) <1535450281.5895.34.camel@sipsolutions.net>
         <003d01d43ec5$ab42fb00$01c8f100$@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-28 at 17:22 +0530, murugana@codeaurora.org wrote:
> Hi Johannes,
> 
> > Hmm. The subject/patch title isn't very clear - does it *implement* this
> > requirement? Or do something else with it? Please clarify.
> > 
> 
> Yes, this patch implements the missing Rx requirement (ii) for backhaul STA
> below.
> 
Right. Can you clean up the commit log a bit and in particular clarify
the subject please?

johannes

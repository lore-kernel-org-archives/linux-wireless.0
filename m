Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42470 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbdALOyi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 09:54:38 -0500
Date: Thu, 12 Jan 2017 20:24:23 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
        linux-wireless@vger.kernel.org, greearb@candelatech.com,
        mohammed@qti.qualcomm.com
Subject: Re: [PATCH] mac80211: prevent skb/txq mismatch
Message-ID: <20170112145423.GB10941@atheros-ThinkPad-T61> (sfid-20170112_155539_606766_7CA5E48D)
References: <1484231321-3179-1-git-send-email-michal.kazior@tieto.com>
 <20170112144527.GA10941@atheros-ThinkPad-T61>
 <1484232680.5391.8.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1484232680.5391.8.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 12, 2017 at 03:51:20PM +0100, Johannes Berg wrote:
> On Thu, 2017-01-12 at 20:15 +0530, Mohammed Shafi Shajakhan wrote:
> > 
> > > Reported-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> > > Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> > 
> > Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> That makes no sense, you're not handling the patch in any way. You can
> say Tested-by, or Acked-by if you like, but not S-o-b. See the DCO
> (Documentation/SubmittingPatches)
>
apologies for that, I assumed we can add Signed-off on the fly

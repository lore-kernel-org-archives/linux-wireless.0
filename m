Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43514 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750750AbdALOvZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 09:51:25 -0500
Message-ID: <1484232680.5391.8.camel@sipsolutions.net> (sfid-20170112_155128_341181_D5E9AA0F)
Subject: Re: [PATCH] mac80211: prevent skb/txq mismatch
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>,
        Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        mohammed@qti.qualcomm.com
Date: Thu, 12 Jan 2017 15:51:20 +0100
In-Reply-To: <20170112144527.GA10941@atheros-ThinkPad-T61>
References: <1484231321-3179-1-git-send-email-michal.kazior@tieto.com>
         <20170112144527.GA10941@atheros-ThinkPad-T61>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-01-12 at 20:15 +0530, Mohammed Shafi Shajakhan wrote:
> 
> > Reported-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> > Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

That makes no sense, you're not handling the patch in any way. You can
say Tested-by, or Acked-by if you like, but not S-o-b. See the DCO
(Documentation/SubmittingPatches)

johannes

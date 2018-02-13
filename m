Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:57812 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934545AbeBMJSL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 04:18:11 -0500
Message-ID: <1518513488.2494.0.camel@sipsolutions.net> (sfid-20180213_101825_483448_DC5414BB)
Subject: Re: [PATCHv2 3/3] ath: change in cfg80211_probe_status API
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@codeaurora.org>,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 Feb 2018 10:18:08 +0100
In-Reply-To: <87inb1p8c3.fsf@purkki.adurom.net>
References: <1518500128-10837-1-git-send-email-vnaralas@codeaurora.org>
         <87inb1p8c3.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-02-13 at 11:06 +0200, Kalle Valo wrote:
> Venkateswara Naralasetty <vnaralas@codeaurora.org> writes:
> 
> > This patch changes cfg80211_probe_status API.
> > 
> > Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
> > ---
> >  drivers/net/wireless/ath/wil6210/cfg80211.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> The title prefix should be "wil6210:", not "ath:".

Doesn't matter, it has to be squashed into patch 1 anyway ... I guess
I'll do that.

johannes

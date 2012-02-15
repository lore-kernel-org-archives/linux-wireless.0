Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:41301 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755529Ab2BOKQz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 05:16:55 -0500
Received: by lahl5 with SMTP id l5so1213121lah.17
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 02:16:53 -0800 (PST)
Message-ID: <1329301009.19569.41.camel@cumari> (sfid-20120215_111658_948346_EBB59ADA)
Subject: Re: [PATCH 1/4] wl12xx: Set IEEE80211_TX_RC_MCS on MCS rates on TX
 complete.
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Feb 2012 12:16:49 +0200
In-Reply-To: <1328025283-22888-1-git-send-email-eliad@wizery.com>
References: <1328025283-22888-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-01-31 at 17:54 +0200, Eliad Peller wrote: 
> From: Pontus Fuchs <pontus.fuchs@gmail.com>
> 
> IEEE80211_TX_RC_MCS was not set correctly leading to incorrect link
> speed calculation.
> 
> Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
> Signed-off-by: Ido Reis <idor@ti.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied this patchset.  Thanks.

-- 
Cheers,
Luca.


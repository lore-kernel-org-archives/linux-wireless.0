Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:50754 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754655Ab1BWNwW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 08:52:22 -0500
Received: by mail-wy0-f180.google.com with SMTP id 23so1283535wyf.39
        for <linux-wireless@vger.kernel.org>; Wed, 23 Feb 2011 05:52:21 -0800 (PST)
Subject: Re: [PATCH] wl12xx: declare support for
 IEEE80211_HW_REPORTS_TX_ACK_STATUS
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1296638405-28704-1-git-send-email-eliad@wizery.com>
References: <1296638405-28704-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 15:52:17 +0200
Message-ID: <1298469137.2104.20.camel@pimenta>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-02 at 11:20 +0200, Eliad Peller wrote:
> The wl12xx fw supports ack status reporting for tx frames, so
> add the IEEE80211_HW_REPORTS_TX_ACK_STATUS flag to our supported
> features.
> 
> Since we do the rate control in the fw, we'll probably want
> to adjust the STA_LOST_PKT_THRESHOLD heuristics in the future, to
> account for retransmissions as well.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> --- 

Applied, thank you!

-- 
Cheers,
Luca.


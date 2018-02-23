Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swan.media.mit.edu ([18.85.44.157]:43686 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750903AbeBWFZb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Feb 2018 00:25:31 -0500
Date: Fri, 23 Feb 2018 16:25:24 +1100
From: James Cameron <quozl@laptop.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: rtl8723be: Fix loss of signal
Message-ID: <20180223052524.GB19194@us.netrek.org> (sfid-20180223_062535_693080_4FD8BB56)
References: <20180222202859.16679-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180222202859.16679-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 22, 2018 at 02:28:59PM -0600, Larry Finger wrote:
> In commit c713fb071edc ("rtlwifi: rtl8821ae: Fix connection lost problem
> correctly") a problem in rtl8821ae that caused loss of signal was fixed.
> That same problem has now been reported for rtl8723be. Accordingly,
> the ASPM L1 latency has been increased from 0 to 7 to fix the instability.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>

Tested-by: James Cameron <quozl@laptop.org>

With both patches applied to v4.15 on OLPC NL3 with rtl8723be.

Nice catch, well done!  May explain some of our problems with
rtl8723be that made me withdraw it from production of laptops.

-- 
James Cameron
http://quozl.netrek.org/

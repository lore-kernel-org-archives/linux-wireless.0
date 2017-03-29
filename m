Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41466 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753517AbdC2HNX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 03:13:23 -0400
Message-ID: <1490771594.18052.6.camel@sipsolutions.net> (sfid-20170329_091542_984750_1A33E17E)
Subject: Re: [PATCH for-4.11 2/2] cfg80211: check rdev resume callback only
 for registered wiphy
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Daniel J Blueman <daniel@quora.org>
Date: Wed, 29 Mar 2017 09:13:14 +0200
In-Reply-To: <1490688691-20100-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170328_112615_711798_FE2BF116)
References: <1490688691-20100-1-git-send-email-arend.vanspriel@broadcom.com>
         <1490688691-20100-3-git-send-email-arend.vanspriel@broadcom.com>
         (sfid-20170328_112615_711798_FE2BF116)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-03-28 at 09:11 +0100, Arend van Spriel wrote:
> We got the following use-after-free KASAN report:
> 
[...]

Applied.

johannes

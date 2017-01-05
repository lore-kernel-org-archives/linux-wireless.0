Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49272 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752336AbdAEMAq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 07:00:46 -0500
Message-ID: <1483617591.4394.14.camel@sipsolutions.net> (sfid-20170105_130050_654793_90435159)
Subject: Re: [PATCH] cfg80211: only pass sband to set_mandatory_flags_band()
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 05 Jan 2017 12:59:51 +0100
In-Reply-To: <1483527217-11854-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1483527217-11854-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-01-04 at 10:53 +0000, Arend van Spriel wrote:
> The supported band structure contains the band is applies to
> so no need to pass it separately. Also added a default case
> to the switch for completeness. The current code base does not
> call this function with NUM_NL80211_BANDS but kept that case
> statement although default case would cover that.
> 
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
> Stumbled upon this function and wanted to start the new year lightly.
> It applies to master branch of mac80211-next repo.

Some light finger exercises to warm up for the year? :-)

Applied, thanks

johannes

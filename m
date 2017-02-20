Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48170 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752326AbdBTJvW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 04:51:22 -0500
Message-ID: <1487582393.5474.2.camel@sipsolutions.net> (sfid-20170220_105125_209862_02FE8C56)
Subject: Re: [RFC V3 0/5] cfg80211: support multiple scheduled scans
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 20 Feb 2017 10:19:53 +0100
In-Reply-To: <1487155049-1892-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1487155049-1892-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-02-15 at 10:37 +0000, Arend van Spriel wrote:
> Another review round for multiple scheduled scan support in nl80211.
> 


Looks fine to me. Not sure I see much value in splitting patches 4/5,
but whichever you prefer is fine with me.

Maybe some of the commit messages ("It mainly illustrates ...") could
use some rewording :)

johannes

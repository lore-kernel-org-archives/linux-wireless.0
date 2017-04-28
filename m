Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50618 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1035520AbdD1K0p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 06:26:45 -0400
Message-ID: <1493375202.2431.9.camel@sipsolutions.net> (sfid-20170428_122713_210716_34536ACC)
Subject: Re: [PATCH] mac80211: Fix possible sband related NULL pointer
 de-reference (fwd)
From: Johannes Berg <johannes@sipsolutions.net>
To: Julia Lawall <julia.lawall@lip6.fr>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, mohammed@codeaurora.org,
        Michal Kazior <michal.kazior@tieto.com>, kbuild-all@01.org
Date: Fri, 28 Apr 2017 12:26:42 +0200
In-Reply-To: <alpine.DEB.2.20.1704281205580.3387@hadrien>
References: <alpine.DEB.2.20.1704281205580.3387@hadrien>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-04-28 at 12:06 +0200, Julia Lawall wrote:
> Please check whether an unlock is missing on line 3009-3013.

Yep, thanks. I'll fix it

johannes

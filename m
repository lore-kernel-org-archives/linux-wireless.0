Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45722 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751753AbdIUNt7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2017 09:49:59 -0400
Message-ID: <1506001797.2048.3.camel@sipsolutions.net> (sfid-20170921_155003_576574_537A168D)
Subject: Re: [PATCH 1/2] wireless: set correct mandatory rate flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Richard =?ISO-8859-1?Q?Sch=FCtz?= <rschuetz@uni-koblenz.de>,
        linux-wireless@vger.kernel.org
Date: Thu, 21 Sep 2017 15:49:57 +0200
In-Reply-To: <20170907154744.28357-1-rschuetz@uni-koblenz.de> (sfid-20170907_175508_102149_80D1890A)
References: <20170907154744.28357-1-rschuetz@uni-koblenz.de>
         (sfid-20170907_175508_102149_80D1890A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-09-07 at 17:47 +0200, Richard Schütz wrote:
> According to IEEE Std 802.11-2016 (16.2.3.4 Long PHY SIGNAL field)
> all of
> the following rates are mandatory for a HR/DSSS PHY: 1 Mb/s, 2 Mb/s,
> 5.5 Mb/s and 11 Mb/s. Set IEEE80211_RATE_MANDATORY_B flag for all of
> these
> instead of just 1 Mb/s to correctly reflect this.

Applied, but I modified it to use a switch statement.

johannes

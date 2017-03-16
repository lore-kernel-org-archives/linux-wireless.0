Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41764 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751428AbdCPJzW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 05:55:22 -0400
Message-ID: <1489658101.2370.2.camel@sipsolutions.net> (sfid-20170316_105538_454597_AFEDC44E)
Subject: Re: [PATCH 1/2] nl80211: Use signed function for a signed variable
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 16 Mar 2017 10:55:01 +0100
In-Reply-To: <1489629438-7087-1-git-send-email-masashi.honma@gmail.com> (sfid-20170316_025739_682372_2431ED63)
References: <1489629438-7087-1-git-send-email-masashi.honma@gmail.com>
         (sfid-20170316_025739_682372_2431ED63)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-03-16 at 10:57 +0900, Masashi Honma wrote:
> The rssi_threshold is defined as s32.
> 
Doesn't really matter much, but does seem nicer - applied.

johannes

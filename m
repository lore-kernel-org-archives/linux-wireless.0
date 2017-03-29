Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42678 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754107AbdC2I3I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 04:29:08 -0400
Message-ID: <1490776145.7948.7.camel@sipsolutions.net> (sfid-20170329_102920_553199_8605A53C)
Subject: Re: [PATCH v2] mac80211: Use rssi_threshold even though user_mpm=1
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 Mar 2017 10:29:05 +0200
In-Reply-To: <63b7e146-ae26-6f29-b864-57efeaf2f10c@gmail.com> (sfid-20170326_225349_406857_8D39C371)
References: <1489629438-7087-1-git-send-email-masashi.honma@gmail.com>
         <1489730384-2799-1-git-send-email-masashi.honma@gmail.com>
         <63b7e146-ae26-6f29-b864-57efeaf2f10c@gmail.com>
         (sfid-20170326_225349_406857_8D39C371)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-03-27 at 05:53 +0900, Masashi Honma wrote:
> On 2017/03/17 14:59, Masashi Honma wrote:
> > Previously the meshcfg.rssi_threshold did not work with user_mpm=1.
> > 
> > Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
> 
> Is there any comment ?

I just applied the other patch "drop new node"

johannes

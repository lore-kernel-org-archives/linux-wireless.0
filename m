Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42666 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754184AbdC2I0r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 04:26:47 -0400
Message-ID: <1490776004.7948.6.camel@sipsolutions.net> (sfid-20170329_102739_627240_660799C4)
Subject: Re: [PATCH 2/2] mac80211: Drop new node with weak power
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 Mar 2017 10:26:44 +0200
In-Reply-To: <c95cce88-d02f-8ef3-a848-0a8a3de6296b@gmail.com> (sfid-20170320_073906_323967_73B5ACF2)
References: <1489629438-7087-1-git-send-email-masashi.honma@gmail.com>
         <1489629438-7087-2-git-send-email-masashi.honma@gmail.com>
         <1489658630.2370.4.camel@sipsolutions.net>
         <d0eb6984-6ae7-d984-b61a-0c98603294ae@gmail.com>
         <1489753692.2544.9.camel@sipsolutions.net>
         <c95cce88-d02f-8ef3-a848-0a8a3de6296b@gmail.com>
         (sfid-20170320_073906_323967_73B5ACF2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> But we still needs this patch for a special case on SAE. Some
> hardware can use hardware encryption for mesh SAE. Then the hardware
> has a limitation of key registration. For example, some hardware
> could only save keys for 8 stations. So we need to drop stations
> itself with weak signal instead of the pathes to its.

Fair enough. I've added that to the ocmmit message and applied the
patch.

johannes

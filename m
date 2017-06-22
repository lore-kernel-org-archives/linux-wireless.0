Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56454 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751159AbdFVGYM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 02:24:12 -0400
Message-ID: <1498112650.2246.1.camel@sipsolutions.net> (sfid-20170622_082416_165692_14F8C173)
Subject: Re: [RFC 3/6] mac80211: add a TXQ for other powersave-buffered
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
Cc: nbd@nbd.name
Date: Thu, 22 Jun 2017 08:24:10 +0200
In-Reply-To: <63c97c53-af93-107a-a28e-59cebcf01fd6@candelatech.com>
References: <20170621235022.25362-1-johannes@sipsolutions.net>
         <20170621235022.25362-3-johannes@sipsolutions.net>
         <63c97c53-af93-107a-a28e-59cebcf01fd6@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-06-21 at 17:02 -0700, Ben Greear wrote:
> I think a comment for the above code block would be warranted (and
> for ath10k as well).
> 
> I guess this is the part about dequeueing the frames immediately?

Yeah, I figured it was pretty obvious, but I can add a comment :)

johannes

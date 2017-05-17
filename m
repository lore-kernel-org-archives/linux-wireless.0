Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40852 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754181AbdEQNeb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 May 2017 09:34:31 -0400
Message-ID: <1495028069.2442.17.camel@sipsolutions.net> (sfid-20170517_153436_034963_0847EC38)
Subject: Re: nl80211 vendor commands on upstream drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Date: Wed, 17 May 2017 15:34:29 +0200
In-Reply-To: <87wp9mp4hz.fsf@kamboji.qca.qualcomm.com> (sfid-20170512_155201_855594_38A6052A)
References: <87wp9mp4hz.fsf@kamboji.qca.qualcomm.com>
         (sfid-20170512_155201_855594_38A6052A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-05-12 at 16:51 +0300, Kalle Valo wrote:
> 
> But this does not mean that the gates are open for all possible hacks
> via vendor commands, we still want to have generic nl80211 interface
> for all normal functionality. Just to give some examples of something
> which is NOT acceptable:

[snip scanning]

> * power save settings
> * btcoex settings

I'm starting to think that these might really be a vendor API for
anything but the most basic features - there's so much variation here
now.

OTOH, much of these shouldn't really be something the user needs to
twiddle with anyway.

> Comments? Am I forgetting something from the discussion?

I think that's a good summary.

johannes

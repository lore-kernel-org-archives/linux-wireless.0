Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:50874 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751523AbdKULYi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 06:24:38 -0500
Message-ID: <1511263472.2030.48.camel@sipsolutions.net> (sfid-20171121_122442_977924_F1FBE901)
Subject: Re: pull-request: mac80211 2017-11-20
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Tue, 21 Nov 2017 12:24:32 +0100
In-Reply-To: <20171121.201722.1123390949587944979.davem@davemloft.net>
References: <20171120160645.21074-1-johannes@sipsolutions.net>
         <20171121.201722.1123390949587944979.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-11-21 at 20:17 +0900, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Mon, 20 Nov 2017 17:06:44 +0100
> 
> >   ssh://korg/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2017-11-20
> 
> That's an awesome URL, but I don't think I'll be able to pull
> from it :-)

Huh. That's what I get for following Konstantin's advice to use
insteadOf in git configuration ...

Should be

git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2017-11-20

(or https if you prefer)

johannes

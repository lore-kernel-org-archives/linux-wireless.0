Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:50802 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727169AbeH1MxC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 08:53:02 -0400
Message-ID: <1535446933.5895.17.camel@sipsolutions.net> (sfid-20180828_110242_445862_03077362)
Subject: Re: [PATCH 1/7] wireless: Change single cqm_config to rssi config
 list
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 28 Aug 2018 11:02:13 +0200
In-Reply-To: <b01b72d2d5796c627d060e0d3a517f3f@codeaurora.org>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
         <1528886747-26342-2-git-send-email-tamizhr@codeaurora.org>
         <1530264405.3481.31.camel@sipsolutions.net>
         <32a52d2ea57526cfe8c6311e6e34aaac@codeaurora.org>
         <1530877576.3197.11.camel@sipsolutions.net>
         <b01b72d2d5796c627d060e0d3a517f3f@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-07-11 at 12:24 +0530, Tamizh chelvam wrote:
> 
> > Again though - see above. I'm not sure it's even correct to link it to
> > the BSSID since until now, I think the configuration would remain 
> > across
> > roaming?
> > 
> 
> As mentioned above storing configuration parameters in mac80211 will 
> avoid this list implementation here.
> So, no need of worrying about those roaming scenario know ?

I think we should tie it to the station lifetime and have it
reconfigured on roaming etc., and if that means it's easier by storing
in mac80211 I have no objection.

johannes

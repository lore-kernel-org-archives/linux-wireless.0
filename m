Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57186 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755824AbcJNH1H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Oct 2016 03:27:07 -0400
Message-ID: <1476430023.4382.13.camel@sipsolutions.net> (sfid-20161014_092710_663067_FD5C1AB6)
Subject: Re: [PATCH] cfg80211: Add support to update connection parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        vamsi krishna <vamsin@qti.qualcomm.com>
Date: Fri, 14 Oct 2016 09:27:03 +0200
In-Reply-To: <61aa0cc9-6485-b206-56ce-cd682d91dd96@broadcom.com> (sfid-20161013_205825_310572_BFC39EA5)
References: <1476373178-31105-1-git-send-email-jouni@qca.qualcomm.com>
         <61aa0cc9-6485-b206-56ce-cd682d91dd96@broadcom.com>
         (sfid-20161013_205825_310572_BFC39EA5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> >  /**
> > + * struct cfg80211_connect_params_valid - Connection parame ters
> > to be updated
> 
> What's in a name? Could we just use '_updated' instead of '_valid'
> here and below.

In mac80211 we typically just have a single "u32 changed" argument,
with bits defined in an enum - wouldn't that be sufficient here as
well?

johannes

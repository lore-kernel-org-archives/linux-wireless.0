Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:50616 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbeH1MeB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 08:34:01 -0400
Message-ID: <1535445791.5895.0.camel@sipsolutions.net> (sfid-20180828_104328_846287_57E00620)
Subject: Re: [PATCH 0/3] Add support for ftm responder configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Date: Tue, 28 Aug 2018 10:43:11 +0200
In-Reply-To: <4fb78fad97704c8b3b1433085355180c@codeaurora.org>
References: <7999c366492a4523456227fb49329bf2@codeaurora.org>
         <1534922856.25523.60.camel@sipsolutions.net>
         <4fb78fad97704c8b3b1433085355180c@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-08-22 at 11:22 -0700, Pradeep Kumar Chitrapu wrote:

> > Should we just ignore that? Or perhaps add a separate capability for 
> > it?
> 
> Yes, even we behave the same. In that case, we can go ahead now with the
> capability to only enable FTM responder. If the driver wants to support
> disabling option in future, at which point, the new capability can be 
> added.

True.

> However, changes to nl80211_set_beacon to support enabling FTM responder
> may still be needed along with start_ap, assuming that ap start will be 
> issued by different android api than enableResponder api.

Yes, I guess that's still needed to be able to support the Android API,
which seems useful.

johannes

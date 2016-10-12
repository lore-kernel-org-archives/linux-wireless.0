Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:44171 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752060AbcJLLCj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 07:02:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 12 Oct 2016 13:02:22 +0200
From: michael-dev <michael-dev@fami-braun.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Subject: Re: [PATCH v2] mac80211: enable to inject a-msdu frames using monitor
 interface
In-Reply-To: <1476257614.5271.8.camel@sipsolutions.net>
References: <1476118105-7641-1-git-send-email-michael-dev@fami-braun.de>
 <1476257614.5271.8.camel@sipsolutions.net>
Message-ID: <ead6c21d249208efb2bd882c5db721ec@fami-braun.de> (sfid-20161012_130243_032321_59FE63BB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 12.10.2016 09:33, schrieb Johannes Berg:
> However, re-reading *p looks strange to me. Why don't we just refactor
> this to preserve everything but the TID and ACK policy, after all, we
> have just previous created this all zeroed in most cases, so it won't
> really matter.

Looks good to me.

I've re-run the amsdu spoofing hwsim test as it includes an amsdu 
injection test and as expected it still works.

Regards,
M. Braun

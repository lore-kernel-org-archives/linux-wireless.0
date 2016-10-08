Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:25260 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754693AbcJHKNi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Oct 2016 06:13:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sat, 08 Oct 2016 12:13:03 +0200
From: michael-dev <michael-dev@fami-braun.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
        kvalo@codeaurora.org, akarwar@marvell.com, nishants@marvell.com,
        Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com
Subject: Re: [PATCHv4] mac80211: check A-MSDU inner frame source address on AP
 interfaces
In-Reply-To: <1475753787.2015.13.camel@sipsolutions.net>
References: <1475661751-26262-1-git-send-email-michael-dev@fami-braun.de>
 <1475679558.5257.7.camel@sipsolutions.net>
 <bb2ea10f30d2ae8a3cc048974ed148c8@fami-braun.de>
 <1475753787.2015.13.camel@sipsolutions.net>
Message-ID: <533ec0874b52264792ac4f9366ad71c0@fami-braun.de> (sfid-20161008_121342_329015_23FF0D71)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 06.10.2016 13:36, schrieb Johannes Berg:
> Could you test my patches in your scenario to see they do what we want?
> I'll resend as [PATCH] then, and think about applying them and perhaps
> backporting also.

I've tested them by running a new hostapd hwsim test [1] and after 
applying [2].
I can confirm that this tests fails without your RFC series applied and 
passes when your RFC series is applied.
So your RFC is fine.

Tested-by: Michael Braun <michael-dev@fami-braun.de>

Regards,
M. Braun


[1] 
https://github.com/michael-dev/hostapd/commit/2caecdd9911529e39c6b8a83aac0cbe737dc8f65
[2] https://patchwork.kernel.org/patch/9367469/

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47972 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752258AbcJEJ4m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 05:56:42 -0400
Message-ID: <1475661397.4994.23.camel@sipsolutions.net> (sfid-20161005_115645_056612_D16A79BB)
Subject: Re: [PATCH 2/3] mac80211: filter multicast data packets on AP /
 AP_VLAN
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Date: Wed, 05 Oct 2016 11:56:37 +0200
In-Reply-To: <1475643324-2845-2-git-send-email-michael-dev@fami-braun.de>
References: <1475643324-2845-1-git-send-email-michael-dev@fami-braun.de>
         <1475643324-2845-2-git-send-email-michael-dev@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Therefore, two new num_mcast_sta like counters are added: one for the
> number of authorized stations connected to an AP_VLAN interface and
> one for the number of authorized stations connected to the bss and
> not assigned to any AP_VLAN. The already existing num_mcast_sta
> counter is left unchanged as it is used by SMPS.

I think this is no longer accurate?

johannes

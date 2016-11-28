Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43156 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932283AbcK1OUZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 09:20:25 -0500
Message-ID: <1480342821.8107.44.camel@sipsolutions.net> (sfid-20161128_152027_957954_3DB43816)
Subject: Re: [PATCH 2/2] cfg80211: Add support to sched scan to report
 better BSSs
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        vamsi krishna <vamsin@qti.qualcomm.com>
Date: Mon, 28 Nov 2016 15:20:21 +0100
In-Reply-To: <ee0072cd-83b8-1264-d792-bcf4ce1a8940@broadcom.com> (sfid-20161127_215109_122180_ADB0DD12)
References: <1479938857-1788-1-git-send-email-jouni@qca.qualcomm.com>
         <1479938857-1788-2-git-send-email-jouni@qca.qualcomm.com>
         <ee0072cd-83b8-1264-d792-bcf4ce1a8940@broadcom.com>
         (sfid-20161127_215109_122180_ADB0DD12)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> It seems there has already
> been taken a shot at this which may be used/extended [1].
> 

That's a good point - it's somewhat similar.

This is obviously a different context - offloaded BSS selection vs.
scheduled scan (for host BSS selection), but perhaps the attribute &
definitions could be reused?

johannes

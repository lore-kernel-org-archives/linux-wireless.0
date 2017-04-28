Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52414 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425868AbdD1Mw4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 08:52:56 -0400
Message-ID: <1493383974.2431.16.camel@sipsolutions.net> (sfid-20170428_145308_527114_B5396665)
Subject: Re: [PATCH V4] cfg80211: add request id to cfg80211_sched_scan_*()
 api
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 28 Apr 2017 14:52:54 +0200
In-Reply-To: <1493383228-30528-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1493383228-30528-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-04-28 at 13:40 +0100, Arend van Spriel wrote:
> Have proper request id filled in the SCHED_SCAN_RESULTS and
> SCHED_SCAN_STOPPED notifications toward user-space by having the
> driver provide it through the api.
> 
Looks good, thanks :)

johannes

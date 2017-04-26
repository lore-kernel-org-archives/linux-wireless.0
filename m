Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43460 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1432781AbdDZHHg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 03:07:36 -0400
Message-ID: <1493190451.2464.1.camel@sipsolutions.net> (sfid-20170426_090748_678117_8F8F57A6)
Subject: Re: [PATCH V3 0/9] cfg80211: support multiple scheduled scans
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 26 Apr 2017 09:07:31 +0200
In-Reply-To: <1492776308-15120-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1492776308-15120-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>   nl80211: allow multiple active scheduled scan requests
>   nl80211: add support for BSSIDs in scheduled scan matchsets
>   cfg80211: add request id parameter to .sched_scan_stop() signature

I applied these.

>   cfg80211: add request id to cfg80211_sched_scan_*() api

Will comment here separately.

johannes

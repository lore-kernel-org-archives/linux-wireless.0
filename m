Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39028 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758820AbdEWMnd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 May 2017 08:43:33 -0400
Message-ID: <1495543411.2464.5.camel@sipsolutions.net> (sfid-20170523_144446_839369_E48B4EC0)
Subject: Re: [PATCH] cfg80211: make cfg80211_sched_scan_results() work from
 atomic context
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 23 May 2017 14:43:31 +0200
In-Reply-To: <1495529887-14542-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1495529887-14542-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-05-23 at 09:58 +0100, Arend van Spriel wrote:
> Drivers should be able to call cfg80211_sched_scan_results() from
> atomic
> context. However, with the introduction of multiple scheduled scan
> feature
> this requirement was not taken into account resulting in regression
> shown
> below.

Applied, thanks.

I did strip out the Modules linked in: ... garbage though :)

johannes

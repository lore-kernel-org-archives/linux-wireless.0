Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34666 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754142AbcKUMsT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 07:48:19 -0500
Message-ID: <1479732495.8662.20.camel@sipsolutions.net> (sfid-20161121_134822_695944_9AA807B7)
Subject: Re: [PATCH 2/2] nl80211: check NL80211_ATTR_SCHED_SCAN_INTERVAL
 only once
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 21 Nov 2016 13:48:15 +0100
In-Reply-To: <1479373360-1398-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1479373360-1398-1-git-send-email-arend.vanspriel@broadcom.com>
         <1479373360-1398-2-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-11-17 at 09:02 +0000, Arend van Spriel wrote:
> The presence of the NL80211_ATTR_SCHED_SCAN_INTERVAL attribute was
> checked in nl80211_parse_sched_scan() and
> nl80211_parse_sched_scan_plans() which might be a bit redundant
> so removing one.
> 
makes sense, applied.

johannes

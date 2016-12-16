Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57286 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759552AbcLPMeS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 07:34:18 -0500
Message-ID: <1481891640.27953.25.camel@sipsolutions.net> (sfid-20161216_133425_208965_63432A5C)
Subject: Re: [PATCH] nl80211: rework {sched_,}scan event related functions
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 16 Dec 2016 13:34:00 +0100
In-Reply-To: <1481887314-9471-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1481887314-9471-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-12-16 at 11:21 +0000, Arend van Spriel wrote:
> A couple of functions used with scan events were named with
> term "send" although they were only preparing the the event
> message so renamed those.

Applied - I added a mention of nl80211_send_sched_scan_results() to the
commit log since I was confused about that at first :)

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57280 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757570AbcLPMeS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 07:34:18 -0500
Message-ID: <1481891601.27953.24.camel@sipsolutions.net> (sfid-20161216_133422_712337_CC4AC4CA)
Subject: Re: [PATCH] nl80211: better describe field in struct
 nl80211_bss_select_rssi_adjust
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 16 Dec 2016 13:33:21 +0100
In-Reply-To: <1481890554-18019-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1481890554-18019-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-12-16 at 12:15 +0000, Arend van Spriel wrote:
> The two fields in struct nl80211_bss_select_rssi_adjust did not state
> their type or unit. Adding documentation.
> 
Applied, thanks :)

johannes

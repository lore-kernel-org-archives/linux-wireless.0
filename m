Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:39436 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751577AbeERJxJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 05:53:09 -0400
Message-ID: <1526637184.3805.14.camel@sipsolutions.net> (sfid-20180518_115319_999206_439F098F)
Subject: Re: [PATCH] ath10k: add dynamic vlan support
From: Johannes Berg <johannes@sipsolutions.net>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 18 May 2018 11:53:04 +0200
In-Reply-To: <63f12b0c-02e9-0ad2-28a0-d0bbc858e76a@dd-wrt.com> (sfid-20180423_211819_362504_0693E2C4)
References: <1524232653-22573-1-git-send-email-mpubbise@codeaurora.org>
         <63f12b0c-02e9-0ad2-28a0-d0bbc858e76a@dd-wrt.com>
         (sfid-20180423_211819_362504_0693E2C4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-04-23 at 21:18 +0200, Sebastian Gottschall wrote:
> this patch makes no sense at some points. AP_VLAN must be enabled always 
> (it is enabled by mac80211 by default, but is now disabled in very 
> latest git version for drivers which announce sw_crypto support)
> if its disabled wds ap / wds sta operation will not work anymore since 
> mac80211 uses AP_VLAN for the local wds sta interfaces

You'd do you well to learn the correct terminology used in Linux if you
try to communicate with us...

What you say there makes no sense, WDS is a separate mode. Maybe you
mean 4-addr mode?

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53948 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbeHOPCq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 11:02:46 -0400
Message-ID: <1534334984.3547.40.camel@sipsolutions.net> (sfid-20180815_141054_142519_C7B7F6E6)
Subject: Re: [PATCH 2/3] mac80211: Add support to notify ftm responder
 configuration to the driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Aug 2018 14:09:44 +0200
In-Reply-To: <1534293018-4930-3-git-send-email-pradeepc@codeaurora.org>
References: <1534293018-4930-1-git-send-email-pradeepc@codeaurora.org>
         <1534293018-4930-3-git-send-email-pradeepc@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-14 at 17:30 -0700, Pradeep Kumar Chitrapu wrote:
> New bss param ftm_responder is used to notify the driver to
> enable or disable fine timing request (FTM) responder role in AP mode.
> 
> + * @BSS_CHANGED_FTM_RESPONDER: fime timing reasurement request responder
> + *	functionality changed for this BSS (AP mode).

You don't really need this since it can only be configured the first
time you start the AP.

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:46992 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752715AbeC1Iwc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 04:52:32 -0400
Message-ID: <1522227148.4222.4.camel@sipsolutions.net> (sfid-20180328_105237_151109_8244F613)
Subject: Re: [RFC 2/4] nl80211/mac80211: Extend NoAck policy command with
 peer MAC address
From: Johannes Berg <johannes@sipsolutions.net>
To: vthiagar@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Date: Wed, 28 Mar 2018 10:52:28 +0200
In-Reply-To: <7031cf9c458fd53091e74dec2ee83d82@codeaurora.org>
References: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
         <1522140171-10926-3-git-send-email-vthiagar@codeaurora.org>
         <1522154870.3050.2.camel@sipsolutions.net>
         <bf1c7f4dc442e0e2807b520fe94d7ca2@codeaurora.org>
         <1522224360.4222.3.camel@sipsolutions.net>
         <7031cf9c458fd53091e74dec2ee83d82@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-03-28 at 14:20 +0530, vthiagar@codeaurora.org wrote:
> 
> > Btw, we should probably also have a way to *delete* the per-station
> > configuration, so it uses the default again?
> 
> Sure. How about setting it to default when the command is received with 
> no NL80211_ATTR_NOACK_MAP attribute for a station?

Sounds good to me.

johannes

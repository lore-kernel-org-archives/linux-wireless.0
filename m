Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:40778 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725749AbeHPLHh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Aug 2018 07:07:37 -0400
Message-ID: <1534406982.3547.55.camel@sipsolutions.net> (sfid-20180816_101054_407670_9BD21B24)
Subject: Re: [PATCH 1/3] nl80211: add support to configure FTM responder
 functionality
From: Johannes Berg <johannes@sipsolutions.net>
To: pradeepc@codeaurora.org
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Thu, 16 Aug 2018 10:09:42 +0200
In-Reply-To: <15c381ce743aedca37f3eea67975f841@codeaurora.org>
References: <1534293018-4930-1-git-send-email-pradeepc@codeaurora.org>
         <1534293018-4930-2-git-send-email-pradeepc@codeaurora.org>
         <1534334948.3547.39.camel@sipsolutions.net>
         <15c381ce743aedca37f3eea67975f841@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-08-15 at 18:48 -0700, pradeepc@codeaurora.org wrote:
> 
> Using FLAG attribute may create uncertainty to userspace especially when 
> flag attribute
> is not set and the driver supports capability, instead of 
> assuming/relying on the default
> behavior of driver/firmware.

I don't think there should be any enabling it by default in firmware,
and as such I think that's just a (separate) driver bug - I'm not
convinced we should build the API with driver bugs in mind.

johannes

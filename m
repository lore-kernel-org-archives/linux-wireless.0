Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58298 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751674AbdFVJtz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 05:49:55 -0400
Message-ID: <1498124992.2246.6.camel@sipsolutions.net> (sfid-20170622_114958_352126_3C842457)
Subject: Re: net_device::destructor patch for brcmfmac
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 22 Jun 2017 11:49:52 +0200
In-Reply-To: <3f81fbd3-2896-2b09-1d59-ae5ec88045c9@broadcom.com> (sfid-20170622_114530_618693_3E9C66A1)
References: <3f81fbd3-2896-2b09-1d59-ae5ec88045c9@broadcom.com>
         (sfid-20170622_114530_618693_3E9C66A1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-06-22 at 11:45 +0200, Arend van Spriel wrote:
> Hi Kalle,
> 
> I have a fix for brcmfmac, which is related to a change Dave made in
> struct net_device, ie. commit cf124db566e6 ("net: Fix inconsistent
> teardown and release of private netdev state."). This change is not
> in
> wireless-drivers-next, but it is in mac80211-next and thus in
> wireless-testing. What should I do? Submit to net-next, or
> mac80211-next, or will you merge net-next into wireless-drivers-next?

Actually, it's even in *net* I believe, so you should submit it to
there, or Kalle should integrate (fast-forward, rebase?) that into
wireless-drivers.

johannes
